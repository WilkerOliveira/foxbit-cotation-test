import 'dart:async';
import 'dart:convert';

import 'package:foxbit_hiring_test_template/core/exceptions/app_exceptions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum WebSocketStatus { connecting, connected, disconnected, error }

abstract class WebSocketConnection {
  void send(String method, dynamic data);
  Future<void> disconnect();
  Stream<WebSocketStatus> get status;
  Stream<Map<String, dynamic>> get stream;
  void dispose();
}

typedef WebSocketChannelFactory = WebSocketChannel Function(
  String url, {
  Duration? pingInterval,
});

class WebSocketConnectionImpl implements WebSocketConnection {
  final String _url = 'wss://api.foxbit.com.br?origin=android';
  final Duration _initialReconnectInterval = const Duration(seconds: 3);
  final Duration _heartbeatInterval = const Duration(seconds: 30);

  final WebSocketChannelFactory _channelFactory;

  WebSocketChannel? _webSocketChannel;
  Timer? _heartbeatTimer;

  final _statusController = BehaviorSubject<WebSocketStatus>();
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();

  int _id = 0;
  final int _idStepSize = 2;

  WebSocketConnectionImpl({
    WebSocketChannelFactory? channelFactory,
  }) : _channelFactory = channelFactory ?? IOWebSocketChannel.connect {
    _connect();
  }

  Future<void> _connect() async {
    try {
      if (_webSocketChannel != null && _webSocketChannel!.closeCode == null) {
        return;
      }

      _statusController.add(WebSocketStatus.connecting);
      await _webSocketChannel?.sink.close();
      _cancelTimers();

      _webSocketChannel = _channelFactory(
        _url,
        pingInterval: _heartbeatInterval,
      );

      _channelListen();

      _startHeartbeat();

      _statusController.add(WebSocketStatus.connected);
      _id = 0;
    } on Exception catch (_) {
      _statusController.add(WebSocketStatus.error);
      Future.delayed(_initialReconnectInterval, _connect);
    }
  }

  void _channelListen() {
    _webSocketChannel!.stream.listen(
      _onMessage,
      onError: (error) => _handleError(error),
      onDone: () => _handleDone(),
      cancelOnError: false,
    );
  }

  void _onMessage(dynamic message) {
    final decodedData = jsonDecode(message as String) as Map<String, dynamic>;
    _messageController.add(decodedData);
  }

  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (timer) {
      send('PING', {});
    });
  }

  Future<void> _handleError(dynamic error) async {
    _statusController.add(WebSocketStatus.error);
    _cancelTimers();
    Future.delayed(_initialReconnectInterval, _connect);
  }

  Future<void> _handleDone() async {
    _statusController.add(WebSocketStatus.disconnected);
    _cancelTimers();
    Future.delayed(_initialReconnectInterval, _connect);
  }

  void _cancelTimers() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  @override
  void send(String method, dynamic data) {
    if (_webSocketChannel != null &&
        _statusController.value == WebSocketStatus.connected) {
      try {
        final message = _prepareMessage(method, data);
        _webSocketChannel!.sink.add(message);
      } catch (e) {
        throw AppException('Failed to send data: $e');
      }
    } else {
      throw AppException('Cannot send data, connection is not active');
    }
  }

  @override
  Future<void> disconnect() async {
    _cancelTimers();
    try {
      await _webSocketChannel?.sink.close();
      _statusController.add(WebSocketStatus.disconnected);
    } on Exception catch (e) {
      throw AppException('Failed to close connection: $e');
    }
  }

  @override
  Stream<WebSocketStatus> get status => _statusController.stream;
  @override
  Stream<Map<String, dynamic>> get stream => _messageController.stream;

  String _prepareMessage(String method, dynamic objectData) {
    final Map data = {
      "m": 0,
      "i": _id,
      "n": method,
      "o": json.encode(objectData),
    };

    _id += _idStepSize;

    return json.encode(data);
  }

  @override
  void dispose() {
    _heartbeatTimer?.cancel();
    _webSocketChannel?.sink.close();
    _statusController.close();
    _messageController.close();
  }
}

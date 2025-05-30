import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/core/connections/web_socket/websocket_connection.dart';
import 'package:foxbit_hiring_test_template/core/exceptions/app_exceptions.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MockIOWebSocketChannel extends Mock implements IOWebSocketChannel {}

class MockWebSocketSink extends Mock implements WebSocketSink {}

void main() {
  group('WebSocketConnectionImpl', () {
    late WebSocketConnection webSocketConnection;
    late MockIOWebSocketChannel mockWebSocketChannel;
    late MockWebSocketSink mockWebSocketSink;
    late StreamController<dynamic> channelStreamController;

    late WebSocketChannelFactory mockChannelFactory;

    setUpAll(() {
      registerFallbackValue('');
      registerFallbackValue({});
      registerFallbackValue(const Duration(seconds: 1));

      registerFallbackValue(
        Uri.parse(
          'ws://teste.com',
        ),
      );
    });

    setUp(() async {
      channelStreamController = StreamController<dynamic>();
      mockWebSocketChannel = MockIOWebSocketChannel();
      mockWebSocketSink = MockWebSocketSink();

      when(() => mockWebSocketChannel.sink).thenReturn(mockWebSocketSink);
      when(() => mockWebSocketChannel.stream)
          .thenAnswer((_) => channelStreamController.stream);
      when(() => mockWebSocketChannel.closeCode).thenReturn(null);
      when(() => mockWebSocketSink.close(any(), any()))
          .thenAnswer((_) async {});

      mockChannelFactory = (url, {pingInterval}) {
        return mockWebSocketChannel;
      };
    });

    tearDown(() async {
      await Future.delayed(Duration.zero);
      await pumpEventQueue();

      await Future.delayed(Duration.zero);
      await channelStreamController.close();
    });

    void initAll() {
      mockWebSocketChannel = MockIOWebSocketChannel();
      mockWebSocketSink = MockWebSocketSink();
      channelStreamController = StreamController<dynamic>();

      when(() => mockWebSocketChannel.sink).thenReturn(mockWebSocketSink);
      when(() => mockWebSocketChannel.stream)
          .thenAnswer((_) => channelStreamController.stream);
      when(() => mockWebSocketChannel.closeCode).thenReturn(null);
      when(() => mockWebSocketSink.close(any(), any()))
          .thenAnswer((_) => Future.value());
    }

    Future<void> simulateSuccessfulConnection() async {
      initAll();

      mockChannelFactory = (url, {pingInterval}) {
        return mockWebSocketChannel;
      };

      webSocketConnection = WebSocketConnectionImpl(
        channelFactory: mockChannelFactory,
      );

      await Future.delayed(Duration.zero);
      await pumpEventQueue();
      expect(await webSocketConnection.status.first, WebSocketStatus.connected);
    }

    test(
        'should initially be connecting and then connected on successful connection',
        () async {
      initAll();

      mockChannelFactory = (url, {pingInterval}) {
        return mockWebSocketChannel;
      };

      final localWebSocketConnection = WebSocketConnectionImpl(
        channelFactory: mockChannelFactory,
      );

      expect(
        localWebSocketConnection.status,
        emitsInOrder([
          WebSocketStatus.connecting,
          WebSocketStatus.connected,
        ]),
      );

      await Future.delayed(Duration.zero);
      await pumpEventQueue();

      await channelStreamController.close();
      localWebSocketConnection.dispose();
    });

    test('send should add message to sink when connected', () async {
      await simulateSuccessfulConnection();

      const method = 'HELLO';
      final data = {'key': 'value'};
      final expectedMessage = json.encode({
        "m": 0,
        "i": 0,
        "n": method,
        "o": json.encode(data),
      });

      webSocketConnection.send(method, data);

      verify(() => mockWebSocketSink.add(expectedMessage)).called(1);
    });

    test('send should increment id correctly', () async {
      await simulateSuccessfulConnection();

      const method = 'HELLO';
      final data = {'key': 'value'};

      webSocketConnection.send(method, data);
      webSocketConnection.send(method, data);

      verify(() => mockWebSocketSink.add(any(that: contains('"i":2'))))
          .called(1);
      verify(() => mockWebSocketSink.add(any(that: contains('"i":0'))))
          .called(1);
    });

    test('send should throw AppException if not connected', () async {
      await simulateSuccessfulConnection();

      await webSocketConnection.disconnect();
      await pumpEventQueue();

      expect(
        () => webSocketConnection.send('METHOD', {}),
        throwsA(
          isA<AppException>(),
        ),
      );
    });

    test('stream should emit decoded messages', () async {
      await simulateSuccessfulConnection();

      final testMessage = {'event': 'data', 'payload': 123};
      final jsonString = jsonEncode(testMessage);

      final messageCompleter = Completer<Map<String, dynamic>>();
      webSocketConnection.stream.listen(messageCompleter.complete);

      channelStreamController.add(jsonString);
      await Future.delayed(Duration.zero);

      expect(await messageCompleter.future, testMessage);
    });
  });
}

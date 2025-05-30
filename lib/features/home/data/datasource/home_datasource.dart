import 'package:foxbit_hiring_test_template/core/connections/web_socket/websocket_connection.dart';

abstract class HomeDatasource {
  Stream<Map<String, dynamic>> getInstruments();
  void subscribeToQuote(int instrumentId);
  void dispose();
}

class HomeDatasourceImpl implements HomeDatasource {
  HomeDatasourceImpl(this._socket);

  final WebSocketConnection _socket;

  @override
  Stream<Map<String, dynamic>> getInstruments() {
    _socket.send(
      'getInstruments',
      {},
    );

    return _socket.stream;
  }

  @override
  void subscribeToQuote(int instrumentId) {
    _socket.send(
      'SubscribeLevel1',
      {"InstrumentId": instrumentId},
    );
  }

  @override
  void dispose() {
    _socket.disconnect();
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/core/connections/web_socket/websocket_connection.dart';
import 'package:foxbit_hiring_test_template/features/home/data/datasource/home_datasource.dart';
import 'package:mocktail/mocktail.dart';

class MockWebSocketConnection extends Mock implements WebSocketConnection {}

void main() {
  late MockWebSocketConnection mockSocket;
  late HomeDatasource datasource;
  const stream = Stream<Map<String, dynamic>>.empty();
  setUp(() {
    mockSocket = MockWebSocketConnection();
    datasource = HomeDatasourceImpl(mockSocket);

    when(() => mockSocket.send('getInstruments', any())).thenReturn(null);
    when(() => mockSocket.stream).thenAnswer((_) => stream);
  });

  group('Home Datasource', () {
    test('getInstruments should send getInstruments and return socket stream',
        () {
      final result = datasource.getInstruments();

      verify(() => mockSocket.send('getInstruments', {})).called(1);
      expect(result, stream);
    });

    test('subscribeToQuote should send SubscribeLevel1 with instrumentId', () {
      when(() => mockSocket.send(any(), any())).thenReturn(null);

      datasource.subscribeToQuote(1);

      verify(() => mockSocket.send('SubscribeLevel1', {"InstrumentId": 1}))
          .called(1);
    });

    test('dispose should call disconnect on socket', () {
      when(() => mockSocket.disconnect()).thenAnswer(Future.value);

      datasource.dispose();

      verify(() => mockSocket.disconnect()).called(1);
    });
  });
}

enum Instruments {
  bitcoin(1, 'Bitcoin'),
  xrp(10, 'XRP'),
  trueUSD(6, 'TrueUSD'),
  ethereum(4, 'Ethereum'),
  litecoin(2, 'Litecoin');

  const Instruments(this.instrumentId, this.name);

  final int instrumentId;
  final String name;

  static String getName(int id) {
    return Instruments.values
        .firstWhere(
          (e) => e.instrumentId == id,
        )
        .name;
  }
}

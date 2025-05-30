String formatVariationPrice(double variation) {
  return '${variation > 0 ? '+' : ''}${variation.toStringAsFixed(2)}';
}

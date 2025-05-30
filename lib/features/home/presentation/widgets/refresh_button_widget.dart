import 'package:flutter/material.dart';

class RefreshButtonWidget extends StatelessWidget {
  const RefreshButtonWidget({super.key, required this.onRefresh});
  final void Function() onRefresh;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onRefresh,
      label: const Text('Atualizar'),
      icon: const Icon(Icons.refresh),
    );
  }
}

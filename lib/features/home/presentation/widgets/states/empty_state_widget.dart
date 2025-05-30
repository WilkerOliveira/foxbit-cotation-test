import 'package:flutter/material.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/widgets/refresh_button_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key, required this.onRefresh});
  final void Function() onRefresh;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Não encontramos nenhuma moeda no momento. Tentar novamente?',
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 16),
        RefreshButtonWidget(
          onRefresh: onRefresh,
        ),
      ],
    );
  }
}

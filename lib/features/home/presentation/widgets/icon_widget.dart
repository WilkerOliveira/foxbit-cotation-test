import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  const IconWidget({super.key, required this.instrumentId});

  final int instrumentId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 45,
      child: Image.asset(
        'assets/images/$instrumentId.png',
      ),
    );
  }
}

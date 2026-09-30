import 'package:flutter/material.dart';

class ProgressSummary extends StatelessWidget {
  const ProgressSummary({
    super.key,
    required this.gameCount,
    required this.objectiveCount,
  });

  final int gameCount;
  final int objectiveCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text('$gameCount games'), Text('$objectiveCount objectives')],
    );
  }
}

import 'package:flutter/material.dart';

class DiceImg extends StatelessWidget {
  final int diceNum;

  const DiceImg({super.key, required this.diceNum});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset("assets/images/dice$diceNum.png", width: 120),
    );
  }
}

import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import '../Widgets/dice_img.dart';
import 'package:audioplayers/audioplayers.dart';

class DiceScreen extends StatefulWidget {
  const DiceScreen({super.key});

  @override
  State<DiceScreen> createState() {
    return _DiceScreenState();
  }
}

class _DiceScreenState extends State<DiceScreen>
    with SingleTickerProviderStateMixin {
  int leftDice = 1;
  int rightDice = 1;
  bool rolling = false;
  late AnimationController controller;
  late Animation<double> rotationAnimation;
  late Animation<double> reverserotationAnimation;
  late Animation<double> bounceAnimation;
  late Animation<double> scaleAnimation;
  final Random random = Random();
  final List<String> diceSounds = [
    'sounds/dice_roll1.mp3',
    'sounds/dice_roll2.mp3',
  ];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    rotationAnimation = Tween<double>(
      begin: 0,
      end: 5,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    reverserotationAnimation = Tween<double>(
      begin: 0,
      end: -5,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.deepPurpleAccent],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: bounceAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, bounceAnimation.value),
                        child: child,
                      );
                    },
                    child: RotationTransition(
                      turns: rotationAnimation,
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        child: DiceImg(diceNum: leftDice),
                      ),
                    ),
                  ),

                  const SizedBox(width: 30),

                  AnimatedBuilder(
                    animation: bounceAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, bounceAnimation.value),
                        child: child,
                      );
                    },

                  child: RotationTransition(
                    turns: reverserotationAnimation,
                    child: ScaleTransition(scale: scaleAnimation,
                      child: DiceImg(diceNum: rightDice),),
                  ),),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (rolling) return;

                  final player = AudioPlayer();

                  String selectedSound =
                      diceSounds[random.nextInt(diceSounds.length)];

                  setState(() {
                    rolling = true;
                  });
                  controller.forward(from: 0);

                  player.play(AssetSource(selectedSound));


                  int count = 0;
                  Timer.periodic(const Duration(milliseconds: 30), (timer) {
                    bool stop = false;
                    setState(() {
                      leftDice = random.nextInt(6) + 1;
                      rightDice = random.nextInt(6) + 1;

                      count++;

                      if (count >= 33) {
                        stop = true;
                        controller.reset();
                        rolling = false;
                      }
                    });
                    if (stop) {
                      timer.cancel();
                      player.dispose();
                    }
                  });
                },
                child: Text(
                  rolling ? "Rolling..." : "Roll Dice",
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

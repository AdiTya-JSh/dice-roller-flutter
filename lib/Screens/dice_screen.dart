import 'dart:ffi';
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

    rotationAnimation =Tween<double>(
      begin: 0,
      end: 5,
    ).animate(
      CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut
      ),);
    
    
    reverserotationAnimation = Tween<double>(
      begin: 0,
      end: -5,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );
    

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
                  RotationTransition(
                      turns: rotationAnimation,
                  child: DiceImg(diceNum: leftDice),),
                  
                  const SizedBox(width: 30),

                  RotationTransition(turns: reverserotationAnimation,
                  child: DiceImg(diceNum: rightDice),),
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
                    controller.forward(from: 0);
                  });

                  await player.play(AssetSource(selectedSound));

                  await player.dispose();

                  int count = 0;
                  Timer.periodic(const Duration(milliseconds: 30), (timer) {
                    bool stop = false;
                    setState(() {
                      leftDice = random.nextInt(6) + 1;
                      rightDice = random.nextInt(6) + 1;

                      count++;

                      if (count >= 33) {
                        stop = true;
                        rolling = false;
                      }
                    });
                    if (stop) {
                      timer.cancel();
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

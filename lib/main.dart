import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'Widgets/dice_img.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  int leftDice = 1;
  int rightDice = 1;
  bool rolling = false;
  final Random random = Random();
  // final AudioPlayer player = AudioPlayer();
  final List<String> diceSounds = [
    'sounds/dice_roll1.mp3',
    'sounds/dice_roll2.mp3'
  ];

  // @override
  // void initState(){
  //   super.initState();
  //   player.setReleaseMode(ReleaseMode.stop);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
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
                    DiceImg(diceNum: leftDice),
                    const SizedBox(width: 20),
                    DiceImg(diceNum: rightDice),

                  ],
                ),

                const SizedBox(height: 20),




                ElevatedButton(
                  onPressed: () async {

                    if(rolling) return;

                    final player = AudioPlayer();


                    String selectedSound = diceSounds[random.nextInt(diceSounds.length)];

                    setState(() {
                      rolling = true;
                    });

                    await player.play(
                      AssetSource(selectedSound),);

                    await player.dispose();

                    int count =0;
                    Timer.periodic(
                        const Duration(milliseconds: 100),
                        (timer){
                          bool stop = false;
                          setState(() {
                            leftDice = random.nextInt(6) + 1;
                            rightDice = random.nextInt(6) + 1;

                            count++;

                            if(count>=10){
                              stop = true;
                              rolling = false;
                            }
                          });
                         if(stop){
                           timer.cancel();
                         }
                        },
                    );
                  },
                  child: Text(
                    rolling? "Rolling..." : "Roll Dice",
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// @override
// Widget build(BuildContext cont){
//   return MaterialApp(home: Scaffold(body: Center(
//     child: Text("bleh",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 22),) ,
//   ),),);
// }

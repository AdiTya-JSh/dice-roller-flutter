import 'package:flutter/material.dart';
import 'dart:math';

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
  final Random random = Random();

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
                    Image.asset("assets/images/dice$leftDice.png", width: 120),

                    const SizedBox(width: 20),

                    Image.asset("assets/images/dice$rightDice.png", width: 120),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      leftDice = random.nextInt(6) + 1;
                      rightDice = random.nextInt(6) + 1;
                    });
                  },
                  child: const Text(
                    "Roll Dice",
                    style: TextStyle(fontSize: 22),
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

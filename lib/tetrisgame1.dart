import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris_game/tetrisshapes.dart';

void main() {
  runApp(const AppTetris());
}

class AppTetris extends StatelessWidget {
  const AppTetris({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TetrisGame(),
    );
  }
}

class TetrisGame extends StatefulWidget {
  TetrisGame({super.key});

  @override
  State<TetrisGame> createState() => _TetrisGameState();
}

class _TetrisGameState extends State<TetrisGame> {
  late TetrimonosShape nextShape;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      nextShape = TetrimonosShapes
          .shapes[Random().nextInt(TetrimonosShapes.shapes.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tetris App'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: height,
        width: height,
        decoration: const BoxDecoration(color: Colors.white),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          //first container to show the tetris shape that is coming
          Container(
            height: height * 0.1,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TetrisBlock(
                  color: nextShape.color,
                  shape: nextShape.getShape(),
                ),
                TetrisBlock(
                  color: nextShape.color,
                  shape: nextShape.getShape(),
                ),
                TetrisBlock(
                  color: nextShape.color,
                  shape: nextShape.getShape(),
                ),
                TetrisBlock(
                  color: nextShape.color,
                  shape: nextShape.getShape(),
                ),
                TetrisBlock(
                  color: nextShape.color,
                  shape: nextShape.getShape(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          //second container to show the tetris game dropping and all
          Container(
              height: height * 0.6,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(6),
              ),
              child: TetrisBoard()),
          const SizedBox(
            height: 8,
          ),
          //third container to show the score
          Container(
            height: height * 0.1,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ]),
      ),
    );
  }
}

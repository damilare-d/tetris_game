import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris_game/tetrisshapes.dart';

import 'models/shapes.dart';
import 'widgets/tetris_block.dart';

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
        width: width,
        // decoration: const BoxDecoration(
        //   color: Colors.black,
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //first container to show the tetris shape that is coming
            Container(
              padding: const EdgeInsets.all(8.0),
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
                    color: nextShape.getRandomShape().color,
                    shape: nextShape.getRandomShape().shape,
                  ),
                  TetrisBlock(
                    color: nextShape.getRandomShape().color,
                    shape: nextShape.getRandomShape().shape,
                  ),
                  TetrisBlock(
                    color: nextShape.getRandomShape().color,
                    shape: nextShape.getRandomShape().shape,
                  ),
                  TetrisBlock(
                    color: nextShape.getRandomShape().color,
                    shape: nextShape.getRandomShape().shape,
                  ),
                  TetrisBlock(
                    color: nextShape.getRandomShape().color,
                    shape: nextShape.getRandomShape().shape,
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
              width: width,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(6),
              ),
              child: TetrisBoard(),
            ),
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
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris_game/tetris_board.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tetris App'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: height,
          width: width,
          // decoration: const BoxDecoration(
          //   color: Colors.black,
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //first container to show the tetris shape that is coming
              SizedBox(
                height: height * 0.1,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
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
              ),
              // SizedBox(
              //   height: height * 0.033,
              // ),
              //second container to show the tetris game dropping and all
              SizedBox(
                height: height * 0.8,
                // width: width * 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TetrisBoard(
                    height: height * 0.8,
                    width: 300,
                  ),
                ),
              ),
              // SizedBox(
              //   height: height * 0.033,
              // ),
              //third container to show the score
              SizedBox(
                height: height * 0.1,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              // SizedBox(
              //   height: height * 0.033,
              // ),
            ],
          ),
        );
      }),
    );
  }
}

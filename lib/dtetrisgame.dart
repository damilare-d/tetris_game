import 'dart:math';

import 'package:flutter/material.dart';

import 'package:tetris_game/tetrisshapes.dart';

import 'package:tetris_game/dtetrisboard.dart';

class Tetromino {
  final TetrimonosShape shape;
  final Point<int> position;
  final Color color;

  Tetromino({
    required this.shape,
    required this.position,
    required this.color,
  });

  factory Tetromino.random() {
    final randomShape = TetrimonosShapes.shapes[
        DateTime.now().millisecondsSinceEpoch % TetrimonosShapes.shapes.length];

    return Tetromino(
      shape: randomShape,
      position: Point(0, randomShape.getShape().length * -1),
      color: randomShape.color,
    );
  }

  Tetromino copyWith({
    TetrimonosShape? shape,
    Point<int>? position,
    Color? color,
  }) {
    return Tetromino(
      shape: shape ?? this.shape,
      position: position ?? this.position,
      color: color ?? this.color,
    );
  }
}

class TetrisGrid extends StatelessWidget {
  final List<List<bool>> board;

  TetrisGrid({required this.board});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: board.length * board[0].length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: board[0].length,
      ),
      itemBuilder: (BuildContext context, int index) {
        int x = index % board[0].length;
        int y = (index / board[0].length).floor();

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: board[y][x] ? Colors.grey : Colors.white,
          ),
        );
      },
    );
  }
}

class TetrominoWidget extends StatelessWidget {
  final Tetromino tetromino;

  TetrominoWidget({required this.tetromino});

  @override
  Widget build(BuildContext context) {
    List<List<bool>> shape = tetromino.shape.getShape();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: shape.length * shape[0].length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: shape[0].length,
      ),
      itemBuilder: (BuildContext context, int index) {
        int x = index % shape[0].length;
        int y = (index / shape[0].length).floor();

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: shape[y][x] ? tetromino.color : Colors.transparent,
          ),
        );
      },
    );
  }
}

class TetrisGame extends StatelessWidget {
  const TetrisGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //TetrisGrid(board: Board.board),
        TetrominoWidget(tetromino: tetris.currentTetromino),
      ],
    );
  }
}

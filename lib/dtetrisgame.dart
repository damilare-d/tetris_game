import 'dart:math';

import 'package:flutter/material.dart';

import 'components/shapes.dart';

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

import 'dart:math';

import 'package:flutter/material.dart';

//created a model class for a shape
//this has the basic parameter of shape and color

class TetrimonosShape {
  final List<List<bool>> shape;
  final Color color;

  const TetrimonosShape({required this.shape, required this.color});

  List<List<bool>> getShape() => shape;

  TetrimonosShape getRandomShape() {
    return TetrimonosShapes.shapes[Random().nextInt(
      TetrimonosShapes.shapes.length,
    )];
  }
}

//created a model for every shape in the game
//with the model class shape as property
class TetrimonosShapes {
  static List<TetrimonosShape> shapes = [
    //for the i shape
    const TetrimonosShape(shape: [
      [true, true, true, true]
    ], color: Colors.purple),
    //for the box shape
    const TetrimonosShape(shape: [
      [true, true],
      [true, true]
    ], color: Colors.indigo),
    //for the key in shape
    const TetrimonosShape(shape: [
      [false, true, false],
      [true, true, true]
    ], color: Colors.yellow),
    //for the l shaped
    const TetrimonosShape(shape: [
      [false, true, true],
      [true, true, false]
    ], color: Colors.green),
    const TetrimonosShape(shape: [
      [true, true, false],
      [false, true, true]
    ], color: Colors.red),
    const TetrimonosShape(shape: [
      [true, true, true],
      [false, false, true]
    ], color: Colors.blue),
    const TetrimonosShape(shape: [
      [true, true, true],
      [true, false, false]
    ], color: Colors.orange)
  ];

  static List<Color> get colors => shapes.map((shape) => shape.color).toList();
  static List<List<List<bool>>> get shape =>
      shapes.map((shape) => shape.shape).toList();
}

class TetriminoBlock {
  Color color;
  Offset position;
  List<List<bool>> shape;

  TetriminoBlock({
    required this.color,
    required this.shape,
    required this.position,
  });

  void moveDown() {
    position += Offset(0, 1);
  }

  void moveLeft() {
    position += Offset(-1, 0);
  }

  void moveRight() {
    position += Offset(1, 0);
  }

  void rotateClockwise() {
    shape = List.generate(
      shape[0].length,
      (i) => List.generate(
        shape.length,
        (j) => shape[shape.length - j - 1][i],
      ),
    );
  }

  void rotateCounterClockwise() {
    shape = List.generate(
      shape[0].length,
      (i) => List.generate(
        shape.length,
        (j) => shape[j][shape[0].length - i - 1],
      ),
    );
  }

  void lock() {}
}

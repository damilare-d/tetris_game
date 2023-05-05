import 'package:flutter/material.dart';

//created a model class for a shape
//this has the basic parameter of shape and color
class TetrimonosShape {
  final List<List<bool>> shape;
  final Color color;

  const TetrimonosShape({required this.shape, required this.color});

  List<List<bool>> getShape() => shape;
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
}

int currentTetrominoIndex = 0; 

// class Tetromino extends StatelessWidget {
//   final TetrimonosShape shape;
//   const Tetromino({required this.shape});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: shape
//           .getShape()
//           .map((row) => Row(
//                 children: row
//                     .map((filled) => Container(
//                           width: 20,
//                           height: 20,
//                           decoration: BoxDecoration(
//                               color: filled ? shape.color : Colors.transparent,
//                               border: Border.all(color: Colors.grey.shade300)),
//                         ))
//                     .toList(),
//               ))
//           .toList(),
//     );
//   }
// }

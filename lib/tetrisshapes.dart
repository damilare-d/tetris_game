import 'dart:math';

import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

import 'dart:async';

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

class TetrisBlock extends StatelessWidget {
  final List<List<bool>> shape;
  final Color color;

  const TetrisBlock({super.key, required this.shape, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: shape
          .map((row) => Row(
                children: row
                    .map((isFilled) => Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: isFilled ? color : Colors.transparent,
                              border: isFilled
                                  ? Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    )
                                  : const Border()),
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }
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

class TetrisBoard extends StatefulWidget {
  const TetrisBoard({super.key});

  @override
  State<TetrisBoard> createState() => _TetrisBoardState();
}

class _TetrisBoardState extends State<TetrisBoard> {
  List<List<TetriminoBlock?>> board = [];
  List<TetriminoBlock> activeBlocks = [];
  TetriminoBlock? currentBlock;
  TetrimonosShapes tetrimonosShapes = TetrimonosShapes();
  int boardHeight = 720;
  int boardWidth = 340;
  bool gameOver = false;
  int _score = 0;
  int _level = 1;
  int numlinesCleared = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initBoard();
    spawnBlock();
  }

  void _startGame() {
    currentBlock = spawnBlock();
    updateBoard();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      boardHeight = constraints.maxHeight.floor();
      boardWidth = constraints.maxHeight.floor();
      int gridCount = (boardHeight * boardWidth / 440).floor();

      final blockSize = MediaQuery.of(context).size.width / (boardWidth + 2);
      return Center(
        child: GestureDetector(
            onPanUpdate: (details) {
              //we first get the horizontal distance and vertical
              //distance moved by the user
              double dx = details.delta.dx;
              double dy = details.delta.dy;

              //then we check if the horizontal distance moved
              //is greater than the vertical distance moved
              if (dx.abs() > dy.abs()) {
                //move the tetromino left or right based on the
                //horizontal distance moved
                if (dx > 0) {
                  currentBlock!.moveRight();
                } else {
                  currentBlock!.moveLeft();
                }
              } else {
                if (dy > 0) {
                  currentBlock!.rotateClockwise();
                } else {
                  currentBlock!.rotateCounterClockwise();
                }
              }
            },
            child: SizedBox(
              height: boardHeight.toDouble(),
              width: boardWidth.toDouble(),
              // color: Colors.yellow[800],
              child: GridView.builder(
                // physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: gridCount,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (boardWidth / 20).toInt(),
                  childAspectRatio: 1,
                  mainAxisSpacing: 0.5,
                  crossAxisSpacing: 0.5,
                ),
                itemBuilder: (context, index) {
                  final row = index ~/ boardWidth;
                  final col = index % boardWidth;
                  TetriminoBlock? block;
                  late Color color;
                  if (row < board.length && col < board[row].length) {
                    block = board[row][col];
                    color = block?.color ?? Colors.white;
                  } else {
                    color = Colors.white;
                  }

                  return TetrisBlock(
                    color: color,
                    shape: block?.shape ?? const [],
                  );
                },
              ),
            )),
      );
    });
  }

  void initBoard() {
    //this is to create an empty board
    for (int i = 0; i < 20; i++) {
      board.add(List.generate(10, (index) => null));
    }
  }

  spawnBlock() {
    //choose a random block shape
    TetriminoBlock block = TetriminoBlock(
      color: TetrimonosShapes
          .colors[Random().nextInt(TetrimonosShapes.colors.length)],
      shape: TetrimonosShapes
          .shape[Random().nextInt(TetrimonosShapes.colors.length)],
      position: Offset(Random().nextInt(boardWidth - 4).toDouble(), 0),
    );
    return block;
  }

  void updateBoard() {
    if (currentBlock != null) {
      // Check for collision with the bottom of the board or other blocks
      if (isColliding(activeBlocks)) {
        lockBlock(activeBlocks);
        clearLines();
        currentBlock = spawnBlock();
        if (isColliding(activeBlocks)) {
          gameOver = true;
        }
      } else {
        // Move the current block down
        currentBlock!.moveDown();
      }
    }

    // Update the board
    board = List.generate(
      boardHeight,
      (row) => List.generate(
        boardWidth,
        (col) {
          final block = board[row][col];
          if (block != null) {
            return block;
          } else if (currentBlock != null &&
              currentBlock!.shape[row - currentBlock!.position.dy.toInt()]
                  [col - currentBlock!.position.dx.toInt()]) {
            return TetriminoBlock(
              color: currentBlock!.color,
              shape: currentBlock!.shape,
              position: currentBlock!.position,
            );
          } else {
            return null;
          }
        },
      ),
    );
    setState(() {});
  }

  bool isColliding(List<TetriminoBlock> blocks) {
    for (var block in blocks) {
      var row = block.position.dy.floor();
      var col = block.position.dx.floor();

      if (row < 0 || col < 0 || row >= boardHeight || col >= boardWidth) {
        return true;
      }

      if (board[row][col] != null) {
        return true;
      }
    }
    return false;
  }

  void lockBlock(List<TetriminoBlock> blocks) {
    for (var block in blocks) {
      var row = block.position.dy.floor();
      var col = block.position.dx.floor();

      board[row][col] = block.color as TetriminoBlock?;
    }
  }

  int clearLines() {
    var numLinesCleared = 0;

    for (var i = 0; i < boardHeight; i++) {
      if (board[i].every((color) => color != null)) {
        board.removeAt(i);
        board.insert(0, List.filled(boardWidth, null));
        numLinesCleared++;
      }
    }

    return numLinesCleared;
  }
}

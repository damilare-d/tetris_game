import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'enums/shape_types.dart';
import 'models/shapes.dart';
import 'models/tetris_shape.dart';

class TetrisBoard extends StatefulWidget {
  final double width, height;
  const TetrisBoard({super.key, required this.height, required this.width});

  @override
  State<TetrisBoard> createState() => _TetrisBoardState();
}

class _TetrisBoardState extends State<TetrisBoard> {
  final int gridHorizontalCount = 30;
  final int gridVerticalCount = 50;
  late final int gridCount = gridHorizontalCount * gridVerticalCount;
  List<List<TetriminoBlock?>> board = [];
  List<TetriminoBlock> activeBlocks = [];
  Map<int, Color?> colorMap = {};
  TetriminoBlock? currentBlock;
  TetrimonosShapes tetrimonosShapes = TetrimonosShapes();
  bool gameOver = false;
  int numlinesCleared = 0;
  late TetrisShape movingShape = TetrisShape(
      rowCount: gridHorizontalCount,
      firstBlock: 15,
      type: ShapeType.i,
      color: Colors.red);
  late List<TetrisShape> stationaryShapes = [
    TetrisShape(
        rowCount: gridHorizontalCount,
        firstBlock: 1380,
        type: ShapeType.i,
        color: Colors.blue)
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (movingShape.baseBlock < 1485) {
        print("Moving shape: ${movingShape.baseBlock}");
        colorMap.addEntries(movingShape.indexes.map((e) => MapEntry(e, null)));
        movingShape.moveDown();
        colorMap.addEntries(
            movingShape.indexes.map((e) => MapEntry(e, movingShape.color)));
        setState(() {});
      }
    });

    initBoard();
    spawnBlock();
  }

  void _startGame() {
    currentBlock = spawnBlock();
    updateBoard();
  }

  @override
  Widget build(BuildContext context) {
    final List<int> blocks = [];
    for (TetrisShape shape in stationaryShapes) {
      blocks.addAll(shape.indexes);
      colorMap.addEntries(shape.indexes.map((e) => MapEntry(e, shape.color)));
    }
    double gridWidth =
        (widget.height / gridVerticalCount) * gridHorizontalCount;
    double gridHeight = widget.height;

    final blockSize = MediaQuery.of(context).size.width / (widget.width + 2);
    return GestureDetector(
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
        height: gridHeight,
        width: gridWidth,
        // color: Colors.yellow[800],
        child: Builder(builder: (context) {
          return MyGrid(
              crossAxisCount: gridHorizontalCount,
              children: List.generate(
                  gridVerticalCount * gridHorizontalCount,
                  (index) => Container(
                        color: colorMap[index] ?? Colors.black,
                        height: gridHeight / gridVerticalCount,
                        width: gridHeight / gridVerticalCount,
                      )));
        }),
      ),
    );
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
      position:
          Offset(Random().nextInt(widget.width.toInt() - 4).toDouble(), 0),
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
      widget.height.toInt(),
      (row) => List.generate(
        widget.width.toInt(),
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

      if (row < 0 || col < 0 || row >= widget.height || col >= widget.width) {
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

    for (var i = 0; i < widget.height; i++) {
      if (board[i].every((color) => color != null)) {
        board.removeAt(i);
        board.insert(0, List.filled(widget.width.toInt(), null));
        numLinesCleared++;
      }
    }

    return numLinesCleared;
  }
}

class MyGrid extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;

  const MyGrid({Key? key, required this.children, required this.crossAxisCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          List.generate((children.length / crossAxisCount).ceil(), (index) {
        return Row(
            children: List.generate(
                crossAxisCount, (i) => children[(index * crossAxisCount) + i]));
      }),
    );
  }
}

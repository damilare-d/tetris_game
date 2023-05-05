import 'package:flutter/material.dart';
import 'tetrisshapes.dart';
import 'dart:async';
import 'dart:math';


class TetrisGamify extends StatefulWidget {
  const TetrisGamify({super.key});

  @override
  State<TetrisGamify> createState() => _TetrisGamifyState();
}

class _TetrisGamifyState extends State<TetrisGamify> {
  @override
  Widget build(BuildContext context) {
    return TetrominoWidget(
      board: [],
      onBoardUpdate: ,
      shape: ,
    );
  }
}

class TetrominoWidget extends StatefulWidget {
  final TetrimonosShape shape = TetrimonosShape(shape: TetrimonosShapes.shapes[0].shape, color: TetrimonosShapes.shapes[1].color);
  final List<List<bool>> board = [];
  final ValueChanged<List<List<bool>>> onBoardUpdate ;

  TetrominoWidget({ this.shape, required this.board, required this.onBoardUpdate});

  @override
  _TetrominoWidgetState createState() => _TetrominoWidgetState();
}

class _TetrominoWidgetState extends State<TetrominoWidget> {
Point<int> _position = Point(0, 0);
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        _position += Point(0, 1);

        if (_isCollision()) {
          _position -= Point(0, 1);
          _lockTetromino();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  bool _isCollision() {
    for (int i = 0; i < widget.shape.getShape().length; i++) {
      for (int j = 0; j < widget.shape.getShape()[i].length; j++) {
        if (widget.shape.getShape()[i][j]) {
          int x = _position.x + j;
          int y = _position.y + i;
          if (y >= widget.board.length || x < 0 || x >= widget.board[y].length || widget.board[y][x]) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void _lockTetromino() {
    for (int i = 0; i < widget.shape.getShape().length; i++) {
      for (int j = 0; j < widget.shape.getShape()[i].length; j++) {
        if (widget.shape.getShape()[i][j]) {
          widget.board[_position.y + i][_position.x + j] = true;
        }
      }
    }
    widget.onBoardUpdate(widget.board);
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: _position.y * 20,
          left: _position.x * 20,
          child: Column(
            children: widget.shape
                .getShape()
                .asMap()
                .map((key, filled) => MapEntry(
                      key,
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: filled ? widget.shape.color : Colors.transparent,
                            border: Border.all(color: Colors.grey.shade300)),
                      ),
                    ))
                .values
                .toList(),
          ),
        ),
      ],
    );
  }
}

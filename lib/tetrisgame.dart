import 'dart:async';
import 'dart:math' as po;

import 'package:flutter/material.dart';
import 'package:tetris_game/tetrisLogic.dart';

import 'components/shapes.dart';

class TetrisGame extends StatefulWidget {
  final TetrimonosShape shape;
  const TetrisGame({
    required this.shape,
  });

  @override
  _TetrisGameState createState() => _TetrisGameState();
}

class _TetrisGameState extends State<TetrisGame> {
  List<List<bool>> _board = [];
  po.Point<int> _position = const po.Point<int>(0, 0);

  @override
  void initState() {
    super.initState();
    const timeInterval = Duration(seconds: 1);
    Timer.periodic(timeInterval, (timer) {
      setState(() {
        _position += const po.Point(0, 1);

        if (canMoveTetriminoDown()) {
          _position -= po.Point(0, 1);
          lockTetromino(widget.shape, board, _position);
          timer.cancel();
        }
      });
    });

    // boardController.stream.listen((event) {
    //   print('board updated : $board');
    //   setState(() {
    //     _board = event;
    //   });
    // });
    // tetrominoPositionController.stream.listen((Point point) {
    //   print("Point Updated: $point");
    //   setState(() {
    //     _position = po.Point(point.row, point.col);
    //   });
    // });
    startGameA();
  }

  void _moveDown() {
    setState(() {
      _position = po.Point<int>(_position.x, _position.y + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: _position.x * MediaQuery.of(context).size.height / 20,
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
                            color: key == _position.x
                                ? widget.shape.color
                                : Colors.transparent,
                            border: Border.all(color: Colors.grey.shade300)),
                      ),
                    ))
                .values
                .toList()
              ..insert(
                0,
                Container(
                  height: _position.y * 20,
                  child: const SizedBox(
                    width: 20,
                  ),
                ),
              ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../enums/shape_types.dart';

class TetrisShape {
  int rowCount;
  ShapeType type;
  int firstBlock;
  List<_Block> _blocks = List<_Block>.from({
    _Block(0),
    _Block(1),
    _Block(2),
    _Block(3),
  });
  Color color;

  TetrisShape(
      {required this.rowCount,
      required this.firstBlock,
      this.color = Colors.blue,
      required this.type}) {
    _blocks = getBlocksFromType(type);
  }

  List<_Block> getBlocksFromType(ShapeType type) {
    switch (type) {
      case ShapeType.i:
        return [
          _Block(firstBlock, color),
          _Block(firstBlock + rowCount, color),
          _Block(firstBlock + rowCount * 2, color),
          _Block(firstBlock + rowCount * 3, color),
        ];
      case ShapeType.box:
        return [
          _Block(firstBlock, color),
          _Block(firstBlock + 1, color),
          _Block(firstBlock + rowCount, color),
          _Block(firstBlock + rowCount + 1, color),
        ];
      case ShapeType.z:
        return [
          _Block(firstBlock, color),
          _Block(firstBlock + 1, color),
          _Block(firstBlock + 1 + rowCount, color),
          _Block(firstBlock + 2 + rowCount, color)
        ];
      case ShapeType.t:
        return [
          _Block(firstBlock, color),
          _Block(firstBlock + 1, color),
          _Block(firstBlock + 2, color),
          _Block(firstBlock + 1 + rowCount, color)
        ];
      case ShapeType.l:
        return [
          _Block(firstBlock, color),
          _Block(firstBlock + rowCount, color),
          _Block(firstBlock + rowCount * 2, color),
          _Block(firstBlock + rowCount * 2 + 1, color),
        ];
      case ShapeType.j:
        return [
          _Block(firstBlock, color),
          _Block(firstBlock + rowCount, color),
          _Block(firstBlock + rowCount * 2, color),
          _Block(firstBlock + rowCount * 2 - 1, color),
        ];
      case ShapeType.s:
        return [
          _Block(firstBlock, color),
          _Block(firstBlock - 1, color),
          _Block(firstBlock - 1 + rowCount, color),
          _Block(firstBlock - 2 + rowCount, color)
        ];
      default:
        return _blocks;
    }
  }

  int get baseBlock => _blocks.last.index;

  void moveDown() {
    _blocks = [
      _Block(_blocks[0].index + 30, color),
      _Block(_blocks[1].index + 30, color),
      _Block(_blocks[2].index + 30, color),
      _Block(_blocks[3].index + 30, color),
    ];
  }

  void moveRight() {
    _blocks = [
      _Block(_blocks[0].index + 1, color),
      _Block(_blocks[1].index + 1, color),
      _Block(_blocks[2].index + 1, color),
      _Block(_blocks[3].index + 1, color),
    ];
  }

  void moveLeft() {
    _blocks = [
      _Block(_blocks[0].index - 1, color),
      _Block(_blocks[1].index - 1, color),
      _Block(_blocks[2].index - 1, color),
      _Block(_blocks[3].index - 1, color),
    ];
  }

  //todo: rotate function clockwise need to be written
  void rotateClockwise() {
    _blocks = [
      //will the function for each tetrimino be different
    ];
  }

  List<int> get indexes => _blocks.map((e) => e.index).toList();
}

class _Block {
  int index;
  Color color;

  _Block(this.index, [this.color = Colors.black]);
}

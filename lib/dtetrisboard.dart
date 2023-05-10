import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris_game/dtetrisgame.dart';

class Board {
  final int _rowCount;
  final int _columnCount;

  late List<List<Color>> _cells;
  late Tetromino _currentTetromino;

  Color backgroundColor = Colors.white;
  final List<Tetromino> tetrominos = [];

  bool _isGameOver = false;

  Board(this._rowCount, this._columnCount) {
    for (int i = 0; i < _rowCount; i++) {
      board.add(List.generate(_columnCount, (index) => backgroundColor));
    }
    _currentTetromino = Tetromino.random();
  }

  List<List<Color>> get board => _cells;
  bool get isGameOver => _isGameOver;
  Tetromino? get currentTetromino => _currentTetromino;

  void moveTetrominoDown() {
    if (_currentTetromino != null) {
      final newTetromino = _currentTetromino.copyWith(
        position: Point(
          _currentTetromino.position.x,
          _currentTetromino.position.y + 1,
        ),
      );
      if (!_isColliding(newTetromino)) {
        _currentTetromino = newTetromino;
      } else {
        _lockTetromino();
      }
    }
  }

  void moveTetrominoLeft() {
    if (_currentTetromino != null) {
      final newTetromino = _currentTetromino.copyWith(
        position: Point(
            _currentTetromino.position.x - 1, _currentTetromino.position.y),
      );
      if (!_isColliding(newTetromino)) {
        _currentTetromino = newTetromino;
      }
    }
  }

  void moveTetrominoRight() {
    if (_currentTetromino != null) {
      final newTetromino = _currentTetromino.copyWith(
        position: Point(
            _currentTetromino.position.x + 1, _currentTetromino.position.y),
      );
      if (!_isColliding(newTetromino)) {
        _currentTetromino = newTetromino;
      }
    }
  }

  List<List<int>> rotateMatrix(List<List<int>> matrix) {
    final List<List<int>> rotatedMatrix =
        List.generate(matrix.length, (_) => List.filled(matrix[0].length, 0));
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[0].length; j++) {
        rotatedMatrix[j][matrix.length - 1 - i] = matrix[i][j];
      }
    }
    return rotatedMatrix;
  }

  void _lockTetromino() {
    if (_currentTetromino != null) {
      _currentTetromino.shape.getShape().asMap().forEach((y, row) {
        row.asMap().forEach((x, value) {
          if (value) {
            board[_currentTetromino.position.y + y]
                [_currentTetromino.position.x + x] = _currentTetromino.color;
          }
        });
      });

      _currentTetromino = Tetromino.random();
    }
  }

  bool _isColliding(Tetromino tetromino) {
    final shape = tetromino.shape.getShape();
    final position = tetromino.position;

    for (int y = 0; y < shape.length; y++) {
      for (int x = 0; x < shape[y].length; x++) {
        if (shape[y][x]) {
          final boardX = position.x + x;
          final boardy = position.y + y;

          if (boardy < 0) {
            continue;
          }

          if (boardX < 0 || boardX >= _rowCount || boardy >= _columnCount) {
            return true;
          }
          if (board[boardy][boardX] != null) {
            return true;
          }
        }
      }
    }
    return false;
  }
}

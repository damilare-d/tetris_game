import 'dart:js';
import 'dart:math';

import 'package:flame/flame.dart';
import 'package:flame/timer.dart';
import 'package:tetris_game/tetrisshapes.dart';

List<TetrimonosShape> tetrominoShapes = TetrimonosShapes.shapes;
int currentTetrimonoIndex = 0;
int boardHeight = 20;
int boardWidth = 10;

List<List<bool>> board =
    List.generate(boardHeight, (_) => List.filled(boardWidth, false));

void startGame() {
  final timer = Timer(
    0.5,
    repeat: true,
    onTick: () {
      moveTetrominoesDown();
    },
  );
  timer.start();
}

class Point {
  int row = 0;
  int col = 0;

  Point(this.row, this.col);
}

void moveTetrominoesDown() {
  //check if the current tetris shape can move down
  if (canMoveTetriminoDown()) {
    //then we can move the current tetrimono by one
    currentTetrominoPosition.row += 1;
  } else {
    //add the current tetromino to the stack of tetrominoes
    addTetrominoToStack();
    //then we check if any rows on the stack are complete
    checkForCompleteRows();
    //then we spawn a new tetrimono
    spawnNewTetromino();
  }
}

void checkForCompleteRows() {
  
}

//defining the initial position of the current tetrimono
Point currentTetrominoPosition = Point(0,0);



bool canMoveTetriminoDown() {
  //get the shape of the current tetromino
  List<List<bool>> shape = TetrimonosShapes.shapes[currentTetrimonoIndex].shape;
  //then we get the position of the current tetromino
  Point position = currentTetrominoPosition;

  // then we loop through the square in the tetromino shape
  for (int row = 0; row < shape.length; row++) {
    for (int col = 0; col < shape[row].length; col++) {
      //then we check if the current square is part of the tetrominos shape
      if (shape[row][col]) {
        //then we calculate the position of the square on the board
        int boardRow = position.row + row + 1;
        int boardCol = position.col + col;

        //check if the square is out of bonds or overlaps with another
        if (boardRow >= boardHeight || board[boardRow][boardCol]) {
          return false;
        }
      }
    }
  }
  return true;
}

void addTetrominoToStack() {
  // we get the shape of the current Tetromino
  List<List<bool>> shape = TetrimonosShapes.shapes[currentTetrimonoIndex].shape;
  //then we get the position of the current Tetromino
  Point position = currentTetrominoPosition;
  // Loop through each square in the Tetromino's shape
  for (int row = 0; row < shape.length; row++) {
    for (int col = 0; col < shape[row].length; col++) {
      // Check if the current square is part of the Tetromino's shape
      if (shape[row][col]) {
        // Calculate the position of the square on the board
        int boardRow = position.row + row;
        int boardCol = position.col + col;
        // Add the square to the stack of Tetrominoes on the board
        board[boardRow][boardCol] = true;
      }
    }
  }
}

void spawnNewTetromino() {
  // Choose a random Tetromino shape
  currentTetrominoIndex = Random().nextInt(TetrimonosShapes.shapes.length);
  // Set the position of the new Tetromino to the top center of the board
  currentTetrominoPosition = Point(boardWidth ~/ 2 - 1, 0);
}

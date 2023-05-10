import 'dart:async';
import 'dart:async' as timer;
import 'dart:developer';
import 'dart:math' as point;

import 'package:flame/timer.dart';

import 'models/shapes.dart';

List<TetrimonosShape> tetrominoShapes = TetrimonosShapes.shapes;
int currentTetrimonoIndex = 0;
int boardHeight = 20;
int boardWidth = 10;

List<List<bool>> board =
    List.generate(boardHeight, (_) => List.filled(boardWidth, false));

//defining the initial position of the current tetrimono
Point currentTetrominoPosition = Point(0, 0);
StreamController<Point> tetrominoPositionController = StreamController<Point>();
StreamController<List<List<bool>>> boardController =
    StreamController<List<List<bool>>>();

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

void startGameA() {
  timer.Timer.periodic(const Duration(seconds: 1), (timer) {
    //to the tetromino down one by one
    moveTetrominoesDown();
    if (!canMoveTetriminoDown()) {
      log('function works');
      lockTetromino(TetrimonosShapes.shapes[currentTetrimonoIndex], board,
          const point.Point(0, 0));
      // then we check for complete rows, and clear them
      checkForCompleteRows(board);
      //then we spawn a new tetromino
      spawnNewTetromino();
    }
  });
}

class Point {
  int row = 0;
  int col = 0;

  Point(this.row, this.col);

  @override
  String toString() {
    return "Point(${this.row}, ${this.col})";
  }
}

void moveTetrominoesDown() {
  //check if the current tetris shape can move down
  if (canMoveTetriminoDown()) {
    //then we can move the current tetrimono by one
    currentTetrominoPosition.row += 1;
    tetrominoPositionController.add(currentTetrominoPosition);
  } else {
    //add the current tetromino to the stack of tetrominoes
    addTetrominoToStack();
    //then we check if any rows on the stack are complete
    checkForCompleteRows(board);
    //then we spawn a new tetrimono
    spawnNewTetromino();
  }
}

void checkForCompleteRows(List<List<bool>> board) {
  final completeRows = <int>[];
  for (var y = 0; y < board.length; y++) {
    if (!board[y].contains(false)) {
      completeRows.add(y);
    }
  }
}

void lockTetromino(
    TetrimonosShape shape, List<List<bool>> board, point.Point<int> position) {
  //iterate over the shape and update the board to lock the
  //tetromino in place0

  for (int i = 0; i < shape.getShape().length; i++) {
    for (int j = 0; j < shape.getShape()[i].length; j++) {
      if (shape.getShape()[i][j]) {
        board[position.y + i][position.x + j] = true;
        boardController.add(board);
      }
    }
    boardController.add(board);
    log('message: tetrimono locked');
  }
  // The for loop is used to iterate over every cell of the tetromino shape.
  // The loop starts with the top-left cell of the tetromino shape and moves down one row at a time
  // until it reaches the bottom row. For each cell of the shape, it checks if it is filled or not.
  // If the cell is filled, it updates the corresponding cell on the game board to true,
  // which means that it is locked in2 place.
  // Finally, it prints a message to the console to indicate that the tetromino has been locked.
}

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
          log('message is false');
          return false;
        }
      }
    }
  }
  log('message is true');
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
        boardController.add(board);
        log('message: tetrimono added to the stack');
      }
    }
  }
}

void spawnNewTetromino() {
  // Choose a random Tetromino shape
  // currentTetrominoIndex =
  //     point.Random().nextInt(TetrimonosShapes.shapes.length);
  // Set the position of the new Tetromino to the top center of the board
  currentTetrominoPosition = Point(boardWidth ~/ 2 - 1, 0);
  tetrominoPositionController.add(currentTetrominoPosition);
  log('new tetrimono on the way');
}

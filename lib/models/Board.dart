import 'package:yote_maic/models/Cell.dart';
import 'package:yote_maic/models/Piece.dart';
import 'package:yote_maic/models/Player.dart';
import 'package:tuple/tuple.dart';


class Board {

  List<Cell> board;
  List<Piece> lightPieces, darkPieces;

  static int boardSize = 30;


  // Constructor, with syntactic sugar for assignment to members.
  Board() {
    this.board = [];
    this.lightPieces = [];
    this.darkPieces = [];
    for (int i = 0; i < 6; i++){
      for (int j = 0; j < 5; j++){
        board.add(new Cell(i, j));
      }
    }
  }

  int getBoardCellNumber (Cell cell){
    var PATERN = [[0,1,2,3,4], [5,6,7,8,9], [10,11,12,13,14], [15,16,17,18,19], [20,21,22,23,24], [25,26,27,28,29]];
    return PATERN[cell.getX][cell.getY];
  }

  Cell getBoardCell (int num){
    return this.board[num];
  }

  void setCellBoard(Cell c, Piece p){
    this.board[this.getBoardCellNumber(c)].placePiece(p);
    if (p.getColor == "Dark"){
      this.darkPieces.add(p);
    }else{
      this.lightPieces.add(p);
    }
  }

  Cell getCell (int x, int y){
    if((x< 0 || x > 6) || (y< 0 || y > 5)){
      throw new FormatException("The coordinates provided are outside of the board");
    }
    return this.board[this.getBoardCellNumber(new Cell(x, y))];
  }


  List<Piece> get getDarkPieces {
    return this.darkPieces;
  }

  List<Cell> get getBoard {
    return this.board;
  }

  List<Piece> get getLightPieces {
    return this.lightPieces;
  }

  List<Cell> movePiece (int fromX, int fromY, int toX, int toY){
    Cell srcCell = this.getCell(fromX, fromY);
    Cell dstCell = this.getCell(toX, toY);
    List<Cell> changedCells = [];
    if (srcCell.getPiece == null){
      throw new Exception("The coordinates provided are outside of the board");
    }
    if (dstCell.getPiece != null){
      throw new Exception("The destination cell already contains a piece. Cannot move to occupied cell.");
    }

    srcCell.movePiece(dstCell);
    changedCells.add(srcCell);
    changedCells.add(dstCell);
    return changedCells;
  }

  void removePiece(Piece capturedPiece){
    if(capturedPiece.getColor == "Light"){
      if(!lightPieces.remove(capturedPiece)){
        throw new Exception("Error removing the piece");
      }
      capturedPiece.getCell.placePiece(null);
    }
    else if(capturedPiece.getColor == "Dark"){
      if(!darkPieces.remove(capturedPiece)){
        throw new Exception("Error removing the piece");
      }
      capturedPiece.getCell.placePiece(null);
    }
  }



  // return possibles moves and possibles captured pieces

  Tuple2<List<Cell>, List<Cell>> possibleMoves(Cell givenCell){

    if(givenCell == null){
      throw new Exception("Given Cell is null. Cannot find the possible moves of null Cell");
    }

    List<Cell> nextMoves = [];
    List<Cell> captCell = [];
    Piece givenPiece = givenCell.getPiece;

    if(givenPiece == null){
      return new Tuple2(nextMoves, captCell);
    }

    String playerColor = givenPiece.getColor;

    if (playerColor == "Light") {

      int nextX0 = givenCell.getX + 1;

      if (nextX0 < 6) {
        //next move = (currentRow +1, currentColumn +1)
        int nextY0 = givenCell.getY;
        //if the cell is not out of bound further checking is required
        if (nextY0 >= 0 && nextY0 < 5) {
          if (!this.board[this.getBoardCellNumber(new Cell(nextX0, nextY0))]
              .containPiece()) {
            nextMoves.add(
                this.board[this.getBoardCellNumber(new Cell(nextX0, nextY0))]);
            captCell.add(null);
          }

          if (this.board[this.getBoardCellNumber(new Cell(nextX0, nextY0))]
              .containPiece() && this.board[this.getBoardCellNumber(new Cell(nextX0, nextY0))].getPiece.getColor == "Dark"){

            if (nextX0+1 < 6 && !this.board[this.getBoardCellNumber(new Cell(nextX0+1, nextY0))]
                .containPiece()) {
              nextMoves.add(
                  this.board[this.getBoardCellNumber(new Cell(nextX0+1, nextY0))]);
              captCell.add(new Cell(nextX0, nextY0));
            }

          }
        }
      }

        int nextX1 = givenCell.getX - 1;

        if (nextX1 >= 0) {
          //next move = (currentRow +1, currentColumn +1)
          int nextY1 = givenCell.getY;
          //if the cell is not out of bound further checking is required
          if (nextY1 >= 0 && nextY1 < 5) {
            if (!this.board[this.getBoardCellNumber(new Cell(nextX1, nextY1))]
                .containPiece()) {
              nextMoves.add(
                  this.board[this.getBoardCellNumber(
                      new Cell(nextX1, nextY1))]);
              captCell.add(null);
            }
            if (this.board[this.getBoardCellNumber(new Cell(nextX1, nextY1))]
                .containPiece() && this.board[this.getBoardCellNumber(new Cell(nextX1, nextY1))].getPiece.getColor == "Dark"){

              if (nextX1-1 >= 0 && !this.board[this.getBoardCellNumber(new Cell(nextX1-1, nextY1))]
                  .containPiece()) {
                nextMoves.add(
                    this.board[this.getBoardCellNumber(new Cell(nextX1-1, nextY1))]);
                captCell.add(new Cell(nextX1, nextY1));
              }

            }
          }
        }

        int nextY2 = givenCell.getY + 1;

        if (nextY2 < 5) {
          //next move = (currentRow +1, currentColumn +1)
          int nextX2 = givenCell.getX;
          //if the cell is not out of bound further checking is required
          if (nextX2 >= 0 && nextX2 < 6) {
            if (!this.board[this.getBoardCellNumber(new Cell(nextX2, nextY2))]
                .containPiece()) {
              nextMoves.add(
                  this.board[this.getBoardCellNumber(
                      new Cell(nextX2, nextY2))]);
              captCell.add(null);
            }

            if (this.board[this.getBoardCellNumber(new Cell(nextX2, nextY2))]
                .containPiece() && this.board[this.getBoardCellNumber(new Cell(nextX2, nextY2))].getPiece.getColor == "Dark"){

              if (nextY2+1 < 5 && !this.board[this.getBoardCellNumber(new Cell(nextX2, nextY2+1))]
                  .containPiece()) {
                nextMoves.add(
                    this.board[this.getBoardCellNumber(new Cell(nextX2, nextY2+1))]);
                captCell.add(new Cell(nextX2, nextY2));
              }

            }
          }
        }

        int nextY3 = givenCell.getY - 1;

        if (nextY3 >= 0) {
          //next move = (currentRow +1, currentColumn +1)
          int nextX3 = givenCell.getX;
          //if the cell is not out of bound further checking is required
          if (nextX3 >= 0 && nextX3 < 6) {
            if (!this.board[this.getBoardCellNumber(new Cell(nextX3, nextY3))]
                .containPiece()) {
              nextMoves.add(
                  this.board[this.getBoardCellNumber(
                      new Cell(nextX3, nextY3))]);
              captCell.add(null);
            }

            if (this.board[this.getBoardCellNumber(new Cell(nextX3, nextY3))]
                .containPiece() && this.board[this.getBoardCellNumber(new Cell(nextX3, nextY3))].getPiece.getColor == "Dark"){

              if (nextY3-1 >=0  && !this.board[this.getBoardCellNumber(new Cell(nextX3, nextY3-1))]
                  .containPiece()) {
                nextMoves.add(
                    this.board[this.getBoardCellNumber(new Cell(nextX3, nextY3-1))]);
                captCell.add(new Cell(nextX3, nextY3));
              }

            }
          }
        }

    }
    else {

      int nextX0 = givenCell.getX + 1;

      if (nextX0 < 6) {
        //next move = (currentRow +1, currentColumn +1)
        int nextY0 = givenCell.getY;
        //if the cell is not out of bound further checking is required
        if (nextY0 >= 0 && nextY0 < 5 ) {
          if (!this.board[this.getBoardCellNumber(new Cell(nextX0, nextY0))]
              .containPiece()) {
            nextMoves.add(
                this.board[this.getBoardCellNumber(new Cell(nextX0, nextY0))]);
            captCell.add(null);
          }

          if (this.board[this.getBoardCellNumber(new Cell(nextX0, nextY0))]
              .containPiece() && this.board[this.getBoardCellNumber(new Cell(nextX0, nextY0))].getPiece.getColor == "Light"){

            if (nextX0+1 < 6 && !this.board[this.getBoardCellNumber(new Cell(nextX0+1, nextY0))]
                .containPiece()) {
              nextMoves.add(
                  this.board[this.getBoardCellNumber(new Cell(nextX0+1, nextY0))]);
              captCell.add(new Cell(nextX0, nextY0));
            }

          }
        }
      }

      int nextX1 = givenCell.getX - 1;

      if (nextX1 >= 0) {
        //next move = (currentRow +1, currentColumn +1)
        int nextY1 = givenCell.getY;
        //if the cell is not out of bound further checking is required
        if (nextY1 >= 0 && nextY1 < 5) {
          if (!this.board[this.getBoardCellNumber(new Cell(nextX1, nextY1))]
              .containPiece()) {
            nextMoves.add(
                this.board[this.getBoardCellNumber(
                    new Cell(nextX1, nextY1))]);
            captCell.add(null);
          }
          if (this.board[this.getBoardCellNumber(new Cell(nextX1, nextY1))]
              .containPiece() && this.board[this.getBoardCellNumber(new Cell(nextX1, nextY1))].getPiece.getColor == "Light"){

            if (nextX1-1 >= 0 && !this.board[this.getBoardCellNumber(new Cell(nextX1-1, nextY1))]
                .containPiece()) {
              nextMoves.add(
                  this.board[this.getBoardCellNumber(new Cell(nextX1-1, nextY1))]);
              captCell.add(new Cell(nextX1, nextY1));
            }

          }
        }
      }

      int nextY2 = givenCell.getY + 1;

      if (nextY2 < 5) {
        //next move = (currentRow +1, currentColumn +1)
        int nextX2 = givenCell.getX;
        //if the cell is not out of bound further checking is required
        if (nextX2 >= 0 && nextX2 < 6) {
          if (!this.board[this.getBoardCellNumber(new Cell(nextX2, nextY2))]
              .containPiece()) {
            nextMoves.add(
                this.board[this.getBoardCellNumber(
                    new Cell(nextX2, nextY2))]);
            captCell.add(null);
          }

          if (this.board[this.getBoardCellNumber(new Cell(nextX2, nextY2))]
              .containPiece() && this.board[this.getBoardCellNumber(new Cell(nextX2, nextY2))].getPiece.getColor == "Light"){

            if (nextY2+1 < 5 && !this.board[this.getBoardCellNumber(new Cell(nextX2, nextY2+1))]
                .containPiece()) {
              nextMoves.add(
                  this.board[this.getBoardCellNumber(new Cell(nextX2, nextY2+1))]);
              captCell.add(new Cell(nextX2, nextY2));
            }

          }
        }
      }

      int nextY3 = givenCell.getY - 1;

      if (nextY3 >= 0) {
        //next move = (currentRow +1, currentColumn +1)
        int nextX3 = givenCell.getX;
        //if the cell is not out of bound further checking is required
        if (nextX3 >= 0 && nextX3 < 6) {
          if (!this.board[this.getBoardCellNumber(new Cell(nextX3, nextY3))]
              .containPiece()) {
            nextMoves.add(
                this.board[this.getBoardCellNumber(
                    new Cell(nextX3, nextY3))]);
            captCell.add(null);
          }

          if (this.board[this.getBoardCellNumber(new Cell(nextX3, nextY3))]
              .containPiece() && this.board[this.getBoardCellNumber(new Cell(nextX3, nextY3))].getPiece.getColor == "Light"){

            if (nextY3-1 >=0  && !this.board[this.getBoardCellNumber(new Cell(nextX3, nextY3-1))]
                .containPiece()) {
              nextMoves.add(
                  this.board[this.getBoardCellNumber(new Cell(nextX3, nextY3-1))]);
              captCell.add(new Cell(nextX3, nextY3));
            }

          }
        }
      }

    }

    return new Tuple2(nextMoves, captCell);

  }

  List<Cell> PossiblePieceMovePiece(Player player){

    var moves = null;
    List<Cell> highlightcells = [];
    List<Piece> currentPlayerPieces;
    if (player.getColor == "Dark"){
      currentPlayerPieces = this.getDarkPieces;
    }else{
      currentPlayerPieces = this.getLightPieces;
    }
    for(Piece p in currentPlayerPieces){
      moves =  this.possibleMoves(p.getCell);
      //print(moves);
      if (moves!=null && !moves.item1.isEmpty){
        highlightcells.add(p.getCell);
      }
    }
    return highlightcells;
  }





}
import 'package:yote_maic/models/Piece.dart';

class Cell {
  int x, y;
  Piece p;

  // Constructor, with syntactic sugar for assignment to members.
  Cell(this.x, this.y) {
    this.p = null;
  }


  int get getX {
    return this.x;
  }

  int get getY {
    return this.y;
  }

  Piece get getPiece {
    return this.p;
  }

  set setPiece (Piece givenPiece){
    this.p = givenPiece;
  }

  void placePiece(Piece givenPiece){
    this.p = givenPiece;
    if(givenPiece != null){
      givenPiece.setCell = this;
    }
  }

  bool containPiece (){
    if(this.p != null){
      return true;
    }
    return false;
  }

  void movePiece(Cell anotherCell){
    if (anotherCell == null){
      throw new FormatException("Provided cell is null. Cannot move to a null Cell.");
    }
    anotherCell.placePiece(this.p);
    this.p.setCell = anotherCell;
    this.p = null;
  }


  @override
  String toString() {
    return "Cell Loc: ("+ this.getX.toString() + ", " + this.getY.toString() + ") )";
  }

}
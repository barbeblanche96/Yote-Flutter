import 'package:yote_maic/models/Cell.dart';

class Piece {
  String color;
  Cell c;

  // Constructor, with syntactic sugar for assignment to members.
  Piece(this.color) {
    if(this.color != "Dark" &&  this.color != "Light"){
      throw new FormatException("The provided color for piece is not valid.");
    }
    this.c = null;
  }

  set setCell (Cell givenCell){
    this.c = givenCell;
  }

  Cell get getCell {
    return this.c;
  }

  String get getColor {
    return this.color;
  }

  void giveCell(Cell cell){
    this.c = cell;
    if(cell != null){
      cell.setPiece = this;
    }
  }

  String getOpponentColor(){
    if (this.color == "Dark"){
      return "Light";
    }else{
      return "Dark";
    }
  }

  bool equal (Piece p){
    if (p.getColor == this.color && p.getCell == this.getCell){
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return "Piece Loc: ("+ this.c.getX.toString() + ", " + this.c.getY.toString() + ") \t Placed piece: "+ this.color;
  }

}
import 'package:yote_maic/models/Piece.dart';

class Player {
  String color;
  // Constructor, with syntactic sugar for assignment to members.
  Player(this.color) {

   if (this.color != "Dark" && this.color != "Light"){
      throw new FormatException("Given color for the player is not valid."+ this.color);
    }
  }

  String get getColor {
    return this.color;
  }


  /*bool hasMove(Board board){
    this.p = givenPiece;
    if(givenPiece != null){
      givenPiece.setCell = this;
    }
  }*/

  bool equal (Player p){
    if (p.getColor == this.color){
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return "Player: ("+ this.getColor + ")";
  }

}
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:yote_maic/models/Cell.dart';
import 'package:yote_maic/models/Player.dart';
import 'package:yote_maic/models/Board.dart';
import 'package:yote_maic/models/Piece.dart';
import 'dart:math';
import 'dart:async';


class BoardScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFFfcebcd);
    return Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text("Game"),
      ),
      body: Body(),
    );
  }
}


class Body extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _body_state();

}


class _body_state extends State<Body> {

  Board board = new Board();
  Player player1 = new Player("Light");
  Player player2 = new Player("Dark");
  Player currentPlayer = null;
  Cell srcCell = null;
  Cell dstCell = null;
  int REMAIN_PIECE_LIGHT = 12;
  int REMAIN_PIECE_BLACK = 12;
  int score_light = 0;
  int score_dark = 0;
  bool dialogShow = false;
  bool FirstClickMove = false;
  bool SecondClickMove = false;
  bool SelectPiece = false;
  bool ComputerMode = false;
  Cell nxtMove = null;
  Cell takePiece =null;
  List<Cell> highlightcells = null;
  List<Cell> possibleCaptures = null;
  List<Cell> possibleMoves = null;
  List<Cell> possibleMovesAuto = null;
  var sub;
  int _start = 20;
  Timer timerDark;
  Timer timerLight;

  void closeDialog() async{
    if (dialogShow){
      Navigator.pop(context);
    }
    dialogShow = false;
  }

  void startTimerDark() {
    const oneSec = const Duration(seconds: 1);
    timerDark = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
            if (SelectPiece){
              closeDialog();
              secondPieceLateChoosing();
            }else{
              randomPlay();
            }
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void startTimerLight() {
    const oneSec = const Duration(seconds: 1);
    timerLight = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
            if (SelectPiece){
              closeDialog();
              secondPieceLateChoosing();
            }else{
              randomPlay();
            }
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  //random position on timeout
  void randomPlay(){
    FirstClickMove = false;
    SecondClickMove = false;
    SelectPiece = false;
    srcCell = null;
    dstCell = null;
    possibleMoves = null;
    possibleCaptures = null;
    if (currentPlayer.getColor == "Light"){
      if (REMAIN_PIECE_LIGHT > 0 && board.getLightPieces.length <= 0){
        List<Cell> freeCell = board.getBoard.where((i) => !i.containPiece()).toList();
        var rng = new Random();
        int rd = rng.nextInt(freeCell.length);
        int indx = board.getBoardCellNumber(freeCell[rd]);
        playerTurnAuto(indx);
      }
      else if (REMAIN_PIECE_LIGHT <= 0 && board.getLightPieces.length > 0){
        List<Cell> freeCell = highlightcells;
        var rng = new Random();
        int rd = rng.nextInt(freeCell.length);
        int indx = board.getBoardCellNumber(freeCell[rd]);
        playerTurnAuto(indx);
      }
      else{
        var rng = new Random();
        int rd = rng.nextInt(2);
        if (rd == 0){
          List<Cell> freeCell = board.getBoard.where((i) => !i.containPiece()).toList();
          var rng = new Random();
          int rd = rng.nextInt(freeCell.length);
          int indx = board.getBoardCellNumber(freeCell[rd]);
          playerTurnAuto(indx);
        }
        else{
          List<Cell> freeCell = highlightcells;
          var rng = new Random();
          int rd = rng.nextInt(freeCell.length);
          int indx = board.getBoardCellNumber(freeCell[rd]);
          playerTurnAuto(indx);
        }
      }
    }else{

      if (REMAIN_PIECE_BLACK > 0 && board.getDarkPieces.length <= 0){
        List<Cell> freeCell = board.getBoard.where((i) => !i.containPiece()).toList();
        var rng = new Random();
        int rd = rng.nextInt(freeCell.length);
        int indx = board.getBoardCellNumber(freeCell[rd]);
        playerTurnAuto(indx);
      }
      else if (REMAIN_PIECE_BLACK <= 0 && board.getDarkPieces.length > 0){
        List<Cell> freeCell = highlightcells;
        var rng = new Random();
        int rd = rng.nextInt(freeCell.length);
        int indx = board.getBoardCellNumber(freeCell[rd]);
        playerTurnAuto(indx);
      }
      else{
        var rng = new Random();
        int rd = rng.nextInt(2);
        if (rd == 0){
          List<Cell> freeCell = board.getBoard.where((i) => !i.containPiece()).toList();
          var rng = new Random();
          int rd = rng.nextInt(freeCell.length);
          int indx = board.getBoardCellNumber(freeCell[rd]);
          playerTurnAuto(indx);
        }
        else{
          List<Cell> freeCell = highlightcells;
          var rng = new Random();
          int rd = rng.nextInt(freeCell.length);
          int indx = board.getBoardCellNumber(freeCell[rd]);
          playerTurnAuto(indx);
        }
      }

    }
  }




  // changer de tour
  void changeTurn (){
    FirstClickMove = false;
    SecondClickMove = false;
    SelectPiece = false;
    srcCell = null;
    dstCell = null;
    possibleMoves = null;
    possibleMovesAuto = null;
    possibleCaptures = null;
    highlightcells = null;
    if (currentPlayer ==  player1){
      currentPlayer = player2;
      highlightcells = board.PossiblePieceMovePiece(currentPlayer);
      if(timerLight != null){
        timerLight.cancel();
      }
      _start = 20;
      startTimerDark();
      if (REMAIN_PIECE_BLACK < 1 && (highlightcells == null  || highlightcells.length < 1)){
        if(timerLight != null){
          timerLight.cancel();
        }
        if(timerDark != null){
          timerDark.cancel();
        }
        return _winDialog(context,1);
      }
      if (ComputerMode){
        randomPlay();
      }
    }else{
      currentPlayer = player1;
      highlightcells = board.PossiblePieceMovePiece(currentPlayer);
      if (timerDark != null){
        timerDark.cancel();
      }
      _start = 20;
      startTimerLight();
      if (REMAIN_PIECE_LIGHT < 1 && (highlightcells == null  || highlightcells.length < 1)){
        if(timerLight != null){
          timerLight.cancel();
        }
        if(timerDark != null){
          timerDark.cancel();
        }
        _winDialog(context,2);
      }
    }
  }

  //Fontionnalité auto!!!!

  void secondPieceLateChoosing(){
    print("ok");
    if(currentPlayer.getColor == "Light"){
      if (REMAIN_PIECE_BLACK > 0 && board.getDarkPieces.length <= 0){
        secondPieceChoosingAuto(-1);
      }
      else if (REMAIN_PIECE_BLACK <= 0 && board.getDarkPieces.length > 0){
        SelectPiece = true;
        var rng = new Random();
        List<Piece> blackPieces = board.getDarkPieces;
        int rd = rng.nextInt(blackPieces.length);
        int indx = board.getBoardCellNumber(blackPieces[rd].getCell);
        secondPieceChoosingAuto(indx);
      }
      else{
        var rng = new Random();
        int rd = rng.nextInt(2);
        if (rd == 0){
          secondPieceChoosingAuto(-1);
        }
        else{
          SelectPiece = true;
          var rng = new Random();
          List<Piece> blackPieces = board.getDarkPieces;
          int rd = rng.nextInt(blackPieces.length);
          int indx = board.getBoardCellNumber(blackPieces[rd].getCell);
          secondPieceChoosingAuto(indx);
        }
      }
    }
    else{
      if (REMAIN_PIECE_LIGHT > 0 && board.getLightPieces.length <= 0){
        secondPieceChoosingAuto(-1);
      }
      else if (REMAIN_PIECE_LIGHT <= 0 && board.getLightPieces.length > 0){
        SelectPiece = true;
        var rng = new Random();
        List<Piece> lightPieces = board.getLightPieces;
        int rd = rng.nextInt(lightPieces.length);
        int indx = board.getBoardCellNumber(lightPieces[rd].getCell);
        secondPieceChoosingAuto(indx);
      }
      else{
        var rng = new Random();
        int rd = rng.nextInt(2);
        if (rd == 0){
          secondPieceChoosingAuto(-1);
        }
        else{
          SelectPiece = true;
          var rng = new Random();
          List<Piece> lightPieces = board.getLightPieces;
          int rd = rng.nextInt(lightPieces.length);
          int indx = board.getBoardCellNumber(lightPieces[rd].getCell);
          secondPieceChoosingAuto(indx);
        }
      }
    }
  }

  void playerTurnAuto(int index){
    if (!board.getBoardCell(index).containPiece()){
      if (FirstClickMove && srcCell != null && possibleMoves != null && possibleMoves.length > 0){
        dstCell = board.getBoardCell(index);
        secondClickAuto(srcCell, dstCell);
      }
      else{
        Piece piece;
        if (currentPlayer.getColor == "Dark"){
          piece = new Piece("Dark");
          nxtMove=board.getBoardCell(index);
          new Timer(const Duration(milliseconds: 500), () {
            board.setCellBoard(board.getBoardCell(index), piece);
            nxtMove = null;
            REMAIN_PIECE_BLACK--;
            changeTurn();
          });
        }
        else{
          piece = new Piece("Light");
          nxtMove = board.getBoardCell(index);
          new Timer(const Duration(milliseconds: 500), () {
            board.setCellBoard(board.getBoardCell(index), piece);
            nxtMove = null;
            REMAIN_PIECE_LIGHT--;
            changeTurn();
          });
        }
      }
    }
    else {
      if (!FirstClickMove && srcCell == null){
        FirstClickMove = true;
        srcCell = board.getBoardCell(index);
        final result =  board.possibleMoves(board.getBoardCell(index));
        possibleMovesAuto = result.item1;
        possibleCaptures = result.item2;
        //print(srcCell);
        //print(possibleMovesAuto);
        var rng = new Random();
        int rd = rng.nextInt(possibleMovesAuto.length);
        dstCell = possibleMovesAuto[rd];
        //print(dstCell);
        nxtMove = dstCell;
        new Timer(const Duration(milliseconds: 500), () {
          secondClickAuto(srcCell, dstCell);
        });
      }

    }
  }

  void secondClickAuto(Cell srcCell, Cell dstCell){
    if (srcCell != null && dstCell != null){
      int indexDstCell = possibleMovesAuto.indexOf(dstCell);
      new Timer(const Duration(milliseconds: 500), () {
        board.movePiece(srcCell.getX, srcCell.getY, dstCell.getX, dstCell.getY);
        nxtMove = null  ;
      });
      var captCell = possibleCaptures[indexDstCell];
      if (captCell != null){
        board.removePiece(board.getCell(captCell.getX, captCell.getY).getPiece);
        if(currentPlayer.getColor == "Light"){
          score_light++;
        }else{
          score_dark++;
        }
        if(currentPlayer.getColor == "Light"){
          if (REMAIN_PIECE_BLACK > 0 && board.getDarkPieces.length <= 0){
            REMAIN_PIECE_BLACK --;
            score_light++;
            Toast.show("The second piece was removed from the opponent's reserve", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            changeTurn();
          }
          else if (REMAIN_PIECE_BLACK <= 0 && board.getDarkPieces.length > 0){
            SelectPiece = true;
            var rng = new Random();
            List<Piece> blackPieces = board.getDarkPieces;
            int rd = rng.nextInt(blackPieces.length);
            int indx = board.getBoardCellNumber(blackPieces[rd].getCell);
            takePiece = board.getBoardCell(indx);
            secondPieceChoosingAuto(indx);
          }
          else{
            var rng = new Random();
            int rd = rng.nextInt(2);
            if (rd == 0){
              secondPieceChoosingAuto(-1);
            }
            else{
              SelectPiece = true;
              var rng = new Random();
              List<Piece> blackPieces = board.getDarkPieces;
              int rd = rng.nextInt(blackPieces.length);
              int indx = board.getBoardCellNumber(blackPieces[rd].getCell);
              takePiece = board.getBoardCell(indx);
              secondPieceChoosingAuto(indx);

            }
          }
        }
        else{
          if (REMAIN_PIECE_LIGHT > 0 && board.getLightPieces.length <= 0){
            REMAIN_PIECE_LIGHT --;
            score_dark++;
            Toast.show("The second piece was removed from the opponent's reserve", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            changeTurn();
          }
          else if (REMAIN_PIECE_LIGHT <= 0 && board.getLightPieces.length > 0){
            SelectPiece = true;
            var rng = new Random();
            List<Piece> lightPieces = board.getLightPieces;
            int rd = rng.nextInt(lightPieces.length);
            int indx = board.getBoardCellNumber(lightPieces[rd].getCell);
            takePiece = board.getBoardCell(indx);
            secondPieceChoosingAuto(indx);

          }
          else{
            var rng = new Random();
            int rd = rng.nextInt(2);
            if (rd == 0){
              secondPieceChoosingAuto(-1);
            }
            else{
              SelectPiece = true;
              var rng = new Random();
              List<Piece> lightPieces = board.getLightPieces;
              int rd = rng.nextInt(lightPieces.length);
              int indx = board.getBoardCellNumber(lightPieces[rd].getCell);
              takePiece = board.getBoardCell(indx);
              secondPieceChoosingAuto(indx);
            }
          }
        }
      }else{
        changeTurn();
      }
    }
  }

  void secondPieceChoosingAuto (int index){
    if (index == null || index == -1){
      Future.delayed(const Duration(seconds: 1), (){
        if(currentPlayer.getColor == "Light"){
          REMAIN_PIECE_BLACK --;
          score_light++;
          Toast.show("The second piece was removed from the opponent's reserve", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          changeTurn();
        }else{
          REMAIN_PIECE_LIGHT --;
          score_dark++;
          Toast.show("The second piece was removed from the opponent's reserve", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          changeTurn();
        }
      });
    }else{
      SelectPiece = true;
      takePiece = board.getBoardCell(index);
      Future.delayed(const Duration(seconds: 2), (){
        board.removePiece(board.getBoardCell(index).getPiece);
        SelectPiece = false;
        takePiece = null;
        Toast.show("The piece has been removed successfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (currentPlayer.getColor == "Dark"){
          score_dark++;
        }else{
          score_light++;
        }
        changeTurn();
      });
    }

  }



  //Fonctionnalité pour choisir la cellule de destination
  void secondClick(Cell srcCell, Cell dstCell){
    if (srcCell != null && dstCell != null){
      int indexDstCell = possibleMoves.indexOf(dstCell);
      board.movePiece(srcCell.getX, srcCell.getY, dstCell.getX, dstCell.getY);
      possibleMoves = null;
      var captCell = possibleCaptures[indexDstCell];
      if (captCell != null){
        board.removePiece(board.getCell(captCell.getX, captCell.getY).getPiece);
        if(currentPlayer.getColor == "Light"){
          score_light++;
        }else{
          score_dark++;
        }
        if(currentPlayer.getColor == "Light"){
          if (REMAIN_PIECE_BLACK > 0 && board.getDarkPieces.length <= 0){
            REMAIN_PIECE_BLACK --;
            score_light++;
            Toast.show("The second piece was removed from the opponent's reserve", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            changeTurn();
          }
          else if (REMAIN_PIECE_BLACK <= 0 && board.getDarkPieces.length > 0){
            SelectPiece = true;
            Toast.show("Select the second piece on the board", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          else{
            _asyncChoosePieceDialog(context);
          }
        }
        else{
          //print("Remain : "+REMAIN_PIECE_LIGHT.toString());
          //print("pieces : "+board.getLightPieces.length.toString());
          if (REMAIN_PIECE_LIGHT > 0 && board.getLightPieces.length <= 0){
            REMAIN_PIECE_LIGHT --;
            score_dark++;
            Toast.show("The second piece was removed from the opponent's reserve", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            changeTurn();
          }
          else if (REMAIN_PIECE_LIGHT <= 0 && board.getLightPieces.length > 0){
            SelectPiece = true;
            Toast.show("Select the second piece on the board", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          else{
            _asyncChoosePieceDialog(context);
          }
        }
      }else{
        changeTurn();
      }
    }
  }

  // Fonctionnalité pour la seconde pièce à choisir
  void secondPieceChoosing (int index){
    if (board.getBoardCell(index).containPiece()){

      if (board.getBoardCell(index).getPiece.getColor == currentPlayer.getColor){
        Toast.show("You must choose an opponent's piece", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }else{
        board.removePiece(board.getBoardCell(index).getPiece);
        SelectPiece = false;
        Toast.show("The piece has been removed successfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (currentPlayer.getColor == "Dark"){
          score_dark++;
        }else{
          score_light++;
        }
        changeTurn();
      }

    }else{
      Toast.show("Select a valid cell", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  // Le prmier clic effectué au tour de l'adversaire
  void playerTurn(int index){
    if (!board.getBoardCell(index).containPiece()){

      if (FirstClickMove && srcCell != null && possibleMoves != null && possibleMoves.length > 0){
        if (!possibleMoves.contains(board.getBoardCell(index))){
          Toast.show("you can't move to this position", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }else{
          dstCell = board.getBoardCell(index);
          secondClick(srcCell, dstCell);
        }
      }
      else{
        Piece piece;
        if (currentPlayer.getColor == "Dark"){
          if (REMAIN_PIECE_BLACK > 0){
            piece = new Piece("Dark");
            board.setCellBoard(board.getBoardCell(index), piece);
            REMAIN_PIECE_BLACK--;
            changeTurn();
          }else{
            Toast.show("you have already deployed all your pieces", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        }

        else{
          if (REMAIN_PIECE_LIGHT > 0){
            piece = new Piece("Light");
            board.setCellBoard(board.getBoardCell(index), piece);
            REMAIN_PIECE_LIGHT--;
            changeTurn();
          }else{
            Toast.show("you have already deployed all your pieces", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        }
      }
    }

    else {

      if (currentPlayer.getColor != board.getBoardCell(index).getPiece.getColor){
        Toast.show("you can't use opposite pieces", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }else{
        if (!FirstClickMove && srcCell == null){
          if (highlightcells.contains(board.getBoardCell(index))){
            FirstClickMove = true;
            srcCell = board.getBoardCell(index);
            final result =  board.possibleMoves(board.getBoardCell(index));
            possibleMoves = result.item1;
            possibleCaptures = result.item2;
          }
          else{
            Toast.show("You can't move this piece", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        }else{
          FirstClickMove = false;
          srcCell = null;
          possibleMoves = null;
          possibleCaptures = null;
        }
      }

    }
  }


  // Afficher l'image adéquate pour chaque cellule
  Widget imageCell(Cell cell){

    if (cell.containPiece()){
      if (cell.getPiece.color == "Light"){
        if (srcCell == cell && FirstClickMove){
          return new Image.asset("assets/light_piece_pressed.png", scale: 0.7, fit: BoxFit.contain,);
        }
        if (highlightcells.contains(cell)){
          return new Image.asset("assets/light_piece_highlighted.png", scale: 0.7, fit: BoxFit.contain,);
        }
        if (currentPlayer.getColor == "Dark" && SelectPiece && takePiece==null){
          return new Image.asset("assets/light_piece_pressed.png", scale: 0.7, fit: BoxFit.contain,);
        }
        if(currentPlayer.getColor == "Dark" && SelectPiece && takePiece==cell){
          return new Image.asset("assets/light_piece_pressed.png", scale: 0.7, fit: BoxFit.contain,);
        }
        return new Image.asset("assets/light_piece.png", scale: 0.7, fit: BoxFit.contain,);
      }else{
        if (srcCell == cell && FirstClickMove){
          return new Image.asset("assets/dark_piece_pressed.png", scale: 0.7, fit: BoxFit.contain,);
        }
        if (highlightcells.contains(cell)){
          return new Image.asset("assets/dark_piece_highlighted.png", scale: 0.7, fit: BoxFit.contain,);
        }
        if (currentPlayer.getColor == "Light" && SelectPiece && takePiece==null){
          return new Image.asset("assets/dark_piece_pressed.png", scale: 0.7, fit: BoxFit.contain,);
        }
        if(currentPlayer.getColor == "Light" && SelectPiece && takePiece==cell){
          return new Image.asset("assets/dark_piece_pressed.png", scale: 0.7, fit: BoxFit.contain,);
        }
        return new Image.asset("assets/dark_piece.png", scale: 0.7, fit: BoxFit.contain,);
      }
    }else{
      if (possibleMoves != null && possibleMoves.length > 0 && possibleMoves.contains(cell)){
        return new Image.asset("assets/possible_moves_image.png", scale: 0.7, fit: BoxFit.contain,);
      }
      if(nxtMove != null && nxtMove==cell){
        return new Image.asset("assets/possible_moves_image.png", scale: 0.7, fit: BoxFit.contain,);
      }
    }

  }


  // win dialog

  _winDialog(BuildContext context, int winner)  {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: winner == 1 ? Text('Player 1 is the winner') : Text('Player 2 is the winner'),
          content: const Text(
              'Do you want to restart this game ?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('No', style: TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.pop(context);
                Route route = MaterialPageRoute(builder: (context) => BoardScreen());
                Navigator.pushReplacement(context, route);
                Toast.show("Select the second piece on the board", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            ),
            FlatButton(
              child: const Text('Yes', style: TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.pop(context);
                Route route = MaterialPageRoute(builder: (context) => BoardScreen());
                Navigator.pushReplacement(context, route);
                Toast.show("Game restarted!", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            )
          ],
        );
      },
    );
  }


  // first dialog player mode

  void _showDialogPlayer() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SimpleDialog(
            title: Text('Select Game Mode :'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  ComputerMode = true;
                  Navigator.pop(context);
                },
                child: const Text('1 Player', style: TextStyle(fontSize: 18),),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('2 Players', style: TextStyle(fontSize: 18),),
              ),
            ],
          );
        });
  }


  // choosing second piece dialog
  _asyncChoosePieceDialog(BuildContext context)  {
    dialogShow = true;
    SelectPiece = true;
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select the second piece'),
          content: const Text(
              'Where do you want to take the second piece ?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('On Board', style: TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.pop(context);
                Toast.show("Select the second piece on the board", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            ),
            FlatButton(
              child: const Text('In reserves', style: TextStyle(fontSize: 18),),
              onPressed: () {
                if (currentPlayer.getColor == "Light"){
                  REMAIN_PIECE_BLACK --;
                  setState(() {
                    score_light++;
                  });
                }else{
                  REMAIN_PIECE_LIGHT --;
                  setState(() {
                    score_dark++;
                  });
                }
                Navigator.pop(context);
                Toast.show("The second piece was removed from the opponent's reserve", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                setState(() {
                  changeTurn();
                });
              },
            )
          ],
        );
      },
    );
  }

  Widget _starTurnLight(){
    if (currentPlayer.getColor == "Light")
      return new Text(" * ", style: TextStyle(fontSize: 23, fontStyle: FontStyle.italic , color: Colors.red),);
    else
      return new Text("");
  }

  Widget _starTurnDark(){
    if (currentPlayer.getColor == "Dark")
      return new Text(" * ", style: TextStyle(fontSize: 23, fontStyle: FontStyle.italic , color: Colors.black),);
    else
      return new Text("");
  }

  Widget _timerLight(){
    if (currentPlayer.getColor == "Light")
      return new Text("00:$_start", textAlign: TextAlign.right, style: TextStyle(fontSize: 23, fontStyle: FontStyle.italic , color: Colors.red),);
    else
      return new Text("");
  }

  Widget _timerDark(){
    if (currentPlayer.getColor == "Dark")
      return new Text("00:$_start", textAlign: TextAlign.right, style: TextStyle(fontSize: 23, fontStyle: FontStyle.italic , color: Colors.black),);
    else
      return new Text("");
  }



  Widget _boardWidget() {
    return new Center(
      child: GridView.count(
        crossAxisCount: 5,
        childAspectRatio: 1.0,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
        padding: EdgeInsets.all(0),
        children: new List<Widget>.generate(30, (index) {
          return new GridTile(
            child: new GestureDetector(
              onTap: (){
                setState(() {
                  // En fonction de l'état du jeu , jouer son tour ou permettre à l'adversaire de choisir un second pion de gagner
                  if (ComputerMode){
                    if (currentPlayer.getColor != "Dark"){
                      if (SelectPiece){
                        secondPieceChoosing(index);
                      }else{
                        playerTurn(index);
                      }
                    }else{
                      Toast.show("Wait your turn!!", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }
                  }
                 else{
                    if (SelectPiece){
                      secondPieceChoosing(index);
                    }else{
                      playerTurn(index);
                    }
                  }
                });
              },
              behavior: HitTestBehavior.translucent,
              child: Card(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    side: BorderSide(color: Colors.black, width:0.5),
                  ),

                  color: Color(0xFFfcebcd),
                  child: new Center(
                    child: imageCell(board.getBoardCell(index)),
                  )
              ),
            ),
          );
        }),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showDialogPlayer());
    currentPlayer =  player1;
  }

  @override
  void dispose() {
    timerLight.cancel();
    timerDark.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 1, 10, 9),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Text ("Black Player : ", style: TextStyle(fontSize: 23, color: Colors.black),),
                      Text (score_dark.toString(), style: TextStyle(fontSize: 23, fontStyle: FontStyle.italic , color: Colors.black),),
                      _starTurnDark(),
                    ],),
                    Align(child: _timerDark(), alignment: Alignment.topRight,)

                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(padding: EdgeInsets.fromLTRB(0, 5, 0, 0), child: Align(child: Text("Pieces to deploy : "+REMAIN_PIECE_BLACK.toString(), style: TextStyle(color: Colors.black, fontSize: 18,),), alignment: Alignment.topLeft,),),
                    Container(padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Align(alignment: Alignment.topRight,
                          child: Row(children: <Widget>[
                            Text("Captured pieces : ", style: TextStyle(color: Colors.black, fontSize: 17,),), Text(score_dark.toString(), style: TextStyle(color: Colors.red, fontSize: 17,),)
                          ],
                          ),
                        )
                    ),
                  ],
                ),

              ],
            )
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child :_boardWidget(),
                )
              ],
            )
          ),
          Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 1),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Text ("Red Player : ", style: TextStyle(fontSize: 23, color: Colors.red),),
                        Text (score_light.toString(), style: TextStyle(fontSize: 23, fontStyle: FontStyle.italic , color: Colors.red),),
                        _starTurnLight(),
                      ],),
                      Align(child: _timerLight(), alignment: Alignment.bottomRight,)
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(padding: EdgeInsets.fromLTRB(0, 5, 0, 0), child: Align(child: Text("Pieces to deploy : "+REMAIN_PIECE_LIGHT.toString(), style: TextStyle(color: Colors.red, fontSize: 18,),), alignment: Alignment.topLeft,),),
                      Container(padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Align(alignment: Alignment.topRight,
                            child: Row(children: <Widget>[
                              Text("Captured pieces : ", style: TextStyle(color: Colors.red, fontSize: 17,),), Text(score_light.toString(), style: TextStyle(color: Colors.black, fontSize: 17,),)
                            ],
                            ),
                          )
                      ),
                    ],
                  ),
                ],
              )
          ),
        ],
    );
  }
}
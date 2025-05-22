import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Velha',
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String> board = List.filled(9, '');
  bool xTurn = true;
  String winner = '';
  bool gameOver = false;

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      xTurn = true;
      winner = '';
      gameOver = false;
    });
  }

  void playMove(int index) {
    if (board[index] != '' || gameOver) return;

    setState(() {
      board[index] = xTurn ? 'X' : 'O';
      xTurn = !xTurn;
      winner = checkWinner();
      if (winner != '') {
        gameOver = true;
        showEndDialog('$winner venceu!');
      } else if (!board.contains('')) {
        gameOver = true;
        showEndDialog('Empate!');
      }
    });
  }

  String checkWinner() {
    List<List<int>> lines = [
      [0,1,2], [3,4,5], [6,7,8],
      [0,3,6], [1,4,7], [2,5,8],
      [0,4,8], [2,4,6]
    ];

    for (var line in lines) {
      String a = board[line[0]];
      String b = board[line[1]];
      String c = board[line[2]];
      if (a != '' && a == b && b == c) {
        return a;
      }
    }
    return '';
  }

  void showEndDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Fim de jogo'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text('Reiniciar'),
          )
        ],
      )
    );
  }

  Widget buildTile(int index) {
    return GestureDetector(
      onTap: () => playMove(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            board[index],
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: board[index] == 'X' ? Colors.red : Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Velha'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,  
          children: [
            Container(
              width: 300,
              height: 300,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (_, index) => buildTile(index),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetGame,
              child: Text('Reiniciar'),
            ),
            SizedBox(height: 20),
            Text(
              gameOver
                ? 'Jogo terminado'
                : 'Vez do jogador: ${xTurn ? 'X' : 'O'}',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

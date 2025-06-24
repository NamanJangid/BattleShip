import 'package:battleships/views/CurrentGameView.dart';
import 'package:battleships/views/CurrentAIGameView.dart';
import 'package:flutter/material.dart';

class GameList extends StatefulWidget {
  dynamic eachLine;
  bool iSCompleted;

  GameList({super.key, required this.eachLine, this.iSCompleted = false});

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (widget.eachLine['player2'].toString().contains("AI-")) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CurrentAIGameView(
                    gameId: widget.eachLine['id'].toString(),
                    isCompleted: widget.iSCompleted,
                  )));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CurrentGameView(
                    gameId: widget.eachLine['id'].toString(),
                    isCompleted: widget.iSCompleted,
                  )));
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "#${widget.eachLine['id']} ${widget.eachLine['player1']} vs ${widget.eachLine['player2']}",
            style: const TextStyle(color: Colors.black),
          ),
          Text(
            widget.eachLine['status'] == 1 || widget.eachLine['status'] == 2
                ? "Completed Game (${widget.eachLine['status'] == 1 ? widget.eachLine['player1'] : widget.eachLine['player2']})"
                : widget.eachLine['status'] == 0
                    ? "Matchmaking"
                    : widget.eachLine['turn'] == widget.eachLine['position']
                        ? "My Turn"
                        : "Opponent Turn",
            style: TextStyle(
                color: widget.eachLine['turn'] == widget.eachLine['position']
                    ? Colors.green
                    : Colors.red),
          )
        ],
      ),
    );
  }
}

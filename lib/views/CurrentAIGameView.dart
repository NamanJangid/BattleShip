import 'dart:convert';

import 'package:battleships/views/commonValuesProvider.dart';
import 'package:battleships/views/homePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ShipLocations.dart';
import '../utils/sessionmanager.dart';
import 'package:http/http.dart' as http;

import 'rowsCols.dart';

class CurrentAIGameView extends StatefulWidget {
  final String baseUrl = "http://165.227.117.48/games/";
  final String gameId;
  bool isCompleted;

  CurrentAIGameView(
      {super.key, required this.gameId, this.isCompleted = false});

  @override
  State<CurrentAIGameView> createState() => _CurrentAIGameViewState();
}

class _CurrentAIGameViewState extends State<CurrentAIGameView> {
  bool shouldBeGiven = false;
  dynamic turn;
  late List<String> rowNums = ["", "1", "2", "3", "4", "5"];
  late List<String> colAlphas = ["A", "B", "C", "D", "E"];
  late List<Color> toggleColors = List.generate(25, (index) => Colors.white);
  late List<bool> toggleShips = List.generate(25, (index) => false);
  late List<dynamic> locations = [];
  late List<bool> toggleBombs = List.generate(25, (index) => false);
  late List<String> bombs = [];
  late List<bool> toggleWreckedShips = List.generate(25, (index) => false);
  late List<dynamic> wreckedShips = [];
  late List<bool> toggleSunkShips = List.generate(25, (index) => false);
  late List<dynamic> sunkShips = [];
  late List<bool> toggleShots = List.generate(25, (index) => false);
  late List<dynamic> shots = [];
  late var locationToIndex = ShipLocations();
  Map<String, dynamic> answer = {};

  Future<void> _showMyDialog(String user) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("$user Won!!!"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => HomePage(
                            userName: Provider.of<CommonValuesProvider>(context,
                                    listen: false)
                                .UserName)));
                  },
                  child: const Text("Ok")),
            ],
          );
        });
  }

  Future<void> _getResponse() async {
    final response = await http
        .get(Uri.parse("${widget.baseUrl}${widget.gameId}"), headers: {
      'Content-Type': 'application/json',
      'Authorization': await SessionManager.getSessionToken()
    });
    answer = await jsonDecode(response.body);
    turn = answer;
    if (answer['ships'] != null) {
      locations = answer['ships'];
      wreckedShips = answer['wrecks'];
      sunkShips = answer['sunk'];
      shots = answer['shots'];
      widget.isCompleted =
          answer['status'] == 1 || answer['status'] == 2 ? true : false;
      if (widget.isCompleted) {
        if (answer['status'] == 1) {
          _showMyDialog("You");
        } else {
          _showMyDialog("Opponent");
        }
      }
    }
    if (answer['position'] == answer['turn']) shouldBeGiven = true;
  }

  void _submitButton() async {
    if (bombs.length != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a location")));
      return;
    }
    Map<String, dynamic> data;
    if (bombs.isNotEmpty) {
      data = {
        'shot': bombs[0],
      };
      bombs.clear();
      toggleBombs = List.generate(25, (index) => false);
      locations.clear();
      toggleShips = List.generate(25, (index) => false);
      wreckedShips.clear();
      toggleWreckedShips = List.generate(25, (index) => false);
      sunkShips.clear();
      toggleSunkShips = List.generate(25, (index) => false);
      shots.clear();
      toggleShots = List.generate(25, (index) => false);
    } else {
      return;
    }

    final newResponse =
        await http.put(Uri.parse("${widget.baseUrl}${widget.gameId}"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": await SessionManager.getSessionToken()
            },
            body: jsonEncode(data));
    final ans = jsonDecode(newResponse.body);
    if (newResponse.statusCode == 200) {
      if (widget.isCompleted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: const Text("The game is over")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: ans['sunk_ship']
                ? const Text("Congratulations!!!, Enemy Ship sunken!!!")
                : Text(ans['message'].toString())));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Server Error, Try again after some time!!!")));
    }
  }

  void _refreshPage() {
    _getResponse().then((value) {
      setState(() {
        for (int i = 0; i < locations.length; i++) {
          toggleShips[locationToIndex.locationToIndex[locations[i]]!] = true;
        }
        for (int i = 0; i < wreckedShips.length; i++) {
          toggleWreckedShips[
              locationToIndex.locationToIndex[wreckedShips[i]]!] = true;
        }
        for (int i = 0; i < sunkShips.length; i++) {
          toggleSunkShips[locationToIndex.locationToIndex[sunkShips[i]]!] =
              true;
        }
        for (int i = 0; i < shots.length; i++) {
          toggleShots[locationToIndex.locationToIndex[shots[i]]!] = true;
        }
      });
    });
  }

  @override
  void initState() {
    _refreshPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: const Text(
          "Place ship",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              turn != null && turn['turn'] == turn['position']
                  ? 'Your turn'
                  : 'Opponent\'s Turn',
              style: TextStyle(
                  color: turn != null && turn['turn'] == turn['position']
                      ? Colors.green
                      : Colors.red,
                  fontSize: 40,
                  fontFamily: 'Times'
                  // Add more text styles if needed
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowNums.map((e) => RowsCols(numbers: e)).toList(),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      children:
                          colAlphas.map((e) => RowsCols(numbers: e)).toList(),
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.83,
                      child: GridView.count(
                          crossAxisCount: 5,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              MediaQuery.of(context).size.height *
                              1.4,
                          children: List.generate(
                              25,
                              (index) => Card(
                                    elevation: 4,
                                    shape: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1)),
                                    surfaceTintColor: Colors.red[900],
                                    child: InkWell(
                                        hoverColor: shouldBeGiven &&
                                                !widget.isCompleted
                                            ? toggleSunkShips[index] == false &&
                                                    toggleShots[index] == false
                                                ? Colors.greenAccent
                                                : Colors.red
                                            : Colors.white,
                                        splashColor:
                                            shouldBeGiven && !widget.isCompleted
                                                ? Colors.blue
                                                : Colors.white,
                                        onTap: () {
                                          setState(() {
                                            if (shouldBeGiven &&
                                                !widget.isCompleted) {
                                              if (toggleSunkShips[index] ==
                                                      false &&
                                                  toggleShots[index] == false) {
                                                if (bombs.isEmpty) {
                                                  toggleBombs[index] =
                                                      !toggleBombs[index];
                                                  if (toggleBombs[index]) {
                                                    bombs.add(locationToIndex
                                                            .indexToLocations[
                                                        index]!);
                                                  } else {
                                                    bombs.remove(locationToIndex
                                                            .indexToLocations[
                                                        index]!);
                                                  }
                                                } else {
                                                  if (toggleBombs[index] ==
                                                      true) {
                                                    bombs.remove(locationToIndex
                                                            .indexToLocations[
                                                        index]!);
                                                    toggleBombs[index] =
                                                        !toggleBombs[index];
                                                  }
                                                }
                                              }
                                            } else {
                                              if (widget.isCompleted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Game is Already Finished!!!")));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Opponent's Turn!!!")));
                                              }
                                            }
                                          });
                                        },
                                        child: GetIcons(
                                          index: index,
                                          toggleShips: toggleShips,
                                          toggleWreckedShips:
                                              toggleWreckedShips,
                                          toggleBombs: toggleBombs,
                                          toggleSunkShips: toggleSunkShips,
                                          toggleShots: toggleShots,
                                        )),
                                  ))))
                ],
              )),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              elevation: 6,
            ),
            onPressed: shouldBeGiven && !widget.isCompleted
                ? () {
                    _submitButton();
                    if (!widget.isCompleted) {
                      Future.delayed(const Duration(seconds: 2), () {
                        _refreshPage();
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {});
                        });
                      });
                    }
                  }
                : null,
            child: const Text(
              "Submit",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}

class GetIcons extends StatelessWidget {
  int index;
  List<Widget> ans = [];
  List<bool> toggleShips,
      toggleWreckedShips,
      toggleBombs,
      toggleSunkShips,
      toggleShots;

  GetIcons(
      {super.key,
      required this.index,
      required this.toggleShips,
      required this.toggleWreckedShips,
      required this.toggleBombs,
      required this.toggleSunkShips,
      required this.toggleShots});

  @override
  Widget build(BuildContext context) {
    if (toggleShips[index]) {
      ans.add(const Text(
        "⛴️",
        style: TextStyle(fontSize: 23),
      ));
    } else if (toggleWreckedShips[index]) {
      ans.add(const Icon(
        Icons.bubble_chart_rounded,
        color: Colors.blueAccent,
      ));
    }
    if (toggleBombs[index])
      ans.add(const Text(
        "🔫",
        style: TextStyle(fontSize: 23),
      ));
    if (toggleSunkShips[index]) {
      ans.add(const Text(
        "💥",
        style: TextStyle(fontSize: 23),
      ));
    } else if (toggleShots[index]) {
      ans.add(const Text(
        "🧨",
        style: TextStyle(fontSize: 23),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ans.toList(),
    );
  }
}

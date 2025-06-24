import 'dart:convert';
import 'dart:math';

import 'package:battleships/utils/sessionmanager.dart';
import 'package:battleships/views/commonValuesProvider.dart';
import 'package:battleships/views/homePage.dart';
import 'package:provider/provider.dart';
import 'rowsCols.dart';
import 'package:flutter/material.dart';
import '../models/ShipLocations.dart';
import 'package:http/http.dart' as http;

class NewGameView extends StatefulWidget {
  bool ai;
  dynamic eachLine;
  String type;
  final String baseUrl = "http://165.227.117.48/games";
  NewGameView({
    super.key,
    this.ai = false,
    this.type = "",
    this.eachLine,
  });

  @override
  State<NewGameView> createState() => _NewGameViewState();
}

class _NewGameViewState extends State<NewGameView> {
  late List<String> rowNums = ["", "1", "2", "3", "4", "5"];
  late List<String> colAlphas = ["A", "B", "C", "D", "E"];
  late List<bool> toggleShips = List.generate(25, (index) => false);
  late List<String> locations = [];
  late var locationToIndex = ShipLocations();

  void _submitButton() async {
    if (locations.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please Select The Right Number Of Boats")));
    }
    Map<String, dynamic> data;
    if (widget.ai) {
      data = {"ships": locations, "ai": widget.type};
    } else {
      data = {"ships": locations};
    }
    final response = await http.post(Uri.parse(widget.baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": await SessionManager.getSessionToken()
        },
        body: jsonEncode(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Place ships",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                      width: MediaQuery.of(context).size.width * 0.82,
                      child: GridView.count(
                          crossAxisCount: 5,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              MediaQuery.of(context).size.height *
                              1.4,
                          children: List.generate(
                              25,
                              (index) => Card(
                                    elevation: 5.0,
                                    shape: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1)),
                                    surfaceTintColor: Colors.deepOrange,
                                    child: InkWell(
                                      hoverColor: toggleShips[index] == false
                                          ? Colors.greenAccent
                                          : Colors.red,
                                      splashColor: Colors.blue,
                                      onTap: () {
                                        setState(() {
                                          if (locations.length < 5) {
                                            toggleShips[index] =
                                                !toggleShips[index];
                                            if (toggleShips[index]) {
                                              locations.add(locationToIndex
                                                  .indexToLocations[index]!);
                                            } else {
                                              locations.remove(locationToIndex
                                                  .indexToLocations[index]!);
                                            }
                                          } else {
                                            if (toggleShips[index] == true) {
                                              locations.remove(locationToIndex
                                                  .indexToLocations[index]!);
                                              toggleShips[index] =
                                                  !toggleShips[index];
                                            }
                                          }
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          toggleShips[index]
                                              ? const Text(
                                                  "⛴️",
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                )
                                              : const Text("")
                                        ],
                                      ),
                                    ),
                                  ))))
                ],
              )),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, elevation: 6),
            onPressed: () {
              _submitButton();
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomePage(
                        userName: Provider.of<CommonValuesProvider>(context,
                                listen: false)
                            .UserName)));
              });
            },
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

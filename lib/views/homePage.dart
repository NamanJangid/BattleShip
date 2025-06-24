import 'dart:convert';
import 'dart:async';
import 'package:battleships/utils/sessionmanager.dart';
import 'package:battleships/views/commonValuesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_list.dart';
import 'leftDrawer.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String baseUrl = "http://165.227.117.48/games";
  final String userName;

  const HomePage({super.key, required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List answer = [];
  List activeGames = [];
  List completedGames = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Initial call to refresh data
    _refreshButton();
    // Setup a timer to refresh data periodically
    _timer = Timer.periodic(
        Duration(milliseconds: 30), (Timer t) => _refreshButton());
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _refreshButton() async {
    try {
      final response = await http.get(Uri.parse(widget.baseUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': await SessionManager.getSessionToken()
      });

      // Check if response is successful (status code 200)
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData.containsKey('games') &&
            responseData['games'] != null) {
          answer = responseData['games'];
          activeGames = answer
              .where(
                  (element) => element['status'] == 0 || element['status'] == 3)
              .toList();
          completedGames = answer
              .where(
                  (element) => element['status'] == 1 || element['status'] == 2)
              .toList();
          setState(() {});
        } else {
          // Handle case where 'games' key is missing or its value is null
          print('Response body does not contain valid game data');
        }
      } else {
        // Handle HTTP error (non-200 status code)
        print('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other errors, such as network error
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: LeftDrawer(userName: widget.userName),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: const Text("Battleships",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          IconButton(
            onPressed: () => _refreshButton(),
            icon: const Icon(Icons.refresh),
            style: const ButtonStyle(
                iconColor: MaterialStatePropertyAll<Color>(Colors.black)),
          )
        ],
      ),
      body: Card(
        surfaceTintColor: const Color.fromARGB(255, 254, 17, 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 6.0),
          child: ListView(
            children: Provider.of<CommonValuesProvider>(context).CompletedGames
                ? List.generate(
                    completedGames.length,
                    (index) => Card(
                        surfaceTintColor:
                            const Color.fromARGB(255, 255, 149, 0),
                        shape: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 0.8)),
                        child: GameList(
                          eachLine: completedGames[index],
                          iSCompleted: true,
                        )))
                : List.generate(
                    activeGames.length,
                    (index) => Card(
                        surfaceTintColor:
                            const Color.fromARGB(255, 255, 149, 0),
                        shape: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 0.85)),
                        child: GameList(
                          eachLine: activeGames[index],
                        )),
                  ),
          ),
        ),
      ),
    );
  }
}

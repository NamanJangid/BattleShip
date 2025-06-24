import 'package:battleships/utils/sessionmanager.dart';
import 'package:battleships/views/commonValuesProvider.dart';
import 'package:battleships/views/NewGameView.dart';
import 'package:battleships/views/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatefulWidget {
  String userName;
  LeftDrawer({super.key, required this.userName});

  @override
  State<StatefulWidget> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Which AI do you want to play against?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => NewGameView(ai: true, type: "random")));
                  },
                  child: const Text("Random")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            NewGameView(ai: true, type: "perfect")));
                  },
                  child: const Text("Perfect")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            NewGameView(ai: true, type: "oneship")));
                  },
                  child: const Text("One Ship (A1)")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.orange),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text("Battleships",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                Text("Logged in as "),
                SizedBox(
                  height: 5,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.userName,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  surfaceTintColor: Colors.green,
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.fiber_new),
            title: const Text("New Game"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => NewGameView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.hub_outlined),
            title: const Text("New Game (AI)"),
            onTap: () => _showMyDialog(),
          ),
          ListTile(
            leading: Icon(
                Provider.of<CommonValuesProvider>(context).CompletedGames
                    ? Icons.playlist_add
                    : Icons.playlist_add_check),
            title: Text(
                Provider.of<CommonValuesProvider>(context).CompletedGames
                    ? "Show Active Games"
                    : "Show Completed Games"),
            onTap: () {
              setState(() {
                Provider.of<CommonValuesProvider>(context, listen: false)
                    .toggleCompletedGames();
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await SessionManager.clearSession();
              if (!mounted) return;
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}

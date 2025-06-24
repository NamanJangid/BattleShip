import 'dart:convert';

import 'package:battleships/views/commonValuesProvider.dart';
import 'package:battleships/views/homePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../utils/sessionmanager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var userController, passController;

  @override
  void initState() {
    userController = TextEditingController();
    passController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final username = userController.text;
    final password = passController.text;

    final url = Uri.parse("http://165.227.117.48/login");
    final response = await http.post(url,
        headers: {'Content-Type': "application/json"},
        body: jsonEncode({"username": username, "password": password}));

    if (!mounted) return;

    if (response.statusCode == 200) {
      final sessionToken = jsonDecode(response.body)['access_token'];
      await SessionManager.setSessionToken(sessionToken);
      Provider.of<CommonValuesProvider>(context, listen: false).userName =
          username;

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomePage(userName: username)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Failed')),
      );
    }
  }

  Future<void> _register() async {
    final username = userController.text;
    final password = passController.text;

    final url = Uri.parse("http://165.227.117.48/register");
    final response = await http.post(url,
        headers: {'Content-Type': "application/json"},
        body: jsonEncode({'username': username, 'password': password}));

    if (!mounted) return;

    if (response.statusCode == 200) {
      final sessionToken = jsonDecode(response.body)['access_token'];
      await SessionManager.setSessionToken(sessionToken);

      if (!mounted) return;

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => HomePage(
              userName:
                  Provider.of<CommonValuesProvider>(context, listen: false)
                      .UserName)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Failed, Try Again!!!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange, // Updated to a cooler color
        title: const Text(
          "Login",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24, // Larger font for title
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          // Makes sure UI is scrollable if needed
          child: Card(
            elevation: 8, // Adds some shadow for a modern feel
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Rounded corners
            ),
            margin: const EdgeInsets.all(
                20.0), // Adjusted margin for better spacing
            child: Padding(
              padding: const EdgeInsets.all(
                  30.0), // Increased padding inside the card
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Username input field with customized style
                  TextFormField(
                    controller: userController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.person), // Added icon for clarity
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20), // Padding for better UI
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 16, // Increased spacing between input fields
                  ),
                  // Password input field with customized style
                  TextFormField(
                    controller: passController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.lock), // Added lock icon
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 30, // Increased space for button section
                  ),
                  // Row of buttons (Log In & Register)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Log In Button
                        ElevatedButton(
                          onPressed: () => _login(),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                          ),
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        // Register Button
                        ElevatedButton(
                          onPressed: () => _register(),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

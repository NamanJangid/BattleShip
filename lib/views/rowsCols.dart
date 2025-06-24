import 'package:flutter/material.dart';

class RowsCols extends StatelessWidget {
  final String numbers;

  const RowsCols({super.key, required this.numbers});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height / 8.455,
        width: MediaQuery.of(context).size.width / 6,
        child: Card(
          color: Colors.amber[200],
          elevation: 1,
          shape: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1)),
          child: Center(
            child: Text(numbers.toString()),
          ),
        ));
  }
}

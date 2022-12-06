import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'animal.dart';
import 'main.dart';

class Farm extends StatefulWidget {
  const Farm({super.key, required this.title});
  final String title;

  @override
  State<Farm> createState() => _FarmState();
}

class _FarmState extends State<Farm> {
  final Future<bool> _connect = mqtt.connect();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Animal(name: 'Holešovice'),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

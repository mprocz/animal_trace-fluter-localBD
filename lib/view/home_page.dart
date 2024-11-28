import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(
          "Animal Trace",
          style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 79, 192, 117),
      ),
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(20.0),
                color: Color.fromARGB(255, 79, 192, 117),
                child: Text("Animales"),
              ),
            ),
            SizedBox(height: 25.0),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(20.0),
                color: Color.fromARGB(255, 79, 192, 117),
                child: Text("Novo"),
              ),
            )
          ],
        ),
      )
    );
  }
}
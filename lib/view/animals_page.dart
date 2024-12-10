import 'package:flutter/material.dart';

class AnimalsPage extends StatelessWidget {
  const AnimalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Animais"),
        backgroundColor: Color.fromARGB(255, 79, 192, 117),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 79, 192, 117),
            ),
            title: Text("Animal $index"),
            onTap: () {
              Navigator.pushNamed(context, '/animal-profile', arguments: index);
            },
          );
        },
      ),
    );
  }
}
import 'package:animal_trace/helper/animal_helper.dart';
import 'package:animal_trace/view/animal_page.dart';
import 'package:animal_trace/view/animal_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AnimalHelper helper = AnimalHelper();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Image.asset(
            "assets/images/garra_logo.png", // Caminho da imagem
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
          "AnimalTrace",
          style: TextStyle(
              color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 79, 192, 117),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 30.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 79, 192, 117),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text("Meus Animais",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 245, 243, 243))),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("Estimação",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  )),
            ),
            SizedBox(
              height: 30.0,
            ),
            GestureDetector(
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 79, 192, 117),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text("Meus Animais",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 245, 243, 243))),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("Criação",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  )),
            ),
            SizedBox(
              height: 50.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimalProfilePage(),
                  ),
                );
              },
              child: Container(
                  height: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 79, 192, 117),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline_rounded,
                          color: Colors.white,
                          size: 50.0,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text("Novo Animal",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ]),
                  width: double.infinity),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int _currentIndex) {},
        //showSelectedLabels: false,
        //showUnselectedLabels: false,
        iconSize: 35.0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Minha Conta',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 79, 192, 117),
      ),
    );
  }

  void showContactPage({Animal? animal}) async {
    final retContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalProfilePage(animal: animal),
      ),
    );
    if (retContact != null) {
      if (animal != null) {
        await helper.updateAnimal(retContact);
      } else {
        await helper.saveAnimal(retContact);
      }
    }
  }
}

import 'package:animal_trace/view/animal_edit_page.dart';
import 'package:animal_trace/view/animal_profile_page.dart';
import 'package:animal_trace/view/animal_page.dart';
import 'package:animal_trace/view/home_page.dart';
import 'package:animal_trace/view/login_page.dart';
import 'package:animal_trace/view/pet_list_page.dart';
import 'package:animal_trace/view/register_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
      '/home': (context) => HomePage(),
      '/register': (context) => RegisterPage(),
      '/animal-profile': (context) => AnimalProfilePage(),
      '/petlist': (context) => PetListPage(),
      //'/animal-edit': (context) => AnimalEditPage(),
    },
    debugShowCheckedModeBanner: false,
  ));
}

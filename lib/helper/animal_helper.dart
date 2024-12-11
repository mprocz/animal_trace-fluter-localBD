import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

String animalTable = "animalTable";
String idColumn = "idColumn";
String nameColumn = "nameColumn";
String typeColumn = "typeColumn";
String weightColumn = "weigthColumn";
String ageColumn = "ageColumn";
String descriptionColumn = "descriptionColumn";
String imageColumn = "imageColumn";

class AnimalHelper {
  static final AnimalHelper _instance = AnimalHelper.internal();
  factory AnimalHelper() => _instance;
  AnimalHelper.internal();

  Database? _db;  // Agora, o _db pode ser nulo inicialmente.

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initdb();
    return _db!;
  }

  Future<Database> initdb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "animal.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newVersion) async {
        await db.execute(
          "CREATE TABLE $animalTable("
          "$idColumn INTEGER PRIMARY KEY, "
          "$nameColumn TEXT, "
          "$typeColumn TEXT, "
          "$weightColumn INTEGER, "
          "$ageColumn INTEGER, "
          "$descriptionColumn TEXT, "
          "$imageColumn TEXT)"
        );
      },
    );
  }

  Future<List<Animal>> getAllAnimals() async {
    Database dbAnimal = await db;
    List<Map<String, dynamic>> listMap =
        await dbAnimal.rawQuery("SELECT * FROM $animalTable");
    return listMap.map((m) => Animal.fromMap(m)).toList();
  }

  Future<Animal?> getAnimal(int id) async {
    Database dbAnimal = await db;
    List<Map<String, dynamic>> maps = await dbAnimal.query(
      animalTable,
      columns: [idColumn, nameColumn, typeColumn, weightColumn, ageColumn, descriptionColumn, imageColumn],
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Animal.fromMap(maps.first);
    }
    return null;
  }

  Future<Animal> saveAnimal(Animal animal) async {
    Database dbAnimal = await db;
    animal.id = await dbAnimal.insert(animalTable, animal.toMap());
    return animal;
  }

  Future<int> updateAnimal(Animal animal) async {
    Database dbAnimal = await db;
    return await dbAnimal.update(
      animalTable,
      animal.toMap(),
      where: "$idColumn = ?",
      whereArgs: [animal.id],
    );
  }

  Future<int> deleteAnimal(int id) async {
    Database dbAnimal = await db;
    return await dbAnimal.delete(
      animalTable,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
  }
}

class Animal {
  int? id;
  String name = '';
  String type = '';
  int weight = 0;
  int age = 0;
  String description = '';
  String image = '';

  Animal();

  Animal.fromMap(Map<String, dynamic> map) {
    id = map[idColumn] as int?;
    name = map[nameColumn] as String;
    type = map[typeColumn] as String;
    weight = map[weightColumn] as int;
    age = map[ageColumn] as int;
    description = map[descriptionColumn] as String;
    image = map[imageColumn] as String;
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) idColumn: id,
      nameColumn: name,
      typeColumn: type,
      weightColumn: weight,
      ageColumn: age,
      descriptionColumn: description,
      imageColumn: image,
    };
  }

  @override
  String toString() {
    return "Animal(id: $id, name: $name, type: $type, weight: $weight, age: $age, description: $description, image: $image)";
  }
}
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
    late Database _db;
    
    Future<Database> get db async {
        _db ??= await initdb();
        return _db;
    }

    Future<Database> initdb() async {
        final databasePath = await getDatabasesPath();
        final path = join(databasePath, "animal.db");
        return await openDatabase(
            path,
            version: 1,
            onCreate: (Database db, int newVersion) async {
                await db.execute(
                    "CREATE TABLE $animalTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $typeColumn TEXT, $weightColumn TEXT, $ageColumn TEXT, $descriptionColumn TEXT, $imageColumn TEXT)"
                );

            },
        );
    }

    Future<List<Animal>> getAllAnimals() async {
    Database dbAnimal = await db;
    List listMap = await dbAnimal.rawQuery("SELECT * FROM $animalTable");
    List<Animal> listAnimal = [];
    for (Map m in listMap) {
      listAnimal.add(Animal.fromMap(m));
    }
    return listAnimal;
  }

  Future<Animal?> getAnimal(int id) async {
    Database dbAnimal = await db;
    List<Map> maps = await dbAnimal.query(
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
    return await dbAnimal.update(animalTable, animal.toMap(),
        where: "$idColumn = ?", whereArgs: [animal.id]);
  }

  Future<int> deleteAnimal(int id) async {
    Database dbAnimal = await db;
    return await dbAnimal
        .delete(animalTable, where: "$idColumn = ?", whereArgs: [id]);
  }
}

class Animal {
    Animal();

    int id;
    String name;
    String type;
    int weight;
    int age;
    String description;
    String image;

    Animal.fromMap(Map map) {
        id = map[idColumn];
        name = map[nameColumn];
        type = map[typeColumn];
        weight = map[weightColumn];
        age = map[ageColumn];
        description = map[descriptionColumn];
        image = map[imageColumn];
    }

    Map toMap() {
        Map<String, dynamic> map = {
            idColumn: id,
            nameColumn: name,
            typeColumn:type,
            weightColumn: weight,
            ageColumn: age,
            descriptionColumn: description,
            imageColumn: image
        };

        if (id != null) {
            map[idColumn] = id;
        }
        return map;
    }

    @override
    String toString() {
        return "Contact(id: $id, name: $name, type:$type, weight:$weight, age: $age, description: $description)";
    }
 }
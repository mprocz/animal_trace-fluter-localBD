import 'dart:io';

import 'package:animal_trace/view/animal_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:animal_trace/helper/animal_helper.dart';
import 'animal_profile_page.dart';

class PetListPage extends StatefulWidget {
  const PetListPage({Key? key}) : super(key: key);

  @override
  _PetListPageState createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  late Future<List<Animal>> _animalList;

  @override
  void initState() {
    super.initState();
    _loadAnimals();
  }

  void _loadAnimals() {
    setState(() {
      _animalList = AnimalHelper().getAllAnimals();
    });
  }

  Future<void> _deleteAnimal(int? animalId) async {
    if (animalId == null) return;
    await AnimalHelper().deleteAnimal(animalId);
    _loadAnimals(); // Recarrega a lista após exclusão
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animais de Estimação'),
        backgroundColor: const Color.fromARGB(255, 79, 192, 117),
      ),
      body: FutureBuilder<List<Animal>>(
        future: _animalList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum animal encontrado.'));
          }
          var animals = snapshot.data!;
          return ListView.builder(
            itemCount: animals.length,
            itemBuilder: (context, index) {
              var animal = animals[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: animal.image.isNotEmpty
                        ? FileImage(File(animal.image))
                        : const AssetImage("assets/images/avatar.jpg") as ImageProvider,
                    backgroundColor: const Color.fromARGB(255, 79, 192, 117),
                  ),
                  title: Text(animal.name),
                  subtitle: Text("Tipo: ${animal.type}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botão de editar
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnimalEditPage(animal: animal),
                            ),
                          ).then((_) => _loadAnimals());
                        },
                      ),
                      // Botão de deletar
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Excluir Animal"),
                              content: const Text("Tem certeza que deseja excluir este animal?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Excluir", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await _deleteAnimal(animal.id);
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Exibir os detalhes sem editar
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnimalProfilePage(animal: animal),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

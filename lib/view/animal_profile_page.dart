import 'dart:io';

import 'package:animal_trace/helper/animal_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnimalProfilePage extends StatefulWidget {
  const AnimalProfilePage({super.key, this.animal});

  final Animal? animal;

  @override
  State<AnimalProfilePage> createState() => _AnimalProfilePageState();
}

class _AnimalProfilePageState extends State<AnimalProfilePage> {
  bool _userEdited = false;
  late Animal _editedAnimal;
  late String? oldName;
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.animal == null) {
      _editedAnimal = Animal();
      oldName = null;
    } else {
      _editedAnimal = Animal.fromMap(widget.animal!.toMap());
      oldName = _editedAnimal.name;
      _nameController.text = _editedAnimal.name;
      _typeController.text = _editedAnimal.type;
      _weightController.text = _editedAnimal.weight.toString();
      _ageController.text = _editedAnimal.age.toString();
      _descriptionController.text = _editedAnimal.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "AnimalTrace",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 79, 192, 117),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 79, 192, 117),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      oldName ?? "Novo Animal",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(children: [
                    SizedBox(height: 20),
                    GestureDetector(
                      child: Container(
                        width: 140.0,
                        height: 140.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: _editedAnimal.image.isNotEmpty
                                ? FileImage(File(_editedAnimal.image))
                                : const AssetImage("assets/images/avatar.jpg")
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? file =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (file != null) {
                          setState(() {
                            _editedAnimal.image = file.path;  // Salvando o caminho da imagem
                          });
                        } else {
                          print("Nenhuma imagem foi selecionada.");
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    const SizedBox(height: 30.0),
                    TextField(
                      controller: _nameController,
                      focusNode: _nameFocus,
                      decoration: const InputDecoration(label: Text("Nome")),
                      onSubmitted: (value) {
                        _saveAnimal();
                      },
                      onChanged: (value) {
                        _userEdited = true;
                        setState(() {
                          _editedAnimal.name = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: _typeController,
                      decoration: const InputDecoration(label: Text("Tipo")),
                      onChanged: (value) {
                        _userEdited = true;
                        setState(() {
                          _editedAnimal.type = value;
                        });
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: _weightController,
                      decoration: const InputDecoration(label: Text("Peso")),
                      onChanged: (value) {
                        _userEdited = true;
                        setState(() {
                          _editedAnimal.weight = int.tryParse(value) ?? 0;
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: _ageController,
                      decoration: const InputDecoration(label: Text("Idade")),
                      onChanged: (value) {
                        _userEdited = true;
                        setState(() {
                          _editedAnimal.age = int.tryParse(value) ?? 0;
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(label: Text("Descrição")),
                      onChanged: (value) {
                        _userEdited = true;
                        setState(() {
                          _editedAnimal.description = value;
                        });
                      },
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveAnimal,
                      child: Text('Salvar Animal'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 79, 192, 117),
                      ),
                    ),
                  ]), 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> requestPop() async {
    if (!_userEdited) return true;

    final shouldPop = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Descartar alterações"),
          content: const Text("Se sair, as alterações serão perdidas"),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text("Sim"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    return shouldPop ?? false;
  }

  void _saveAnimal() async {
    FocusScope.of(context).unfocus();

    if (_editedAnimal.name.isEmpty || _editedAnimal.type.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Por favor, preencha todos os campos obrigatórios")),
      );
      return;
    }

    AnimalHelper helper = AnimalHelper();
    Animal savedAnimal = await helper.saveAnimal(_editedAnimal);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Animal ${savedAnimal.name} salvo com sucesso!")),
    );
    Navigator.pushReplacementNamed(context, '/');
  }
}

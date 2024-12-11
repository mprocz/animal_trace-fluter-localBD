import 'dart:io';

import 'package:flutter/material.dart';
import 'package:animal_trace/helper/animal_helper.dart';
import 'package:image_picker/image_picker.dart';

class AnimalEditPage extends StatefulWidget {
  final Animal animal;

  const AnimalEditPage({Key? key, required this.animal}) : super(key: key);

  @override
  _AnimalEditPageState createState() => _AnimalEditPageState();
}

class _AnimalEditPageState extends State<AnimalEditPage> {
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Preenche os campos com os dados do animal
    _nameController.text = widget.animal.name;
    _typeController.text = widget.animal.type;
    _weightController.text = widget.animal.weight.toString();
    _ageController.text = widget.animal.age.toString();
    _descriptionController.text = widget.animal.description;
  }

  Future<void> _updateAnimal() async {
    // Atualiza os dados do animal
    widget.animal.name = _nameController.text;
    widget.animal.type = _typeController.text;
    widget.animal.weight = int.tryParse(_weightController.text) ?? widget.animal.weight;
    widget.animal.age = int.tryParse(_ageController.text) ?? widget.animal.age;
    widget.animal.description = _descriptionController.text;

    await AnimalHelper().updateAnimal(widget.animal);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Animal atualizado com sucesso!")),
    );

    Navigator.pop(context, true); // Retorna à tela anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Animal"),
        backgroundColor: const Color.fromARGB(255, 79, 192, 117),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? file =
                    await picker.pickImage(source: ImageSource.gallery);
                if (file != null) {
                  setState(() {
                    widget.animal.image = file.path;
                  });
                }
              },
              child: CircleAvatar(
                radius: 70,
                backgroundImage: widget.animal.image.isNotEmpty
                    ? FileImage(File(widget.animal.image))
                    : const AssetImage("assets/images/avatar.jpg") as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: "Tipo"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: "Peso"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: "Idade"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateAnimal,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 79, 192, 117),
              ),
              child: const Text("Salvar Alterações"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/app_database.dart';
import 'viewmodels/person_view_model.dart';
import 'dao/person_dao.dart';
import 'models/person.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database.personDao));
}

class MyApp extends StatelessWidget {
  final PersonDao personDao;

  MyApp(this.personDao);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PersonViewModel(personDao),
      child: MaterialApp(
        home: PersonScreen(),
      ),
    );
  }
}

class PersonScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final personViewModel = Provider.of<PersonViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Person List')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text;
              final age = int.tryParse(_ageController.text) ?? 0;
              personViewModel.addPerson(name, age);
            },
            child: Text('Add'),
          ),
          Expanded(
            child: StreamBuilder<List<Person>>(
              stream: personViewModel.persons,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  final persons = snapshot.data!;
                  if (persons.isEmpty) {
                    return Center(child: Text('No data available'));
                  }
                  return ListView.builder(
                    itemCount: persons.length,
                    itemBuilder: (context, index) {
                      final person = persons[index];
                      return ListTile(
                        title: Text('${person.name} - ${person.age} years old'),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

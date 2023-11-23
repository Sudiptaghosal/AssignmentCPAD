import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class Task {
  final String objectId;
  final String title;
  final String description;

  Task(
      {required this.objectId, required this.title, required this.description});
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String parseServerUrl = "https://parseapi.back4app.com/";
  final String applicationId = "msDUACF3uUG587QjFaqw9LTblun4vlJOAQ1PZ8b8";
  final String apiKey = "pb7LwHa0QG0I5hJQEkKTcHEcwTUXX7guSSsfTxlf";

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<Task> tasks = [];

  Future<void> createTask() async {
    try {
      final response = await Dio().post(
        '$parseServerUrl/classes/Tasks',
        data: {
          'title': titleController.text,
          'description': descriptionController.text,
        },
        options: Options(
          headers: {
            'X-Parse-Application-Id': applicationId,
            'X-Parse-REST-API-Key': apiKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      Task newTask = Task(
        objectId: response.data['objectId'],
        title: titleController.text,
        description: descriptionController.text,
      );

      setState(() {
        tasks.add(newTask);
      });

      print('Task created with objectId: ${response.data['objectId']}');
    } catch (error) {
      print('Error creating task: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SUDIPTA FLUTTER ASSIGNMENT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: createTask,
              child: Text('Create Task'),
            ),
            SizedBox(height: 16),
            Text(
              'Task List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tasks[index].title),
                    subtitle: Text(tasks[index].description),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
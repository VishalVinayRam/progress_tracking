import 'dart:convert';
import 'dart:io';

import 'package:exercise_tracker/images.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class Exercise {
  String name;
  String weight;
  String reps;

  Exercise({required this.name, required this.weight,required this.reps});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ViewScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Exercise> exercises = [];
  File? _image;
  TextEditingController weightController = TextEditingController();
  TextEditingController exerciseController = TextEditingController();
    TextEditingController reps = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       actions: [
       ElevatedButton(
  child: const Text("Home section"),
  onPressed: () {
    Navigator.of(context).pop(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ViewScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  },
),
       ],
        title: Text('Exercise Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: _image == null
            ? Text('Please take a photo before adding exercises.')
            : Column(
                children: [
                  
                  SizedBox(height: MediaQuery.of(context).size.height*.02,),
                  TextField(
          
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Enter Weight in KG'),
                  ),
                                    SizedBox(height: MediaQuery.of(context).size.height*.02,),

                  TextField(
                    controller: exerciseController,
                    decoration: InputDecoration(labelText: 'Enter Exercise'),
                  ),
                   TextField(
                    controller: reps,
                                        keyboardType: TextInputType.number,

                    decoration: InputDecoration(labelText: 'Enter Number of reps'),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*.02,),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                  ElevatedButton(
                    onPressed: () {
                      addExercise();
                    },
                    child: Text('Add Exercise'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _attachAndSave();
                    },
                    child: Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _pickImage();
                    },
                    child: Text('Take Photo'),
                  ),
                  
                ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(exercises[index].name),
                          subtitle: Text('Weight: ${exercises[index].weight}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pickImage();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void addExercise() {

    String exercise = exerciseController.text;
    String weight = weightController.text;
    if(exercises.isEmpty || weight.isEmpty || reps.text.isEmpty)
    {
         ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Enter all the requied details'),
      ),
      
    );
    }
    if (exercise.isNotEmpty && weight.isNotEmpty) {
      Exercise newExercise = Exercise(name: exercise, weight: weight,reps: reps.text);
      setState(() {
        exercises.add(newExercise);
        exerciseController.clear();
        weightController.clear();
        reps.clear();
      });
    }
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _attachAndSave() async {
  if (_image != null) {
    // Save the image to storage
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final imagePath = '${directory.path}/exercise_image_$timestamp.jpg';

    // Create the directory if it doesn't exist
    if (!Directory(directory.path).existsSync()) {
      Directory(directory.path).createSync(recursive: true);
    }

    await _image!.copy(imagePath);

    // Save the list of exercises and image path to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> storedData =
        prefs.getStringList('storedData')?.map((jsonString) {
      return Map<String, dynamic>.from(json.decode(jsonString));
    }).toList() ?? [];

    final List<String> exerciseList =
        exercises.map((e) => '${e.name}:${e.weight}').toList();

    final Map<String, dynamic> newData = {
      'imagePath': imagePath,
      'exerciseList': exerciseList,
    };
    storedData.add(newData);

    // Convert the list of maps to a list of JSON strings and save to SharedPreferences
    prefs.setStringList(
        'storedData', storedData.map((data) => json.encode(data)).toList());
    setState(() {
      exercises.clear();
    });


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exercises and image saved successfully.'),
      ),
      
    );

  } else {
    // Handle the case where no image is selected
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Please take a photo before saving."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
}

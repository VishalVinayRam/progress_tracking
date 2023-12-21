import 'dart:convert';
import 'dart:io';

import 'package:exercise_tracker/models/Exercise.dart';
import 'package:exercise_tracker/screens/Log.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../fitness_app_theme.dart';
import 'package:exercise_tracker/components/Drawer.dart';



class RunningView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const RunningView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
       splashColor: Colors.purple.withOpacity(0.1),
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: ()
      {
        showPopover(context);
      },
      child: AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation!,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 30 * (1.0 - animation!.value), 0.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 0, bottom: 0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: FitnessAppTheme.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: FitnessAppTheme.grey.withOpacity(0.4),
                                    offset: Offset(1.1, 1.1),
                                    blurRadius: 10.0),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.topLeft,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  child: SizedBox(
                                    height: 74,
                                    child: AspectRatio(
                                      aspectRatio: 1.714,
                                      child: Image.asset(
                                          "assets/back.png"),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 100,
                                            right: 16,
                                            top: 16,
                                          ),
                                          child: Text(
                                            "You're doing great!",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily:
                                                  FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              letterSpacing: 0.0,
                                              color:
                                                  FitnessAppTheme.nearlyDarkBlue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 100,
                                        bottom: 12,
                                        top: 4,
                                        right: 16,
                                      ),
                                      child: Text(
                                        "Keep it up\nand stick to your plan!",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          letterSpacing: 0.0,
                                          color: FitnessAppTheme.grey
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: -16,
                          left: 0,
                          child: SizedBox(
                            width: 110,
                            height: 110,
                            child: Image.asset("assets/runner.png"),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

 List<Exercise> exercises = [];
  File? _image;
  TextEditingController weightController = TextEditingController();
  TextEditingController exerciseController = TextEditingController();
    TextEditingController reps = TextEditingController();


void showPopover(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(button.size.bottomLeft(Offset.zero), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
 shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
      ),      color:   FitnessAppTheme.nearlyDarkBlue,
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          textStyle: TextStyle(color: Colors.white),
          child: Text('Add Exercise'),
          value: 'exercise',
        ),
        PopupMenuItem(
                    textStyle: TextStyle(color: Colors.white),
          child: Text('Add Water Level'),
          value: 'water',
        ),
      ],
    ).then((value) {
      if (value == 'exercise') {
        if (value == 'exercise') {
        // Handle Add Exercise
// showDialog(
//   context: context,
//   builder: (BuildContext context) {
//     return Dialog(
//       child: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//             TextField(
//               controller: weightController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: 'Enter Weight in KG'),
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//             TextField(
//               controller: exerciseController,
//               decoration: InputDecoration(labelText: 'Enter Exercise'),
//             ),
//             TextField(
//               controller: reps,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: 'Enter Number of reps'),
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     addExercise();
//                   },
//                   child: Text('Add Exercise'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     print("save button");
//                     _attachAndSave();
//                     Navigator.pop(context);
//                   },
//                   child: Text('Save'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                    var image = _pickImage();
                 
                    
//                   },
//                   child: Text('Take Photo'),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: exercises.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(exercises[index].name),
//                     subtitle: Text('Weight: ${exercises[index].weight}'),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   },
// );
Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()));

        }
      } else if (value == 'water') {
        // Handle Add Water Level
        print('Add Water Level');
      }
    });
  }

   void addExercise() {

    String exercise = exerciseController.text;
    String weight = weightController.text;
    
    if (exercise.isNotEmpty && weight.isNotEmpty) {
      Exercise newExercise = Exercise(name: exercise, weight: weight,reps: reps.text);

    }
  }

  Future<PickedFile?> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);
    return pickedFile;
  }

  Future<void> _attachAndSave() async {
  if (_image != null) {
    // Save the image to storage
    print("point1");
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final imagePath = '${directory.path}/exercise_image_$timestamp.jpg';

    // Create the directory if it doesn't exist
    if (!Directory(directory.path).existsSync()) {
      Directory(directory.path).createSync(recursive: true);
    }
    print("point2");
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
        'timestamp': timestamp,

    };
    storedData.add(newData);

    // Convert the list of maps to a list of JSON strings and save to SharedPreferences
    prefs.setStringList(
        'storedData', storedData.map((data) => json.encode(data)).toList());
    
    print("saved");
  
  } 
}
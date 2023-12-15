import 'dart:convert';

import 'package:exercise_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flip_card/flip_card.dart';


class ViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
           ElevatedButton(
          child: Text("Exercise section"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  MyHomePage()));
          },
           )
        ],
        title: Text('View Exercises'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available.'));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: snapshot.data!.length,
              padding: EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                String imagePath = snapshot.data![index]['imagePath'];
                List<dynamic> exerciseList = snapshot.data![index]['exerciseList'];
List<dynamic> reps = snapshot.data![index]['exerciseList'];

                return _buildFlipCard(imagePath, exerciseList,reps);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildFlipCard(String imagePath, List<dynamic> exerciseList,List<dynamic> reps) {
    return FlipCard(
      front: Card(
        elevation: 5.0,
        child: Column(
          children: [
            Image.file(
              File(imagePath),
              width: 200,
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
      back: Card(
        elevation: 5.0,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: exerciseList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(exerciseList[index]),
                subtitle: Text(reps[index].toString())??Text("1"),
              );
            },
          ),
        ),
      ),
    );
  }


  Future<List<Map<String, dynamic>>> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? storedDataStrings = prefs.getStringList('storedData');

    if (storedDataStrings != null) {
      return storedDataStrings.map((jsonString) {
        return Map<String, dynamic>.from(json.decode(jsonString));
      }).toList();
    } else {
      return [];
    }
  }
}
// class ViewScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('View Exercises'),
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: _loadData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data == null) {
//             return Center(child: Text('No data available.'));
//           } else {
//             String imagePath = snapshot.data!['imagePath'];
//             List<String> exerciseList = snapshot.data!['exerciseList'];

//             return GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 8.0,
//                 mainAxisSpacing: 8.0,
//               ),
//               itemCount: 1 + exerciseList.length, // Image + Exercises
//               padding: EdgeInsets.all(8.0),
//               itemBuilder: (context, index) {
//                 if (index == 0) {
//                   return Image.file(
//                     File(imagePath),
//                     width: 200,
//                     height: 200,
//                     fit: BoxFit.cover,
//                   );
//                 } else {
//                   int exerciseIndex = index - 1;
//                   String exercise = exerciseList[exerciseIndex];
//                   return _buildExerciseCard(exercise);
//                 }
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildExerciseCard(String exercise) {
//     return Card(
//       elevation: 5.0,
//       child: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Center(
//           child: Text(
//             exercise,
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }

//   Future<Map<String, dynamic>> _loadData() async {
//     final prefs = await SharedPreferences.getInstance();

//     String? imagePath = prefs.getString('imagePath');
//     List<String>? exerciseList = prefs.getStringList('exercises');

//     return {'imagePath': imagePath, 'exerciseList': exerciseList ?? []};
//   }
// }
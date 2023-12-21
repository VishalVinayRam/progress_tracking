import 'package:exercise_tracker/homes_screen%20/fitness_app_home_screen.dart';
import 'package:exercise_tracker/screens/View_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 SystemChrome.setPreferredOrientations([
   DeviceOrientation.portraitUp,
   DeviceOrientation.portraitDown,
 ]);
//  await Firebase.initializeApp();
 runApp(MyApp());
}
 



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  FitnessAppHomeScreen(),
      theme: ThemeData(primarySwatch: Colors.blue),
      
    );
  }
}


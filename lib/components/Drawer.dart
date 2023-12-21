
import 'package:exercise_tracker/screens/HomeScreen.dart';
import 'package:exercise_tracker/screens/Log.dart';
import 'package:exercise_tracker/screens/View_screen.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: CircleAvatar(child:Image.asset('assets/download.jpeg'),radius:1,)
            
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Home'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>
              HomeScreen()))
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Exercise List'),
            onTap: () => {
               Navigator.push(context, MaterialPageRoute(builder: (context)=>
              ViewScreen()))
            },
          ),
           ListTile(
            leading: Icon(Icons.note_add),
            title: Text('Add Exercise'),
            onTap: () => {
               Navigator.push(context, MaterialPageRoute(builder: (context)=>
              MyHomePage()))
            },
          ),
           ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.popAndPushNamed(context, '/exercise')},
          ),
          ListTile(
            leading: Icon(Icons.water),
            title: Text('Add water'),
            onTap: () => {Navigator.popAndPushNamed(context, '/exercise')},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
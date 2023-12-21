import 'dart:convert';
import 'dart:io';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fitness_app_theme.dart';

class AreaListView extends StatefulWidget {
  const AreaListView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  @override
  _AreaListViewState createState() => _AreaListViewState();
}

class _AreaListViewState extends State<AreaListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<String> areaListData = <String>[
    'assets/area1.png',
    'assets/area2.png',
    'assets/area3.png',
  ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: FutureBuilder<List<Map<String, dynamic>>>(
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
              ),
            ),
          ),
        );
      },
    );
  }
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


  Widget _buildFlipCard(String imagePath, List<dynamic> exerciseList,List<dynamic> reps) {
    String date = '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    return FlipCard(
      front: Card(
        elevation: 5.0,
        child: Column(
          children: [
                        Text(date),

             SizedBox(height: 8),
            Image.file(
              File(imagePath),
              width: 200,
              height: 150,
              fit: BoxFit.cover,
            ),
           
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

class AreaView extends StatelessWidget {
  const AreaView({
    Key? key,
    this.imagepath,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final String? imagepath;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: FitnessAppTheme.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: FitnessAppTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  splashColor: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.2),
                  onTap: () {},
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Image.asset(imagepath!),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

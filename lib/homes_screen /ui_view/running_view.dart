import 'package:exercise_tracker/screens/Log.dart';
import 'package:flutter/material.dart';
import '../fitness_app_theme.dart';

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
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: Text('Add Exercise'),
          value: 'exercise',
        ),
        PopupMenuItem(
          child: Text('Add Water Level'),
          value: 'water',
        ),
      ],
    ).then((value) {
      if (value == 'exercise') {
        // Handle Add Exercise
        print('Add Exercise');
      } else if (value == 'water') {
        // Handle Add Water Level
        print('Add Water Level');
      }
    });
  }
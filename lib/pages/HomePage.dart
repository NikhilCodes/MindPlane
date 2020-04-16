import 'dart:async';
import 'dart:math';

import 'package:MindPlane/global_data.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:MindPlane/pages/editpage.dart';
import 'package:MindPlane/special_widgets/cardview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool starAnimate = true;
  bool backgroundEnabled = false;
  String greetingTime = "";
  String userName = "";

  /// Flare Animation Modes
  String botAnimation = "reposo";
  SharedPreferences prefs;

  void cometFlyAway() {
    setState(() {
      starAnimate = false;
    });
    Timer(Duration(seconds: Random().nextInt(15)), () {
      setState(() {
        starAnimate = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => startUpJobs(context));
  }

  Future startUpJobs(BuildContext context) async {
    var hr = TimeOfDay.fromDateTime(DateTime.now()).hour;
    setState(() {
      if (hr >= 4 && hr < 12) {
        greetingTime = "Morning";
      } else if (hr >= 12 && hr < 18) {
        greetingTime = "Afternoon";
      } else if (hr >= 6 && hr < 20) {
        greetingTime = "Evening";
      } else {
        greetingTime = "Night";
      }
    });

    prefs = await SharedPreferences.getInstance();
    setState(() {
      backgroundEnabled = true;
      if (prefs.containsKey("username")) {
        userName = prefs.getString("username");
      }
    });
    if (prefs.containsKey("first-time")) {
      await prefs.setBool("first-time", false);
    } else {
      await prefs.setBool("first-time", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AnimatedOpacity(
            duration: Duration(milliseconds: 900),
            opacity: (backgroundEnabled) ? 1 : 0,
            child: FlareActor(
              "assets/stars animation.flr",
              animation: (starAnimate) ? "star" : null,
              callback: (_) => cometFlyAway(),
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        botAnimation = "buscando";
                      });
                      Timer(Duration(milliseconds: 8200), () {
                        setState(() {
                          botAnimation = "reposo";
                        });
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 1000),
                      opacity: (backgroundEnabled) ? 1 : 0,
                      child: Hero(
                        tag: "stupid-bot",
                        child: FlareActor(
                          "assets/bot.flr",
                          animation: botAnimation,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      (greetingTime != "") ? "Good $greetingTime" : "",
                      style: TextStyle(
                        color: Colors.tealAccent.shade100,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: "Spartan",
                      ),
                    ),
                    Text(
                      "$userName",
                      style: TextStyle(
                        color: Colors.lightBlueAccent.shade100,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: "ComicNeue",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              AnimatedOpacity(
                opacity: (backgroundEnabled) ? 1 : 0,
                duration: Duration(seconds: 1),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.48,
                  width: MediaQuery.of(context).size.width,
                  child: prefs != null &&
                          (prefs.getStringList("dataKeys") ?? []).length != 0
                      ? Swiper(
                          duration: 100,
                          physics: BouncingScrollPhysics(),
                          itemCount: prefs == null
                              ? 0
                              : (prefs.getStringList("dataKeys") ?? []).length,
                          viewportFraction: 0.74,
                          scale: 0.81,
                          scrollDirection: Axis.horizontal,
                          loop: false,
                          itemBuilder: (BuildContext context, int index) {
                            List<List<String>> data = [];
                            print("Rebuilding Swiper...");
                            if (prefs.containsKey('dataKeys')) {
                              prefs
                                  .getStringList("dataKeys")
                                  .forEach((element) {
                                data.add(prefs.getStringList(element));
                              });
                            }

                            return Hero(
                              key: Key(index.toString()),
                              tag: "edit-button-$index",
                              child: Material(
                                key: Key(index.toString()),
                                color: Colors.transparent,
                                child: CardView(
                                  data: data[index],
                                  id: index,
                                ),
                              ),
                            );
                          },
                        )
                      : EmptyIndicationCard(),
                ),
              ),
              Expanded(
                child: Center(
                  child: Hero(
                    tag: "add-button",
                    child: Container(
                      height: 66,
                      width: 66,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(33),
                      ),
                      child: GestureDetector(
                        child: Icon(Icons.add, size: 40),
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => EditPage(autoGen: true)),
                          );
                          setState(() {
                            prefs.getStringList("dataKeys");
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

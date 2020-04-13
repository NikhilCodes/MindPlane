import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MindPlane/pages/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewUserScreen extends StatefulWidget {
  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen>
    with SingleTickerProviderStateMixin {
  SharedPreferences prefs;
  TextEditingController _controller = TextEditingController();
  bool botVisible = false;
  bool intro1Enabled = false;
  bool intro2Enabled = false;
  bool inputSectionEnabled = false;

  Widget inputWidget;

  void startUpJobs(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      botVisible = true;
    });
    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        intro1Enabled = true;
      });
    });

    Timer(Duration(milliseconds: 2300), () {
      setState(() {
        intro2Enabled = true;
      });
    });

    Timer(Duration(milliseconds: 3500), () {
      setState(() {
        inputSectionEnabled = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => startUpJobs(context));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    inputWidget = Column(
      children: <Widget>[
        TextField(
          textCapitalization: TextCapitalization.sentences,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: Colors.white70,
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
            hintText: "They call me...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white, width: 5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
          ),
          controller: _controller,
        ),
        SizedBox(height: 35),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 60,
            width: 180,
            child: Stack(
              children: <Widget>[
                Container(
                  width: 180,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.deepPurpleAccent],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                Material(
                  color: Colors.white.withOpacity(0.0),
                  child: InkWell(
                    splashColor: Colors.purple,
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      if (_controller.text.trim() == "") {
                        return null;
                      }
                      prefs.setString("username", _controller.text);
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            transitionDuration: Duration(seconds: 1),
                            pageBuilder: (_, __, ___) =>
                                MyHomePage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.indigo],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight)),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            AnimatedOpacity(
              opacity: (botVisible) ? 1 : 0,
              duration: Duration(seconds: 1),
              child: SizedBox(
                height: 200,
                width: 200,
                child: Hero(
                  tag: "stupid-bot",
                  child: FlareActor(
                    "assets/bot.flr",
                    animation: "reposo",
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: (intro1Enabled) ? 1 : 0,
              duration: Duration(seconds: 1),
              child: Column(
                children: <Widget>[
                  Text(
                    "Hey there!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Quicksand",
                    ),
                  ),
                  Text(
                    "I'm Blu.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      fontFamily: "Quicksand",
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              height: intro2Enabled ? 20 : 80,
            ),
            AnimatedOpacity(
              opacity: intro2Enabled ? 1 : 0,
              duration: Duration(seconds: 1),
              child: Text(
                "Nice to meet you! \nWhat do your friends call you?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Quicksand",
                ),
              ),
            ),
            SizedBox(height: 20),
            AnimatedOpacity(
              opacity: inputSectionEnabled ? 1 : 0,
              duration: Duration(seconds: 1),
              child: inputWidget,
            ),
          ],
        ),
      ),
    );
  }
}

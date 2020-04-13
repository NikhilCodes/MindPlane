import 'package:flare_loading/flare_loading.dart';
import 'package:flutter/material.dart';
import 'package:MindPlane/pages/HomePage.dart';
import 'package:MindPlane/pages/NewUserScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var animationOver = false;
  SharedPreferences prefs;

  startUpJobs(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => startUpJobs(context));
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            height: 500,
            child: FlareLoading(
              name: "assets/Trim.flr",
              startAnimation: "Untitled",
              onSuccess: (data) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => prefs.containsKey("first-time")
                        ? MyHomePage()
                        : NewUserScreen(),
                  ),
                );
              },
              onError: (error, stacktrace) {},
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Text(
              "Mind Plane",
              style: TextStyle(
                fontSize: 40,
                fontFamily: "Pacifico",
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:math';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_loading/flare_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:MindPlane/global_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key, this.data, this.autoGen, this.id}) : super(key: key);

  bool autoGen;
  final data;
  final int id;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage>
    with SingleTickerProviderStateMixin {
  List<String> data = [
    "",
    "0",
    "",
    "",
    "",
  ];
  bool explodeColoredCircle = false;
  bool showInputSection1 = false;
  bool showInputSection2 = false;
  String saveStatus = "";
  TextEditingController _headingController = TextEditingController(),
      _bodyController = TextEditingController();
  SharedPreferences prefs;

  void autoAssignData() {
    var now = DateTime.now();
    data = [
      "",
      "${Random().nextInt(safeColors.length)}",
      "${now.day}".padLeft(2, "0"),
      "${monthNames[now.month]}",
      "${now.year}",
      "",
    ];
  }

  void startUpJobs(BuildContext context) async {
    if (widget.autoGen == true) {
      autoAssignData();
    } else {
      data = widget.data;
      _headingController.text = data[0];
      _bodyController.text = data[5];
    }

    Timer(Duration(milliseconds: 500), () {
      setState(() {
        explodeColoredCircle = true;
      });
    });

    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        showInputSection1 = true;
      });
    });
    Timer(Duration(milliseconds: 1500), () {
      setState(() {
        showInputSection2 = true;
      });
    });

    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => startUpJobs(context));
  }

  void deleteJournal(int index) async {
    var timestamps = prefs.getStringList("dataKeys");
    var _toRemoveData = timestamps[index];
    timestamps.removeAt(index);
    await prefs.setStringList("dataKeys", timestamps);
    await prefs.remove(_toRemoveData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: widget.autoGen == true
            ? "add-button"
            : widget.autoGen == null ? "edit-button-${widget.id}" : "",
        child: Container(
          child: Stack(
            // Contains screen, date and close button
            children: <Widget>[
              Material(
                textStyle: TextStyle(
                  color: safeColors[int.parse(data[1])],
                  fontFamily: "Quicksand",
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      AnimatedContainer(
                        curve: Curves.easeIn,
                        duration: Duration(milliseconds: 400),
                        height: 190 + (showInputSection1 ? 0.0 : 100.0),
                      ),
                      AnimatedOpacity(
                        curve: Curves.easeIn,
                        opacity: showInputSection1 ? 1 : 0,
                        duration: Duration(milliseconds: 400),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("How would was your day?"),
                            SizedBox(height: 7),
                            TextField(
                              controller: _headingController,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                color: safeColors[int.parse(data[1])],
                                fontSize: 25,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: safeColors[int.parse(data[1])],
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: safeColors[int.parse(data[1])],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///
                      AnimatedContainer(
                        curve: Curves.easeIn,
                        duration: Duration(milliseconds: 400),
                        height: 30 + (showInputSection2 ? 0.0 : 100.0),
                      ),
                      AnimatedOpacity(
                        curve: Curves.easeIn,
                        duration: Duration(milliseconds: 400),
                        opacity: showInputSection2 ? 1 : 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Describe it, if you may!"),
                            SizedBox(height: 7),
                            TextField(
                              controller: _bodyController,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                color: safeColors[int.parse(data[1])],
                                fontSize: 22,
                              ),
                              minLines: 5,
                              maxLines: 10,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: safeColors[int.parse(data[1])],
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: safeColors[int.parse(data[1])],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      FlatButton(
                        onPressed: () async {
                          if (_headingController.text.trim() == "") {
                            return null;
                          }
                          if (widget.autoGen == true) {
                            var journalDataKeys =
                                prefs.getStringList("dataKeys") ?? [];
                            var timeStamp = DateTime.now().toIso8601String();
                            data[0] = _headingController.text;
                            data[5] = _bodyController.text;

                            journalDataKeys.insert(0, "data_$timeStamp");
                            await prefs.setStringList(
                                "dataKeys", journalDataKeys);
                            await prefs.setStringList("data_$timeStamp", data);
                          } else {
                            var timestamp =
                                prefs.getStringList("dataKeys")[widget.id];
                            data = prefs.getStringList(timestamp);
                            data[0] = _headingController.text;
                            data[5] = _bodyController.text;

                            await prefs.setStringList(timestamp, data);
                          }
                          setState(() {
                            saveStatus = "Untitled";
                            widget.autoGen = false;
                          });
                        },
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: safeColors[int.parse(data[1])],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 800),
                curve: Curves.fastLinearToSlowEaseIn,
                transform: Matrix4.translationValues(
                  explodeColoredCircle ? -190 : -300,
                  explodeColoredCircle ? -90 : -300,
                  0,
                ),
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: explodeColoredCircle
                      ? safeColors[int.parse(data[1])]
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(150),
                ),
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.only(left: 15, right: 38, bottom: 80),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        data[2],
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        data[3],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        data[4],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  height: 70,
                  width: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,

                    //mainAxisSize: MainAxisSize.min,
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.only(right: 10, top: 25),
                            alignment: Alignment.topRight,
                            child: Transform.rotate(
                              child: Icon(Icons.add,
                                  size: 40, color: Colors.purple.shade700),
                              angle: pi / 4,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ),
                      widget.autoGen == true
                          ? Container()
                          : SizedBox(
                              height: 70,
                              width: 70,
                              child: GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.only(right: 10, top: 27),
                                  alignment: Alignment.topRight,
                                  child: Icon(Icons.delete,
                                      size: 30, color: Colors.purple.shade500),
                                ),
                                onTap: () {
                                  setState(() {
                                    widget.autoGen = false;
                                  });
                                  deleteJournal(widget.id);
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              saveStatus == "Untitled"
                  ? Center(
                      child: AnimatedContainer(
                        alignment: Alignment.center,
                        duration: Duration(milliseconds: 200),
                        height: 350,
                        width: 350,
                        child: FlareLoading(
                          name: "assets/Success Check.flr",
                          startAnimation: saveStatus,
                          onSuccess: (data) {
                            Navigator.of(context).pop(true);
                          },
                          onError: (error, stacktrace) => print(stacktrace),
                        ),
                      ),
                    )
                  : SizedBox(width: 0, height: 0),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MindPlane/global_data.dart';
import 'package:MindPlane/pages/editpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardView extends StatefulWidget {
  CardView({Key key, @required this.data, this.id});

  final List<String> data;
  final int id;

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    var color = safeColors[int.parse(widget.data[1])];
    var text = widget.data[0];
    var date = widget.data.sublist(2);

    var hMargin = 7.0; // Margin on left and right side of card.
    var vMargin = 20.0;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          margin:
              EdgeInsets.only(left: hMargin, right: hMargin, bottom: vMargin),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 20,
                spreadRadius: -20,
                offset: Offset(0, 20),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    EditPage(data: widget.data, id: widget.id),
              ),
            );
            setState(() {
              prefs.getStringList("dataKeys");
            });
          },
          child: Container(
            margin:
                EdgeInsets.only(left: hMargin, right: hMargin, bottom: vMargin),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.65)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        date[0],
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        date[1],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        date[2],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w600,
                      fontSize: 23,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EmptyIndicationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.88,
      widthFactor: 0.68,
      child: GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => EditPage(autoGen: true)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.3),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 50,
                    ),
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 100,
                    ),
                  ],
                ),
                Icon(
                  Icons.short_text,
                  color: Colors.white,
                  size: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

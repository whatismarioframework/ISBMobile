import 'dart:convert';
import 'package:app_isb/Utility/google_API.dart';
import 'package:app_isb/Utility/user_model.dart';
import 'package:app_isb/Utility/utility.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final orderClass = [
    User("Free", "", "", "", "N/A"),
    User("Free", "", "", "", "N/A"),
    User("Free", "", "", "", "N/A"),
    User("Free", "", "", "", "N/A"),
    User("Free", "", "", "", "N/A")
  ];

  String y = DateFormat.y('en_US').format(DateTime.now());
  String M = DateFormat.M('en_US').format(DateTime.now());
  String d = DateFormat.d('en_US').format(DateTime.now());
  String yMd;

  void getDate() async {
    int uM = int.parse(M);
    int uD = int.parse(d);
    String uuM = M;
    String uuD = d;
    if (uM < 10) {
      uuM = "0" + M;
    }
    if (uD < 10) {
      uuD = "0" + d;
    }
    yMd = ("$uuM/$uuD/$y");
  }

  getData() async {
    var url = Uri.parse(
        "https://communicationapp.isb.ac.th/getsqli.php?stuId=" +
            googleAPI.id +
            "&date=" +
            yMd);
    final post = await http.get(url);
    var data = json.decode(post.body);
    List<User> users = [];
    for (var u in data) {
      User user = User(u["SUBJECT"], u["START_TIME"], u["END_TIME"],
          u["DESCRIPTION"], u["LOCATION"]);
      if (user.Subject != "Advisory") {
        users.add(user);
        if (user.Start_Time == "07:50") {
          orderClass[0] = user;
        } else if (user.Start_Time == "09:50") {
          orderClass[1] = user;
        } else if (user.Start_Time == "11:20") {
          orderClass[2] = user;
        } else if (user.Start_Time == "13:20") {
          orderClass[3] = user;
        }
      }
    }
    return users;
  }

  @override
  //String something = initState();
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double bWidth = width * 0.9;
    double eWidth = width * 0.05;

    getDate();

    return Scaffold(
        body: Padding(
      padding: EdgeInsets.fromLTRB(eWidth, 0, eWidth, 0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ShareItem().SizedBoxCus(10, 10),
            classes(0, "07:50 - 09:10"),
            ShareItem().SizedBoxCus(10, 10),
            sContainer("Advisory", "09:15 - 09:30"),
            ShareItem().SizedBoxCus(10, 10),
            sContainer("Break", "09:30 - 09:50"),
            ShareItem().SizedBoxCus(10, 10),
            classes(1, "09:50 - 11:10"),
            ShareItem().SizedBoxCus(10, 10),
            classes(2, "11:20 - 12:40"),
            ShareItem().SizedBoxCus(10, 10),
            sContainer("Lunch", "12:40 - 13:20"),
            ShareItem().SizedBoxCus(10, 10),
            classes(3, "13:20 - 14:40"),
            ShareItem().SizedBoxCus(10, 10),
            sContainer("Panther Block", "14:50- 15:30"),
            ShareItem().SizedBoxCus(10, 10),
          ],
        ),
      ),
    ));
  }

  Container sContainer(String title, String time) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(225, 226, 227, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          ),
          trailing: Text(
            time,
            style: TextStyle(fontSize: 15, height: 1, color: Colors.black),
          ),
        ),
      ),
    );
  }

  FutureBuilder classes(int list, String time) {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container(
              height: 100,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 200, 87, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          } else {
            return Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 200, 87, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: ListTile(
                    title: Text(
                      orderClass[list].Subject,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      orderClass[list].Location,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    trailing: Text(
                      time,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ));
          }
        });
  }
}

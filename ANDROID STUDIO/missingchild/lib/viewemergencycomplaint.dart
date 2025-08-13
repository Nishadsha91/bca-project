import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'homes.dart';
import 'viewupdates.dart';
import 'package:missingchild/add_missing_case.dart';
import 'package:missingchild/edit_missing.dart';

class Viewemergencycomplaint extends StatefulWidget {
  @override
  _ViewemergencycomplaintState createState() => _ViewemergencycomplaintState();
}

class _ViewemergencycomplaintState extends State<Viewemergencycomplaint> {
  List<String> ccid_ = <String>[];
  List<String> message_ = <String>[];
  List<String> date_ = <String>[];
  List<String> status_ = <String>[];
  List<String> reply_ = <String>[];

  _ViewemergencycomplaintState() {
    load();
  }

  Future<void> load() async {
    List<String> ccid = <String>[];
    List<String> message = <String>[];
    List<String> date = <String>[];
    List<String> sts = <String>[];
    List<String> reply = <String>[];

    try {
      final pref = await SharedPreferences.getInstance();
      String lid = pref.getString("lid").toString();
      String hid = pref.getString("hid").toString();
      String ip = pref.getString("url").toString();

      String url = ip + "/user_view_emergency";
      var data = await http.post(Uri.parse(url), body: {
        'lid': lid, "hid": hid
      });

      var jsondata = json.decode(data.body);
      String status = jsondata['status'];

      var arr = jsondata["data"];
      for (int i = 0; i < arr.length; i++) {
        ccid.add(arr[i]['id'].toString());
        message.add(arr[i]['message'].toString());
        date.add(arr[i]['date'].toString());
        sts.add(arr[i]['status'].toString());
        reply.add(arr[i]['reply'].toString());
      }
      setState(() {
        ccid_ = ccid;
        message_ = message;
        date_ = date;
        status_ = sts;
        reply_ = reply;
      });
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Light blue background
      appBar: AppBar(
        backgroundColor: Colors.teal, // Dark teal AppBar background
        title: Text(
          "Emergency Complaints",
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: ccid_.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.grey[850], // Dark grey card background for contrast
              elevation: 8.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date: ${date_[index]}",
                      style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Message: ${message_[index]}",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Reply: ${reply_[index]}",
                      style: TextStyle(color: Colors.greenAccent, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.info_outline, color: Colors.blueAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red, // Red button for immediate attention
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewViewemergencycomplaintPage()),
          ).then((newViewemergencycomplaint) {
            if (newViewemergencycomplaint != null) {
              setState(() {
                // Assuming new complaint data would be added to the list
              });
            }
          });
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class NewViewemergencycomplaintPage extends StatefulWidget {
  @override
  _NewViewemergencycomplaintPageState createState() => _NewViewemergencycomplaintPageState();
}

class _NewViewemergencycomplaintPageState extends State<NewViewemergencycomplaintPage> {
  final TextEditingController _ViewemergencycomplaintController = TextEditingController();

  @override
  void dispose() {
    _ViewemergencycomplaintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,  // Light blue background
      appBar: AppBar(
        backgroundColor: Colors.teal,  // Dark teal AppBar background
        title: Text("Write New Emergency Complaint", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _ViewemergencycomplaintController,
              style: TextStyle(color: Colors.black),  // Dark text for readability
              decoration: InputDecoration(
                hintText: "Enter your Complaint...",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,  // White text field for contrast
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final sh = await SharedPreferences.getInstance();
                String Viewemergencycomplaint = _ViewemergencycomplaintController.text.toString();
                String url = sh.getString("url").toString();
                String lid = sh.getString("lid").toString();
                String hid = sh.getString("hid").toString();

                var data = await http.post(
                    Uri.parse(url + "/sendemgcomplaint"),
                    body: {'msg': Viewemergencycomplaint, 'lid': lid, 'hid': hid});

                var jasondata = json.decode(data.body);
                String status = jasondata['task'].toString();
                if (status == "ok") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MissingHome()));
                } else {
                  print("Error occurred");
                }
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),  // Red button for immediate attention
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: Text("Submit Complaint", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

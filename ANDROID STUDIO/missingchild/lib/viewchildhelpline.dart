import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat.dart';
import 'homes.dart';
import 'viewemergencycomplaint.dart';

class Viewchildhelpline extends StatefulWidget {
  const Viewchildhelpline({super.key, required this.title});

  final String title;

  @override
  State<Viewchildhelpline> createState() => _ViewchildhelplineState();
}

class _ViewchildhelplineState extends State<Viewchildhelpline> {
  _ViewchildhelplineState() {
    fetchChildHelplines();
  }

  TextEditingController _searchController = TextEditingController();
  List<String> id_ = [];
  List<String> name_ = [];
  List<String> phone_ = [];
  List<String> place_ = [];
  List<String> post_ = [];
  List<String> email_ = [];
  List<String> tid_ = [];

  List<String> filteredId_ = [];
  List<String> filteredName_ = [];
  List<String> filteredPhone_ = [];
  List<String> filteredPlace_ = [];
  List<String> filteredPost_ = [];
  List<String> filteredEmail_ = [];
  List<String> filteredTid_ = [];

  void fetchChildHelplines() async {
    List<String> id = <String>[];
    List<String> name = <String>[];
    List<String> phone = <String>[];
    List<String> place = <String>[];
    List<String> post = <String>[];
    List<String> email = <String>[];
    List<String> tid = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String url = urls + '/user_view_helpline';
      var data = await http.post(Uri.parse(url));
      var jsondata = json.decode(data.body);
      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        name.add(arr[i]['name'].toString());
        phone.add(arr[i]['phone'].toString());
        place.add(arr[i]['place'].toString());
        post.add(arr[i]['post'].toString());
        email.add(arr[i]['email'].toString());
        tid.add(arr[i]['lid'].toString());
      }

      setState(() {
        id_ = id;
        name_ = name;
        phone_ = phone;
        place_ = place;
        post_ = post;
        email_ = email;
        tid_ = tid;

        filteredId_ = List.from(id_);
        filteredName_ = List.from(name_);
        filteredPhone_ = List.from(phone_);
        filteredPlace_ = List.from(place_);
        filteredPost_ = List.from(post_);
        filteredEmail_ = List.from(email_);
        filteredTid_ = List.from(tid_);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void searchByPlace() {
    String query = _searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredId_ = List.from(id_);
        filteredName_ = List.from(name_);
        filteredPhone_ = List.from(phone_);
        filteredPlace_ = List.from(place_);
        filteredPost_ = List.from(post_);
        filteredEmail_ = List.from(email_);
        filteredTid_ = List.from(tid_);
      } else {
        filteredId_ = [];
        filteredName_ = [];
        filteredPhone_ = [];
        filteredPlace_ = [];
        filteredPost_ = [];
        filteredEmail_ = [];
        filteredTid_ = [];

        for (int i = 0; i < place_.length; i++) {
          if (place_[i].toLowerCase().contains(query)) {
            filteredId_.add(id_[i]);
            filteredName_.add(name_[i]);
            filteredPhone_.add(phone_[i]);
            filteredPlace_.add(place_[i]);
            filteredPost_.add(post_[i]);
            filteredEmail_.add(email_[i]);
            filteredTid_.add(tid_[i]);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Dark teal AppBar
        title: Text(
          'Child Helpline',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.blue.shade50, // Light blue background
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: Colors.black), // Dark text
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white, // White background for search field
                      labelText: "Search by place",
                      labelStyle: TextStyle(color: Colors.black54),
                      hintText: "Enter place name",
                      hintStyle: TextStyle(color: Colors.black26),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: searchByPlace,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent, // Soft blue for search button
                  ),
                  child: Icon(Icons.search, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredId_.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  color: Colors.white, // White background for each card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: ${filteredName_[index]}",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        Text(
                          "Phone: ${filteredPhone_[index]}",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        Text(
                          "Place: ${filteredPlace_[index]}",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        Text(
                          "Post: ${filteredPost_[index]}",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        Text(
                          "Email: ${filteredEmail_[index]}",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('hid', filteredId_[index]);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Viewemergencycomplaint()));
                              },
                              icon: Icon(Icons.help, color: Colors.white),
                              label: Text("Help"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red), // Red for "Help"
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('toid', filteredTid_[index]);
                                prefs.setString('name', filteredName_[index]);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyChatPage()));
                              },
                              icon: Icon(Icons.chat, color: Colors.white),
                              label: Text("Chat"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), // Blue for "Chat"
                            ),
                            // ElevatedButton(
                            //   onPressed: () async {
                            //     SharedPreferences sh = await SharedPreferences.getInstance();
                            //     sh.setString('clid', filteredId_[index].toString());
                            //
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(builder: (context) => MyChatPage()),
                            //     );
                            //   },
                            //   style: ElevatedButton.styleFrom(
                            //     primary: Colors.green, // Set the background color to green
                            //   ),
                            //   child: Icon(Icons.chat),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

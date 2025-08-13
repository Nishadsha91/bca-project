
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatesScreen extends StatefulWidget {
  final int caseId;
  final String childName;

  const UpdatesScreen({required this.caseId, required this.childName});

  @override
  _UpdatesScreenState createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  List<String> descriptions = [];
  List<String> dates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUpdates();
  }

  Future<void> fetchUpdates() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String url = '$urls/view_missingcase_updates';

      var response = await http.post(Uri.parse(url), body: {
        "case_id": widget.caseId.toString(),
      });

      var jsondata = json.decode(response.body);

      if (jsondata['status'] == "ok") {
        var updates = jsondata['data'];
        for (var update in updates) {
          descriptions.add(update['description']);
          dates.add(update['date']);
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching updates: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background to black
      appBar: AppBar(
        backgroundColor: Colors.black87, // Dark app bar
        title: Text(
          "Updates for ${widget.childName}",
          style: TextStyle(color: Colors.white), // White text for contrast
        ),
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : descriptions.isEmpty
          ? Center(
        child: Text(
          "No updates available",
          style: TextStyle(color: Colors.white), // White text
        ),
      )
          : ListView.builder(
        itemCount: descriptions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.grey[850], // Dark card color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  "Update: ${descriptions[index]}",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Date: ${dates[index]}",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:missingchild/sendcomplaint.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewRepliesPage extends StatefulWidget {
  const ViewRepliesPage({super.key});

  @override
  State<ViewRepliesPage> createState() => _ViewRepliesPageState();
}

class _ViewRepliesPageState extends State<ViewRepliesPage> {
  List<int> complaintIds = [];
  List<String> reply = [];
  List<String> description = [];
  List<String> date = [];

  @override
  void initState() {
    super.initState();
    loadReplies();
  }

  Future<void> loadReplies() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String url = "${pref.getString("url") ?? ''}/user_view_complaint";

      var response = await http.post(
        Uri.parse(url),
        body: {'lid': pref.getString("lid")},
      );

      var jsonData = json.decode(response.body);
      String status = jsonData['status'];

      if (status == "ok") {
        var data = jsonData["data"];
        for (var item in data) {
          complaintIds.add(item['id']); // Assuming 'id' is the complaint ID
          reply.add(item['reply'].toString());
          description.add(item['description'].toString());
          date.add(item['date'].toString());
        }

        setState(() {});
      } else {
        print("Error: ${jsonData['message']}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> deleteComplaint(int index) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String url = "${pref.getString("url") ?? ''}/delete_complaint";

      var response = await http.post(
        Uri.parse(url),
        body: {'complaint': complaintIds[index].toString()}, // Send complaint ID
      );

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        Fluttertoast.showToast(
          msg: "Complaint deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );

        // Remove the deleted complaint from the lists
        setState(() {
          complaintIds.removeAt(index);
          reply.removeAt(index);
          description.removeAt(index);
          date.removeAt(index);
        });
      } else {
        Fluttertoast.showToast(
          msg: "Failed to delete complaint",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Complaints",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal, // Dark teal AppBar
      ),
      backgroundColor: Colors.blue.shade50, // Light blue background
      body: reply.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, color: Colors.grey, size: 80),
            const SizedBox(height: 20),
            const Text(
              "No replies found",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: reply.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 8,
            color: Colors.grey[900], // Dark grey background for cards
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Delete Complaint"),
                              content: const Text(
                                  "Are you sure you want to delete this complaint?"),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );

                          if (shouldDelete ?? false) {
                            await deleteComplaint(index);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent, // Red for "Delete"
                          minimumSize: const Size(80, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "DELETE",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Description: ${description[index]}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Reply: ${reply[index]}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Date: ${date[index]}",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SendComplaintPage(),
            ),
          );
        },
        backgroundColor: Colors.blue[800], // Dark blue for "Add Complaint"
        child: const Icon(Icons.add),
      ),
    );
  }
}



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:missingchild/viewcomplaint.dart';

class SendComplaintPage extends StatefulWidget {
  @override
  _SendComplaintPageState createState() => _SendComplaintPageState();
}

class _SendComplaintPageState extends State<SendComplaintPage> {
  TextEditingController complaintController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        title: Text(
          "Add Complaints",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  "Submit your complaint",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    maxLines: 4,
                    controller: complaintController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Complaint",
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.report, color: Colors.blueGrey[400]),
                      filled: true,
                      fillColor: Colors.grey[850],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blueGrey[400]!),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a complaint.";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _sendComplaint();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.blueGrey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Send Complaint',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendComplaint() async {
    String complaintText = complaintController.text.trim();

    if (complaintText.isEmpty) {
      Fluttertoast.showToast(
        msg: "Complaint cannot be empty.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lid = prefs.getString('lid'); // Get user ID
    String? url = prefs.getString('url'); // Get base URL

    if (lid == null || url == null) {
      Fluttertoast.showToast(
        msg: 'User ID or URL not found.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(url + "/complaint_and_reply"),
        body: {
          'description': complaintText,
          'lid': lid,
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: 'Complaint Sent',
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          complaintController.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ViewRepliesPage()),
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Failed to send complaint.',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Error: Failed to send complaint.',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: 'Error: $e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}

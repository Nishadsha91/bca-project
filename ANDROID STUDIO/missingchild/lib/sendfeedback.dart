
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:missingchild/homes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(const com());
}

class com extends StatelessWidget {
  const com({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Send Feedback',
      theme: ThemeData(
        brightness: Brightness.dark, // Dark theme
        primaryColor: Colors.blue,
        // accentColor: Colors.amber,
        scaffoldBackgroundColor: Colors.black, // Set background color to black
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black87, // Darker AppBar color
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[850], // Dark background for input fields
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          labelStyle: TextStyle(color: Colors.white),
          prefixIconColor: Colors.white,
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
          headline6: TextStyle(color: Colors.white),
        ),
      ),
      home: const user_feed(title: 'Feedback'),
    );
  }
}

class user_feed extends StatefulWidget {
  const user_feed({super.key, required this.title});

  final String title;

  @override
  State<user_feed> createState() => _user_feedState();
}

class _user_feedState extends State<user_feed> {
  TextEditingController feedbackController = TextEditingController();
  double _rating = 0;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MissingHome()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text(
            'Feedback',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formkey,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'We value your feedback!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    maxLines: 4,
                    controller: feedbackController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Enter your feedback",
                      prefixIcon: const Icon(Icons.feedback),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your feedback.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Rate Us:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 40,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        sendFeedback();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Button color
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Send Feedback',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendFeedback() async {
    String feedback = feedbackController.text.trim();

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String hid = sh.getString('hid').toString();
    String lid = sh.getString('lid').toString();
    final urls = Uri.parse(url + "/feedback");

    try {
      final response = await http.post(urls, body: {
        'description': feedback,
        'rating': _rating.toString(),
        // 'hid': hid,
        'lid': lid,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Feedback send successfully!');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MissingHome()),
          );
        } else {
          Fluttertoast.showToast(msg: 'Failed to send feedback.');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network error. Please try again.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }
  }
}

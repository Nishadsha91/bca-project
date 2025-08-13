import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:missingchild/user_reg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'forgot_password.dart';
import 'homes.dart';
import 'ippage.dart';

void main() => runApp(MissingChildApp());

class MissingChildApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Missing Child ',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        hintColor: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => IpHomePage()));
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('MISSING CHILD ', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image10.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: LoginForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Object? get urlsl => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.0), // Adjusted opacity for less transparency
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Login to Missing Child",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 30.0),
            _buildTextField(_emailController, "Username / Email", Icons.email),
            SizedBox(height: 20.0),
            _buildTextField(_passwordController, "Password", Icons.lock, isPassword: true),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  sendData();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpForm())),
                  child: Text('Register', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword())),
                  child: Text('Forgot Password?', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );



  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2), // Transparent effect
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.tealAccent, width: 2.0),
        ),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.9)),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16),
      obscureText: isPassword,
      validator: (String? value) =>
      (value == null || value.isEmpty) ? "Please enter your $label." : null,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void sendData() async {
    String username = _emailController.text;
    String password = _passwordController.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    if (url.isEmpty) {
      Fluttertoast.showToast(msg: "Server URL not found in SharedPreferences");
      return;
    }

    final urls = Uri.parse("$url/android_login");
    print(urlsl);
    print('===================');

    try {
      final response = await http.post(urls, body: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'ok') {
          Fluttertoast.showToast(msg: 'Login Success');
          sh.setString("lid", responseData['lid'].toString());
          if (responseData['type'] == 'user') {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MissingHome()));
          }
        } else {
          Fluttertoast.showToast(msg: 'User Not Found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
  }
}

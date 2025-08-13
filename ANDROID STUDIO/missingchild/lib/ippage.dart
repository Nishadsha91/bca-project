//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'login.dart';
//
// void main() {
//   runApp(const MainApp());
// }
//
// class MainApp extends StatelessWidget {
//   const MainApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.teal,  // Teal for the primary color
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const IpHomePage(),
//     );
//   }
// }
//
// class IpHomePage extends StatefulWidget {
//   const IpHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<IpHomePage> createState() => _IpHomePageState();
// }
//
// class _IpHomePageState extends State<IpHomePage> {
//   final TextEditingController _controllerUsername = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('MISSING CHILD '),
//         backgroundColor: Colors.teal.shade700,  // Dark teal header for contrast
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.lightBlue.shade50, Colors.white],  // Light blue to white gradient background
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   const SizedBox(height: 80),
//                   const Text(
//                     "MISSING CHILD ",
//                     style: TextStyle(
//                       color: Colors.teal, // Dark teal for a calm and serious tone
//                       fontSize: 36,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "Please Enter the IP Address",
//                     style: TextStyle(
//                       color: Colors.teal,
//                       fontSize: 18,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   TextFormField(
//                     controller: _controllerUsername,
//                     decoration: InputDecoration(
//                       labelText: "Enter IP Address",
//                       labelStyle: TextStyle(color: Colors.teal.shade500),  // Soft teal for the label
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide(color: Colors.teal.shade300),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.9),  // White background for input field
//                       contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
//                     ),
//                     validator: (String? value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter IP Address.";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         sendData();
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14.0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       primary: Colors.red.shade600,  // Red for call to action
//                     ),
//                     child: const Text(
//                       "Connect",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controllerUsername.dispose();
//     super.dispose();
//   }
//
//   void sendData() async {
//     String ip = _controllerUsername.text.toString();
//
//     if (!ip.contains('.')) {
//       Fluttertoast.showToast(
//         msg: "Invalid IP Address",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//       return;
//     }
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     sh.setString('ip', ip);
//     sh.setString('url', 'http://$ip:8000');
//     sh.setString('imgurl', 'http://$ip:8000/');
//     sh.setString('imgurl2', 'http://$ip:8000');
//
//     Fluttertoast.showToast(
//       msg: "Connected Successfully",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.green,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
      ),
      home: const IpHomePage(),
    );
  }
}

class IpHomePage extends StatefulWidget {
  const IpHomePage({Key? key}) : super(key: key);

  @override
  State<IpHomePage> createState() => _IpHomePageState();
}

class _IpHomePageState extends State<IpHomePage> {
  final TextEditingController _controllerIp = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Missing Child App'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Connect to Server",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter the Server IP Address",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _controllerIp,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "IP Address",
                      prefixIcon: const Icon(Icons.network_check, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter IP Address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        sendData();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.blue.shade600,
                    ),
                    child: const Text(
                      "Connect",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerIp.dispose();
    super.dispose();
  }

  void sendData() async {
    String ip = _controllerIp.text.trim();
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setString('ip', ip);
    sh.setString('url', 'http://$ip:8000');
    sh.setString('imgurl', 'http://$ip:8000/');
    sh.setString('imgurl2', 'http://$ip:8000');

    Fluttertoast.showToast(
      msg: "Connected Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

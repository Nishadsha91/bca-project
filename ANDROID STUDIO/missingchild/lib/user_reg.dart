//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'login.dart';
//
// class SignUpForm extends StatefulWidget {
//   const SignUpForm({super.key});
//
//   @override
//   State<SignUpForm> createState() => _SignUpFormState();
// }
//
// class _SignUpFormState extends State<SignUpForm> {
//   final _formKey = GlobalKey<FormState>();
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController placeController = TextEditingController();
//   TextEditingController pinController = TextEditingController();
//   TextEditingController postController = TextEditingController();
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   bool _obscurePassword = true;
//
//   // Regular Expressions for Validation
//   final RegExp nameRegExp = RegExp(r'^[A-Za-z ]{2,25}$');
//   final RegExp placeRegExp = RegExp(r'^[A-Za-z0-9 ]{2,25}$');
//   final RegExp postRegExp = RegExp(r'^[A-Za-z0-9 ]{2,25}$');
//   final RegExp pinRegExp = RegExp(r'^[0-9]{6}$');
//   final RegExp emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,25}$');
//   final RegExp phoneRegExp = RegExp(r'^[6789]\d{9}$');
//   final RegExp usernameRegExp = RegExp(r'^\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,25}$');
//   final RegExp passwordRegExp = RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("User Registration")),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(30.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildTitle("Personal Information"),
//               const SizedBox(height: 20),
//
//               _buildTextField(
//                 controller: nameController,
//                 label: "Name",
//                 icon: Icons.person_outline,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Please enter your name';
//                   if (!nameRegExp.hasMatch(value)) return 'Enter a valid name (2-25 letters)';
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 20),
//               _buildTextField(
//                 controller: emailController,
//                 label: "Email",
//                 icon: Icons.email,
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Please enter your email';
//                   if (!emailRegExp.hasMatch(value)) return 'Enter a valid email';
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 20),
//               _buildTextField(
//                 controller: phoneController,
//                 label: "Phone",
//                 icon: Icons.phone,
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Please enter your phone number';
//                   if (!phoneRegExp.hasMatch(value)) return 'Enter a valid phone number (starts with 6-9, 10 digits)';
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 20),
//               _buildTextField(
//                 controller: placeController,
//                 label: "Place",
//                 icon: Icons.place,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Please enter your place';
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 20),
//               _buildTextField(
//                 controller: postController,
//                 label: "Post",
//                 icon: Icons.mail,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Please enter your post';
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 20),
//               _buildTextField(
//                 controller: pinController,
//                 label: "Pin",
//                 icon: Icons.pin_drop,
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Please enter your PIN code';
//                   if (!pinRegExp.hasMatch(value)) return 'Enter a valid 6-digit PIN';
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 20),
//               _buildTextField(
//                 controller: usernameController,
//                 label: "Username",
//                 icon: Icons.person_outline,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Please enter a username';
//                   if (!usernameRegExp.hasMatch(value)) return 'Username must be 3-25 letters';
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 20),
//               _buildTextField(
//                 controller: passwordController,
//                 label: "Password",
//                 icon: Icons.lock,
//                 obscureText: _obscurePassword,
//                 suffixIcon: IconButton(
//                   icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
//                   onPressed: () {
//                     setState(() {
//                       _obscurePassword = !_obscurePassword;
//                     });
//                   },
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Please enter a password';
//                   if (!passwordRegExp.hasMatch(value)) return 'Password must have 8+ chars, 1 number, 1 uppercase & lowercase';
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 40),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _registerUser,
//                   child: const Text("Sign Up"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool obscureText = false,
//     TextInputType keyboardType = TextInputType.text,
//     Widget? suffixIcon,
//     FormFieldValidator<String>? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       obscureText: obscureText,
//       decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), suffixIcon: suffixIcon),
//       validator: validator,
//     );
//   }
//
//   Future<void> _registerUser() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     final sh = await SharedPreferences.getInstance();
//     String? url = sh.getString("url");
//     if (url == null || url.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Server URL not found')));
//       return;
//     }
//     print(nameController.text);
//     final urls = Uri.parse(url + "/registrationcode");
//     try {
//       final response = await http.post(urls, body: {
//         'nme': nameController.text,
//         'email': emailController.text,
//         'phone': phoneController.text,
//         'place': placeController.text,
//         'pin': pinController.text,
//         'post': postController.text,
//         'username': usernameController.text,
//         'password': passwordController.text,
//       });
//
//       if (response.statusCode == 200) {
//         // String status = jsonDecode(response.body)['status'];
//         if (response.statusCode == 200) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully Registered')));
//           Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed')));
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  // Regular Expressions for Validation
  final RegExp nameRegExp = RegExp(r'^[A-Za-z ]{2,25}$');
  final RegExp placeRegExp = RegExp(r'^[A-Za-z0-9 ]{2,25}$');
  final RegExp postRegExp = RegExp(r'^[A-Za-z0-9 ]{2,25}$');
  final RegExp pinRegExp = RegExp(r'^[0-9]{6}$');
  final RegExp emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,25}$');
  final RegExp phoneRegExp = RegExp(r'^[6789]\d{9}$');
  final RegExp passwordRegExp = RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Registration")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle("Personal Information"),
              const SizedBox(height: 20),

              _buildTextField(
                controller: nameController,
                label: "Name",
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your name';
                  if (!nameRegExp.hasMatch(value)) return 'Enter a valid name (2-25 letters)';
                  return null;
                },
              ),

              const SizedBox(height: 20),
              _buildTextField(
                controller: emailController,
                label: "Email",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  if (!emailRegExp.hasMatch(value)) return 'Enter a valid email';
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    usernameController.text = value; // Auto-fill username field
                  });
                },
              ),

              const SizedBox(height: 20),
              _buildTextField(
                controller: phoneController,
                label: "Phone",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your phone number';
                  if (!phoneRegExp.hasMatch(value)) return 'Enter a valid phone number (starts with 6-9, 10 digits)';
                  return null;
                },
              ),

              const SizedBox(height: 20),
              _buildTextField(
                controller: placeController,
                label: "Place",
                icon: Icons.place,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your place';
                  return null;
                },
              ),

              const SizedBox(height: 20),
              _buildTextField(
                controller: postController,
                label: "Post",
                icon: Icons.mail,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your post';
                  return null;
                },
              ),

              const SizedBox(height: 20),
              _buildTextField(
                controller: pinController,
                label: "Pin",
                icon: Icons.pin_drop,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your PIN code';
                  if (!pinRegExp.hasMatch(value)) return 'Enter a valid 6-digit PIN';
                  return null;
                },
              ),

              const SizedBox(height: 20),
              _buildTextField(
                controller: usernameController,
                label: "Username (Auto-filled from Email)",
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Username is required';
                  if (!emailRegExp.hasMatch(value)) return 'Enter a valid email as username';
                  return null;
                },
                enabled: false, // Prevents manual input
              ),

              const SizedBox(height: 20),
              _buildTextField(
                controller: passwordController,
                label: "Password",
                icon: Icons.lock,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a password';
                  if (!passwordRegExp.hasMatch(value)) return 'Password must have 8+ chars, 1 number, 1 uppercase & lowercase';
                  return null;
                },
              ),

              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: _registerUser,
                  child: const Text("Sign Up"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    FormFieldValidator<String>? validator,
    bool enabled = true,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), suffixIcon: suffixIcon),
      validator: validator,
      onChanged: onChanged,
    );
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString("url");
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Server URL not found')));
      return;
    }

    final urls = Uri.parse(url + "/registrationcode");
    try {
      final response = await http.post(urls, body: {
        'nme': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'place': placeController.text,
        'pin': pinController.text,
        'post': postController.text,
        'username': usernameController.text,
        'password': passwordController.text,
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully Registered')));
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed')));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}

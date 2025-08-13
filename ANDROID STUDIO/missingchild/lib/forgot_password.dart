import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:seatallocation/studenthome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:http/http.dart' as http;

import 'Login.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: '',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home:  (title: 'Sent Complaint'),
    );
  }
}



class ForgetPassword extends StatefulWidget {


  ForgetPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgetPassword> createState() => _LoginState();
}

class _LoginState extends State<ForgetPassword> {

  TextEditingController emailController = TextEditingController();
  // TextEditingController newpasswordController = TextEditingController();
  // TextEditingController confirmpasswordController = TextEditingController();

  final _formkey=GlobalKey<FormState>();


  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context, MaterialPageRoute(builder: (context) =>LoginPage (),));

        return false;

      },





















      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0.0,
          leadingWidth: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                radius: 20.0,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  splashRadius: 1.0,
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.green,
                    size: 24.0,
                  ),
                ),
              ),
              Text(
                'Forget Password ',
              ),
              SizedBox(
                width: 40.0,
                child: IconButton(
                  onPressed: () {},
                  splashRadius: 1.0,
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 34.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Form(
          key: _formkey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [




                const SizedBox(height: 150),
                Text(
                  "",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  "",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),


                const SizedBox(height: 60),
                TextFormField(

                  controller:emailController ,

                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter email.";
                    }

                    return null;
                  },
                ),


                // const SizedBox(height: 10),
                // TextFormField(
                //   controller: newpasswordController,
                //
                //
                //
                //
                //   decoration: InputDecoration(
                //     labelText: "New Password",
                //     prefixIcon: const Icon(Icons.password),
                //
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                //   validator: (String? value) {
                //     if (value == null || value.length<8) {
                //       return "Please enter New Password minimum 8digits.";
                //     }
                //
                //     return null;
                //   },
                // ),
                //
                //
                // const SizedBox(height: 10),
                // TextFormField(
                //   controller: confirmpasswordController,
                //
                //
                //
                //   decoration: InputDecoration(
                //     labelText: "Confirm Password",
                //     prefixIcon: const Icon(Icons.password),
                //
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                //   validator: (String? value) {
                //     if (value == null || value.isEmpty) {
                //       return "Please enter Confirm.";
                //     }
                //
                //
                //     return null;
                //   },
                // ),
                const SizedBox(height: 10),

                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        if(_formkey.currentState!.validate()){
                          submit();

                        }
                      },
                      child: const Text("Change"),
                    ),



                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  // void dispose() {
  //   _focusNodePassword.dispose();
  //   _controllerUsername.dispose();
  //   _controllerPassword.dispose();
  //   super.dispose();
  // }


  void submit()async{

    String old=emailController.text.toString();
    // String newpass=newpasswordController.text.toString();
    // String confirm=confirmpasswordController.text.toString();

    SharedPreferences sh=await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    // String lid = sh.getString('lid').toString();
    final urls=Uri.parse(url+"/forget_password_post");
    try{
      final response=await http.post(urls,body:{
        'email':old,
        // 'new':newpass,
        // 'confirm':confirm,
        // 'lid':lid,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {
          Fluttertoast.showToast(msg: 'Please check your mail');


          Navigator.push(context, MaterialPageRoute(
            builder: (context) => LoginPage(),));
        }else {
          Fluttertoast.showToast(msg: 'Invalid');
        }
      }
      else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    }
    catch (e){
      Fluttertoast.showToast(msg: e.toString());
    }

  }



//   String? conf (String value){
//     if(value.length<8){
//       return 'Please enter a email';
//     }
//     return null;
//
//   }String? old (String value){
//     if(value.isEmpty){
//       return 'Please enter New Password';
//     }
//     return null;
//
//   }
//   String? new1 (String value){
//     if(value.length<10){
//       return 'Please Confirm Password';
//     }
//     return null;
//
//   }
}
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'homes.dart';
// import 'viewupdates.dart'; // Correct import path for your MissingHome widget.
//
// class viewmissingcase extends StatefulWidget {
//   const viewmissingcase({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<viewmissingcase> createState() => _viewmissingcaseState();
// }
//
// class _viewmissingcaseState extends State<viewmissingcase> {
//   List<int> id_ = [];
//   List<String> name_ = [];
//   List<String> age_ = [];
//   List<String> description_ = [];
//   List<String> missingdate_ = [];
//   List<String> uploaddate_ = [];
//   List<String> photo_ = [];
//
//   @override
//   void initState() {
//     super.initState();
//     viewmissingcase();
//   }
//
//   void viewmissingcase() async {
//     List<int> id = <int>[];
//     List<String> name = <String>[];
//     List<String> age = <String>[];
//     List<String> description = <String>[];
//     List<String> missingdate = <String>[];
//     List<String> uploaddate = <String>[];
//     List<String> photo = <String>[];
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       String url = '$urls/user_view_missingcase';
//
//       var data = await http.post(Uri.parse(url), body: {
//         "lid": lid
//       });
//       var jsondata = json.decode(data.body);
//       String statuss = jsondata['status'];
//       var arr = jsondata["data"];
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id']);
//         name.add(arr[i]['childname']);
//         age.add(arr[i]['age']);
//         description.add(arr[i]['description'].toString());
//         missingdate.add(arr[i]['missingdate'].toString());
//         uploaddate.add(arr[i]['uploaddate'].toString());
//         photo.add(sh.getString('imgurl').toString() + arr[i]['childimage']);
//       }
//
//       setState(() {
//         id_ = id;
//         name_ = name;
//         age_ = age;
//         description_ = description;
//         missingdate_ = missingdate;
//         uploaddate_ = uploaddate;
//         photo_ = photo;
//       });
//
//       print(statuss);
//     } catch (e) {
//       print("Error ------------------- " + e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.blue.shade50, // Light blue background
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.teal, // Dark teal app bar
//           elevation: 0.0,
//           leadingWidth: 0.0,
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CircleAvatar(
//                 backgroundColor: Colors.grey.shade300,
//                 radius: 20.0,
//                 child: IconButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => MissingHome(),
//                       ),
//                     );
//                   },
//                   splashRadius: 1.0,
//                   icon: Icon(
//                     Icons.arrow_back_ios_new,
//                     color: Colors.green,
//                     size: 24.0,
//                   ),
//                 ),
//               ),
//               Text(
//                 'Missing Child',
//                 style: TextStyle(color: Colors.white), // White text
//               ),
//               SizedBox(
//                 width: 40.0,
//                 child: IconButton(
//                   onPressed: () {},
//                   splashRadius: 1.0,
//                   icon: Icon(
//                     Icons.more_vert,
//                     color: Colors.white,
//                     size: 34.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: ListView.builder(
//           physics: BouncingScrollPhysics(),
//           itemCount: id_.length,
//           itemBuilder: (BuildContext context, int index) {
//             return ListTile(
//               title: Padding(
//                 padding: const EdgeInsets.all(0),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 400,
//                       child: Card(
//                         elevation: 6,
//                         margin: EdgeInsets.all(10),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         color: Colors.white, // White card background for contrast
//                         child: Container(
//                           padding: EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Image.network(
//                                 photo_[index],
//                                 width: 700,
//                                 height: 350,
//                                 fit: BoxFit.cover,
//                               ),
//                               SizedBox(height: 8),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Name: ",
//                                     style: TextStyle(fontSize: 16, color: Colors.black), // Dark text for readability
//                                   ),
//                                   Text(
//                                     '${name_[index]}',
//                                     style: TextStyle(fontSize: 16, color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 8),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Age: ",
//                                     style: TextStyle(fontSize: 16, color: Colors.black),
//                                   ),
//                                   Text(
//                                     '${age_[index]}',
//                                     style: TextStyle(fontSize: 16, color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 8),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Description: ",
//                                     style: TextStyle(fontSize: 16, color: Colors.black),
//                                   ),
//                                   Flexible(
//                                     child: Text(
//                                       '${description_[index]}',
//                                       style: TextStyle(fontSize: 16, color: Colors.black),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 8),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Missing Date: ",
//                                     style: TextStyle(fontSize: 16, color: Colors.black),
//                                   ),
//                                   Text(
//                                     '${missingdate_[index]}',
//                                     style: TextStyle(fontSize: 16, color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 8),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Upload Date: ",
//                                     style: TextStyle(fontSize: 16, color: Colors.black),
//                                   ),
//                                   Text(
//                                     '${uploaddate_[index]}',
//                                     style: TextStyle(fontSize: 16, color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 16),
//                               Center(
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     // Implement logic to view updates for the selected case
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => UpdatesScreen(
//                                           caseId: id_[index],
//                                           childName: name_[index],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   child: Text("View Updates"),
//                                   style: ElevatedButton.styleFrom(
//                                     primary: Colors.green, // Green for updates button
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'homes.dart';
import 'viewupdates.dart'; // Correct import path for your MissingHome widget.

class ViewMissingCase extends StatefulWidget {
  const ViewMissingCase({super.key, required this.title});

  final String title;

  @override
  State<ViewMissingCase> createState() => _ViewMissingCaseState();
}

class _ViewMissingCaseState extends State<ViewMissingCase> {
  List<int> id_ = [];
  List<String> name_ = [];
  List<String> age_ = [];
  List<String> description_ = [];
  List<String> missingdate_ = [];
  List<String> uploaddate_ = [];
  List<String> photo_ = [];

  @override
  void initState() {
    super.initState();
    viewMissingCase();
  }

  void viewMissingCase() async {
    List<int> id = <int>[];
    List<String> name = <String>[];
    List<String> age = <String>[];
    List<String> description = <String>[];
    List<String> missingdate = <String>[];
    List<String> uploaddate = <String>[];
    List<String> photo = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/user_view_missingcase';

      var data = await http.post(Uri.parse(url), body: {"lid": lid});
      var jsondata = json.decode(data.body);
      String status = jsondata['status'];
      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id']);
        name.add(arr[i]['childname']);
        age.add(arr[i]['age']);
        description.add(arr[i]['description'].toString());
        missingdate.add(arr[i]['missingdate'].toString());
        uploaddate.add(arr[i]['uploaddate'].toString());
        photo.add(sh.getString('imgurl').toString() + arr[i]['childimage']);
      }

      setState(() {
        id_ = id;
        name_ = name;
        age_ = age;
        description_ = description;
        missingdate_ = missingdate;
        uploaddate_ = uploaddate;
        photo_ = photo;
      });

      print(status);
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.blue.shade50, // Light blue background
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.teal, // Dark teal app bar
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MissingHome(),
                      ),
                    );
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
                'Missing Child',
                style: TextStyle(color: Colors.white), // White text
              ),
              SizedBox(
                width: 40.0,
                // child: IconButton(
                //   onPressed: () {},
                //   splashRadius: 1.0,
                //   icon: Icon(
                //     Icons.more_vert,
                //     color: Colors.white,
                //     size: 34.0,
                //   ),
                // ),
              ),
            ],
          ),
        ),
        body: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: id_.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width, // Full width of screen
                      child: Card(
                        elevation: 6,
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white, // White card background for contrast
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Full-width image with responsive height
                              Image.network(
                                photo_[index],
                                width: double.infinity, // Responsive width
                                height: 300, // Set height to a fixed value or adjust dynamically
                                fit: BoxFit.cover, // Ensures the image covers the space without distortion
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Name: ",
                                    style: TextStyle(fontSize: 16, color: Colors.black), // Dark text for readability
                                  ),
                                  Text(
                                    '${name_[index]}',
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Age: ",
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                  Text(
                                    '${age_[index]}',
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Description: ",
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                  Flexible(
                                    child: Text(
                                      '${description_[index]}',
                                      style: TextStyle(fontSize: 16, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Missing Date: ",
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                  Text(
                                    '${missingdate_[index]}',
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Upload Date: ",
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                  Text(
                                    '${uploaddate_[index]}',
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdatesScreen(
                                          caseId: id_[index],
                                          childName: name_[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text("View Updates"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green, // Green for updates button
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

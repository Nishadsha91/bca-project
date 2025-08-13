
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:missingchild/sendfeedback.dart';
import 'package:missingchild/view%20notification.dart';
import 'package:missingchild/viewchildhelpline.dart';
import 'package:missingchild/viewcomplaint.dart';
import 'package:missingchild/viewemergencycomplaint.dart';
import 'package:missingchild/viewmissingchild.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'managemissingcase.dart';

void main() {
  runApp(MaterialApp(
    home: MissingHome(),
    debugShowCheckedModeBanner: false,
  ));
}

class MissingHome extends StatefulWidget {
  @override
  _MissingHomeState createState() => _MissingHomeState();
}

class _MissingHomeState extends State<MissingHome> {
  List<int> id_ = [];
  List<String> name_ = [];
  List<String> age_ = [];
  List<String> description_ = [];
  List<String> missingdate_ = [];
  List<String> uploaddate_ = [];
  List<String> photo_ = [];

  final List<String> imagePaths = [
    'assets/child1.jpg',
    'assets/child2.jpg',
    'assets/child3.jpg',
    'assets/child4.jpg',
    'assets/child5.jpg',
  ];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    viewmissingcases();
  }

  void viewmissingcases() async {
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
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to corresponding page on tap
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => managemissingcase(title: '')));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Viewchildhelpline(title: '')));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => user_feed(title: '')));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewNotification(title: '')));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldLeave = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
        return shouldLeave ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0,
          title: Text('MissingHome', style: TextStyle(color: Colors.white)),
          actions: [
            // IconButton(
            //   icon: Icon(Icons.logout),
            //   onPressed: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            //   },
            //
            // ),



            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // Show a confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Are you sure?'),
                      content: Text('Do you really want to log out?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();  // Close the dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();  // Close the dialog
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to LoginPage
                            );
                          },
                          child: Text('Yes, log out'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

          ], ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.teal),
                child: Text('Welcome', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: Icon(Icons.home_outlined),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.find_in_page_rounded),
                title: Text('Missing Case'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewMissingCase(title: '')));
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications_active),
                title: Text('Notification'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewNotification(title: '')));
                },
              ),
              ListTile(
                leading: Icon(Icons.local_police_outlined),
                title: Text('Child Helpline'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Viewchildhelpline(title: '')));
                },
              ),
              ListTile(
                leading: Icon(Icons.note_alt_rounded),
                title: Text('Send Feedback'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => user_feed(title: '')));
                },
              ),
              ListTile(
                leading: Icon(Icons.report_gmailerrorred),
                title: Text('Complaints'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewRepliesPage()));
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.logout),
              //   title: Text('Logout'),
              //   onTap: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              //   },
              // ),

              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text('Do you really want to log out?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to LoginPage
                              );
                            },
                            child: Text('Yes, log out'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/3.jpg'), fit: BoxFit.cover),
          ),
          child: ListView(
            children: [
              CarouselSlider(
                items: imagePaths.map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: id_.length,
                  itemBuilder: (context, index) {
                    var book = {
                      "childname": name_[index],
                      "age": age_[index],
                      "Description": description_[index],
                      "Missing Date": missingdate_[index],
                      "Upload Date": uploaddate_[index],
                      "photo": photo_[index],
                      "id": id_[index]
                    };
                    return Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailPage(book: book),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                photo_[index],
                                height: 200,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                name_[index],
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
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
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(color: Colors.grey),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Case',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_police_outlined),
              label: 'Child Helpline',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note_alt_rounded),
              label: 'Feedback',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active),
              label: 'Notification',
            ),
          ],
        ),
      ),
    );
  }
}

class BookDetailPage extends StatelessWidget {
  final Map book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['childname'] ?? ''),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              book['photo'],
              height: 300.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text('Name: ${book['childname'] ?? 'Unknown'}'),
            const SizedBox(height: 8),
            Text('Age: ${book['age'] ?? 'Unknown'}'),
            const SizedBox(height: 8),
            Text('Description: ${book['Description'] ?? 'No description'}'),
            const SizedBox(height: 8),
            Text('Missing Date: ${book['Missing Date'] ?? 'Unknown'}'),
            const SizedBox(height: 8),
            Text('Upload Date: ${book['Upload Date'] ?? 'Unknown'}'),
          ],
        ),
      ),
    );
  }
}

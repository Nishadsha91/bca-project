import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'homes.dart';
import 'viewupdates.dart';
import 'package:missingchild/add_missing_case.dart';
import 'package:missingchild/edit_missing.dart';

class managemissingcase extends StatefulWidget {
  const managemissingcase({super.key, required this.title});

  final String title;

  @override
  State<managemissingcase> createState() => _managemissingcaseState();
}

class _managemissingcaseState extends State<managemissingcase> {
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
    managemissingcase();
  }

  void managemissingcase() async {
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
      String url = '$urls/user_view_my_missingcase';

      var data = await http.post(Uri.parse(url), body: {
        "lid": lid,
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];
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

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  void addMissingCase() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMissingCaseScreen(), // Replace with the Add Case screen
      ),
    );
  }

  void editMissingCase(int index) {
    print("Edit Case Button Pressed for ID: ${id_[index].toString()}");

    // Prepare the case details to pass
    final caseDetails = {
      'id': id_[index].toString(),
      'childname': name_[index].toString(),
      'age': age_[index].toString(),
      'description': description_[index].toString(),
      'missingdate': missingdate_[index].toString(),
      'childimage': photo_[index].toString()
    };

    // Navigate to the EditMissing screen and pass the case details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMissing(caseDetails: caseDetails),
      ),
    );
  }


  void deleteMissingCase(int index) async {
    print("Delete Case Button Pressed for ID: ${id_[index]}");
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String url = '$urls/delete_missing_case';

      var response = await http.post(Uri.parse(url), body: {"id": id_[index].toString()});
      print("Response: ${response.body}");
      var jsondata = json.decode(response.body);

      if (jsondata['status'] == 'success') {
        setState(() {
          id_.removeAt(index);
          name_.removeAt(index);
          age_.removeAt(index);
          description_.removeAt(index);
          missingdate_.removeAt(index);
          uploaddate_.removeAt(index);
          photo_.removeAt(index);
        });
        print("Case deleted successfully");
      } else {
        print("Failed to delete case: ${jsondata['message']}");
      }
    } catch (e) {
      print("Error while deleting case: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.blue.shade50, // Soft light blue background
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.teal, // Dark teal for the app bar
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
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddMissingCaseScreen(), // Replace with the screen for adding a new case
                    ),
                  );
                },
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.white,
                  size: 32.0,
                ),
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
                      width: 400,
                      child: Card(
                        elevation: 6,
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white, // White card background
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                photo_[index],
                                width: 500,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 8),
                              Text("Name: ${name_[index]}", style: TextStyle(color: Colors.black)),
                              Text("Age: ${age_[index]}", style: TextStyle(color: Colors.black)),
                              Text("Description: ${description_[index]}", style: TextStyle(color: Colors.black)),
                              Text("Missing Date: ${missingdate_[index]}", style: TextStyle(color: Colors.black)),
                              Text("Upload Date: ${uploaddate_[index]}", style: TextStyle(color: Colors.black)),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => editMissingCase(index),
                                    style: ElevatedButton.styleFrom(primary: Colors.lightBlue), // Light blue for edit button
                                    child: Text("Edit"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => deleteMissingCase(index),
                                    style: ElevatedButton.styleFrom(primary: Colors.red), // Red for delete button
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
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
                                  style: ElevatedButton.styleFrom(primary: Colors.green), // Green for view updates button
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

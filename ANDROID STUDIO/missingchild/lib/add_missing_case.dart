
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMissingCaseScreen extends StatefulWidget {
  @override
  _AddMissingCaseScreenState createState() => _AddMissingCaseScreenState();
}

class _AddMissingCaseScreenState extends State<AddMissingCaseScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController childNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController missingDateController = TextEditingController();
  // TextEditingController uploadDateController = TextEditingController();
  File? _image;

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      controller.text = "${selectedDate.toLocal()}".split(' ')[0];  // Format date as YYYY-MM-DD
    }
  }

  // Function to submit the missing case
  Future<void> _submitMissingCase() async {
    if (_formKey.currentState!.validate() && _image != null) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? url = prefs.getString('url'); // Base URL saved in SharedPreferences
        String? lid = prefs.getString('lid'); // Logged-in user ID saved in SharedPreferences

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('$url/add_missing_case'), // Endpoint for adding a missing case
        );
        request.fields['id'] = lid!;
        request.fields['childname'] = childNameController.text;
        request.fields['age'] = ageController.text;
        request.fields['description'] = descriptionController.text;
        request.fields['missingdate'] = missingDateController.text;
        // request.fields['uploaddate'] = uploadDateController.text;
        request.files.add(
          await http.MultipartFile.fromPath(
            'childname', // Field name for the image
            _image!.path,
          ),
        );

        var response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var jsonResponse = json.decode(responseData);

          if (jsonResponse['status'] == 'ok') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Missing case added successfully!")),
            );
            Navigator.pop(context); // Go back to the previous screen
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to add missing case.")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${response.statusCode}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields and upload an image.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Missing Case'),
        backgroundColor: Colors.teal.shade800,  // Dark teal header
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade50, Colors.white],  // Light blue to white gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: childNameController,
                  decoration: InputDecoration(
                    labelText: "Child Name",
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the child's name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(
                    labelText: "Age",
                    prefixIcon: Icon(Icons.cake),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the child's age";
                    }
                    if (int.tryParse(value) == null) {
                      return "Age must be a valid number";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a description";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: missingDateController,
                  decoration: InputDecoration(
                    labelText: "Missing Date",
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the missing date";
                    }
                    return null;
                  },
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    await _selectDate(context, missingDateController);
                  },
                ),

                // SizedBox(height: 16.0),
                // TextFormField(
                //   controller: uploadDateController,
                //   decoration: InputDecoration(
                //     labelText: "Upload Date",
                //     prefixIcon: Icon(Icons.calendar_today),
                //   ),
                //   keyboardType: TextInputType.datetime,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Please enter the upload date";
                //     }
                //     return null;
                //   },
                //   onTap: () async {
                //     FocusScope.of(context).requestFocus(FocusNode());
                //     await _selectDate(context, uploadDateController);
                //   },
                // ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _image == null
                        ? Center(child: Text("Tap to select an image"))
                        : Image.file(_image!, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitMissingCase,
                  child: Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red.shade600,  // Red for the primary call-to-action button
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

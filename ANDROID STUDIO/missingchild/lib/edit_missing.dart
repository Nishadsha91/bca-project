
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditMissing extends StatefulWidget {
  final Map<String, dynamic> caseDetails; // Pass existing case details as an argument

  const EditMissing({Key? key, required this.caseDetails}) : super(key: key);

  @override
  State<EditMissing> createState() => _EditMissingState();
}

class _EditMissingState extends State<EditMissing> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController childNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController missingDateController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    // Populate initial values from case details
    childNameController.text = widget.caseDetails['childname'] ?? '';
    ageController.text = widget.caseDetails['age'] ?? '';
    descriptionController.text = widget.caseDetails['description'] ?? '';
    missingDateController.text = widget.caseDetails['missingdate'] ?? '';
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to update the missing case
  Future<void> _updateMissingCase() async {
    if (_formKey.currentState!.validate()) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? url = prefs.getString('url'); // Base URL saved in SharedPreferences
        String? lid = prefs.getString('lid'); // Logged-in user ID saved in SharedPreferences
        String caseId = widget.caseDetails['id'];

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('$url/edit_missing_case'), // Endpoint for editing a missing case
        );
        request.fields['case_id'] = caseId;
        request.fields['childname'] = childNameController.text;
        request.fields['age'] = ageController.text;
        request.fields['description'] = descriptionController.text;
        request.fields['missingdate'] = missingDateController.text;

        // Add image file if selected
        if (_image != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'image', // Field name for the image in the backend
              _image!.path,
            ),
          );
        }

        var response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var jsonResponse = json.decode(responseData);

          if (jsonResponse['status'] == 'ok') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Missing case updated successfully!"), backgroundColor: Colors.green),
            );
            Navigator.pop(context); // Go back to the previous screen
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to update missing case.")),
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
        SnackBar(content: Text("Please fill all fields.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Missing Case'),
        backgroundColor: Colors.teal,  // Dark teal for the header
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
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
                  filled: true,
                  fillColor: Colors.white,
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
                  filled: true,
                  fillColor: Colors.white,
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
                  filled: true,
                  fillColor: Colors.white,
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
                  labelText: "Missing Date (YYYY-MM-DD)",
                  prefixIcon: Icon(Icons.calendar_today),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the missing date";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _image == null
                      ? widget.caseDetails['childimage'] != null
                      ? Image.network(
                    widget.caseDetails['childimage'],
                    fit: BoxFit.cover,
                  )
                      : Center(child: Text("Tap to select an image"))
                      : Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateMissingCase,
                child: Text("Update"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,  // Red color for the update button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

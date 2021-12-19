import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_3_5/controller/people_controller.dart';
import 'package:flutter_firebase_3_5/models/people_model.dart';
import 'package:flutter_firebase_3_5/pages/show_people.dart';
import 'package:image_picker/image_picker.dart';

class CreatePeoplePage extends StatefulWidget {
  const CreatePeoplePage({Key key}) : super(key: key);

  @override
  _CreatePeoplePageState createState() => _CreatePeoplePageState();
}

class _CreatePeoplePageState extends State<CreatePeoplePage> {
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  // ---------- Image ----------
  File _image;
  final _picker = ImagePicker();
  _fromGallery() async {
    final PickedFile pickedFile =
        // ignore: deprecated_member_use
        await _picker.getImage(source: ImageSource.gallery);
    setState(() => _image = File(pickedFile.path));
  }

  _fromCamera() async {
    final PickedFile pickedFile =
        // ignore: deprecated_member_use
        await _picker.getImage(source: ImageSource.camera);
    setState(() => _image = File(pickedFile.path));
  }

  _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _fromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _fromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  get _buildPickerImage {
    return Center(
      child: GestureDetector(
        onTap: () {
          _showPicker(context);
        },
        child: CircleAvatar(
          radius: 55,
          backgroundColor: Colors.red,
          child: _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    _image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create People'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPickerImage,
              const SizedBox(height: 18.0),
              TextField(
                controller: _nameController,
                style: const TextStyle(fontSize: 18.0),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: 'Enter Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 18.0),
              TextField(
                controller: _genderController,
                style: const TextStyle(fontSize: 18.0),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: 'Enter Gender',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 18.0),
              TextField(
                controller: _addressController,
                style: const TextStyle(fontSize: 18.0),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_on),
                  hintText: 'Enter Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 18.0),
              TextField(
                controller: _phoneController,
                style: const TextStyle(fontSize: 18.0),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.call),
                  hintText: 'Enter Phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 18.0),
              SizedBox(
                height: 60.0,
                width: double.infinity,
                child: CupertinoButton(
                  color: Colors.blue,
                  child: const Text('SUBMIT'),
                  onPressed: () async {
                    await Future.delayed(const Duration(seconds: 2));
                    _buildLoading();
                    String _photoUrl =
                        await PeopleController().uploadPhoto(_image);
                    PeopleModel _peopleModel = PeopleModel(
                      name: _nameController.text,
                      gender: _genderController.text,
                      address: _addressController.text,
                      phone: _phoneController.text,
                      photo: _photoUrl,
                    );
                    await PeopleController().insertPeople(_peopleModel);
                    // ignore: avoid_print
                    print('People Inserted');
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buildLoading() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 70.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                CircularProgressIndicator(),
                Text('Loading...'),
              ],
            ),
          ),
        );
      },
    );
  }
}

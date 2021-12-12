import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatePeoplePage extends StatefulWidget {
  const CreatePeoplePage({Key? key}) : super(key: key);

  @override
  _CreatePeoplePageState createState() => _CreatePeoplePageState();
}

class _CreatePeoplePageState extends State<CreatePeoplePage> {
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

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
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

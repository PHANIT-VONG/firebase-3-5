import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_3_5/models/user_model.dart';
import 'package:flutter_firebase_3_5/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User _user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserModel _userModel = UserModel();
  bool _status = false;

  Future<void> _getCurrentUser() async {
    await FirebaseFirestore.instance
        .collection('tbUser')
        .doc(_user.uid)
        .get()
        .then((value) {
      _userModel = UserModel.fromMap(value.data);
      setState(() {});
    });
    _status = true;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home Page'),
      ),
      body: _status
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_userModel.email}',
                    style: const TextStyle(fontSize: 30.0),
                  ),
                  Text(
                    '${_userModel.firstName} ${_userModel.lastName}',
                    style: const TextStyle(fontSize: 30.0),
                  ),
                  const SizedBox(height: 20.0),
                  CupertinoButton(
                    color: Colors.red,
                    child: const Text('LOG OUT'),
                    onPressed: () {
                      _firebaseAuth.signOut();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                  )
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

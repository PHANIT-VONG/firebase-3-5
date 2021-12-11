import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_3_5/models/user_model.dart';
import 'package:flutter_firebase_3_5/pages/home_page.dart';
import 'package:flutter_firebase_3_5/pages/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String _errorMessage = '';

  Future<void> _register() async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: _email.text, password: _password.text)
          .then((value) {
        _postUserToFirestore();
      }).catchError((e) {
        Fluttertoast.showToast(
          msg: e!.message,
          backgroundColor: Colors.red,
        );
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          _errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          _errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          _errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          _errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          _errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          _errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          _errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(
        msg: _errorMessage,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _postUserToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
    userModel.userId = user!.uid;
    userModel.email = user.email;
    userModel.firstName = _firstName.text;
    userModel.lastName = _lastName.text;

    await firebaseFirestore
        .collection('tbUser')
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(
      msg: "Account created successfully :) ",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );

    Navigator.pushAndRemoveUntil(
      (context),
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => true,
    );
  }

  bool _hiden = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 160.0,
                    width: 160.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 5.0),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/person.png'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  TextField(
                    controller: _firstName,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.person),
                      hintText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _lastName,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.person),
                      hintText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _email,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.email),
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _password,
                    obscureText: _hiden,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (_hiden) {
                            setState(() => _hiden = false);
                          } else {
                            setState(() => _hiden = true);
                          }
                        },
                        icon: Icon(
                          _hiden ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 60.0,
                    width: double.infinity,
                    child: CupertinoButton(
                      color: Colors.blue,
                      child: const Text('REGISTER'),
                      onPressed: () {
                        _register();
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already Register'),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text('Login'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

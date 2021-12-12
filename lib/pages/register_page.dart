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

  _buildShowTost(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _register(String email, String password) async {
    String message = '';
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        _postUserToFirestore();
      }).catchError((e) {
        message = e.message;
      });
    } catch (e) {
      message = e.toString();
    }
    _buildShowTost(message);
  }

  Future<void> _buildLoading() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 60.0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(width: 25.0),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _postUserToFirestore() async {
    FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel(
      userId: user!.uid,
      email: user.email,
      firstName: _firstName.text,
      lastName: _lastName.text,
    );

    await _firebaseFirestore
        .collection('tbUser')
        .doc(user.uid)
        .set(userModel.toMap());

    _buildLoading();
    await Future.delayed(const Duration(seconds: 2));

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
      (context),
      MaterialPageRoute(builder: (context) => const LoginPage()),
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
                        _register(_email.text, _password.text);
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

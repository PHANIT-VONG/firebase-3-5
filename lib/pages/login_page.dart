import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_3_5/pages/register_page.dart';
import 'package:flutter_firebase_3_5/pages/show_people.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _email = TextEditingController();
  final _password = TextEditingController();
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

  Future<void> _userLogin(String email, String password) async {
    String errorMessage = '';
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) async => {
                _buildLoading(),
                await Future.delayed(const Duration(seconds: 2)),
                Navigator.pushAndRemoveUntil(
                  (context),
                  MaterialPageRoute(
                      builder: (context) => const ShowPeoplPage()),
                  (route) => false,
                ),
              });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage);
    }
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
                      child: const Text('LOGIN'),
                      onPressed: () {
                        _userLogin(_email.text, _password.text);
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t has an account'),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text('Register'),
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

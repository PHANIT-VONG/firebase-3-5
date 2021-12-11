import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_3_5/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  const TextField(
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.person),
                      hintText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
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
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t has an account'),
                      TextButton(
                        onPressed: () {
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

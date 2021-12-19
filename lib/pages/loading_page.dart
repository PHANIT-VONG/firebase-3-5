import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_3_5/pages/show_people.dart';
import 'login_page.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({Key key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildError();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          // StreamBuilder can check the login state live
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasError) {
                return _buildError();
              }
              if (streamSnapshot.connectionState == ConnectionState.active) {
                // Get the user
                User _user = streamSnapshot.data as User;
                // If the user is null, we're not logged in
                if (_user == null) {
                  // user not logged in, head to login
                  return const LoginPage();
                } else {
                  // The user is logged in, head to homepage
                  return const ShowPeoplPage();
                }
              }
              // Checking the auth state - Loading
              return _buildLoading();
            },
          );
        }
        return _buildLoading();
      },
    );
  }

  Widget _buildError() {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Something went wrong'),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

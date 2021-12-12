import 'package:flutter/material.dart';
import 'package:flutter_firebase_3_5/pages/create_peopl.dart';

class ShowPeoplPage extends StatelessWidget {
  const ShowPeoplPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
      ),
      body: const Center(
        child: Text('data'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePeoplePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

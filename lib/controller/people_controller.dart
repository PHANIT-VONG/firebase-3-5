import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_3_5/models/people_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PeopleController {
  List<PeopleModel> getPeople(List<QueryDocumentSnapshot> docs) {
    return docs.map((e) => PeopleModel.fromSnapshot(e)).toList();
  }

  insertPeople(PeopleModel peopleModel) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      CollectionReference colRef =
          FirebaseFirestore.instance.collection('tbPeople');
      await colRef.add(peopleModel.toMap);
      // ignore: avoid_print
    }).then((value) => print('People Added'));
  }

  updatePeople(DocumentReference reference, PeopleModel peopleModel) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(reference, peopleModel.toMap);
      // ignore: avoid_print
    }).then((value) => print('People Update'));
  }

  deletePeople(DocumentReference reference) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.delete(reference);
      // ignore: avoid_print
    }).then((value) => print('People Delete'));
  }

  uploadPhoto(File image) async {
    if (image == null) {
      return;
    } else {
      await firebase_storage.FirebaseStorage.instance
          .ref('upload/${image.path.split("/").last}')
          .putFile(image);
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('upload/${image.path.split("/").last}')
          .getDownloadURL();
      // ignore: avoid_print
      print("URL : $downloadURL");
      return downloadURL;
    }
  }
}

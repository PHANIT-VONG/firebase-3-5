import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_3_5/controller/people_controller.dart';
import 'package:flutter_firebase_3_5/models/people_model.dart';
import 'package:flutter_firebase_3_5/pages/create_peopl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ShowPeoplPage extends StatelessWidget {
  const ShowPeoplPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('People')),
      body: _buildBody(context),
      floatingActionButton: _buildFloatting(context),
    );
  }

  FloatingActionButton _buildFloatting(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreatePeoplePage()),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tbPeople').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return _buildError('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading;
        }
        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) async {
                      await PeopleController().deletePeople(document.reference);
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) async {
                      await PeopleController().deletePeople(document.reference);
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: data['photo'] != null
                      ? NetworkImage(data['photo'])
                      : const AssetImage('assets/images/person.png'),
                ),
                title: Text(
                  data['name'],
                  style: const TextStyle(fontSize: 20.0),
                ),
                subtitle: Text(data['address']),
                trailing: Text(data['gender']),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildItem(PeopleModel people) {
    // return Slidable(
    //   startActionPane: SlidableDrawerActionPane(),
    //   actions: [
    //     IconSlideAction(
    //       icon: Icons.bookmark_border,
    //       caption: "PIN",
    //       color: Colors.blue,
    //     ),
    //   ],
    //   secondaryActions: [
    //     IconSlideAction(
    //       icon: Icons.delete,
    //       caption: "Delete",
    //       color: Colors.red,
    //       onTap: () => deleteItem(item.reference),
    //     ),
    //   ],
    //   child: Card(
    //     child: ListTile(
    //       title: Text(item.title),
    //       subtitle: Text(item.body),
    //       trailing: IconButton(
    //         icon: Icon(Icons.update),
    //         onPressed: () {
    //           item.title += " new ";
    //           updateItem(item.reference, item);
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }

  get _buildLoading {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
          Text(
            message,
            style: const TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}

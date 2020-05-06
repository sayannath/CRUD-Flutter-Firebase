import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:project_add/constants.dart';
import 'package:project_add/services/crud.dart';

import 'package:project_add/model/project.dart';
import 'package:project_add/addProject.dart';

class ListViewProject extends StatefulWidget {
  @override
  _ListViewProjectState createState() => new _ListViewProjectState();
}

class _ListViewProjectState extends State<ListViewProject> {
  List<Project> items;
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  StreamSubscription<QuerySnapshot> projectSub;

  @override
  void initState() {
    super.initState();

    items = new List();

    projectSub?.cancel();
    projectSub = db.getProjectList().listen((QuerySnapshot snapshot) {
      final List<Project> notes = snapshot.documents
          .map((documentSnapshot) => Project.fromMap(documentSnapshot.data))
          .toList();

      setState(() {
        this.items = notes;
      });
    });
  }

  @override
  void dispose() {
    projectSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Project'),
          centerTitle: true,
          backgroundColor: Color(0xFF183E8D),
        ),
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Ongoing",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF212121),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.grey[900],
                  ),
                  iconSize: 27,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
            height: 150,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, position) {
                return GestureDetector(
                  onTap: () => _navigateToProject(context, items[position]),
                  onLongPress: () =>
                      _deleteProject(context, items[position], position),
                  child: Card(
                    margin: EdgeInsets.only(right: 5, left: 10),
                    color: Color(0xFF183E8D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Container(
                      width: 200,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('${items[position].projectName}',
                                style: kTitleStyle.copyWith(
                                  color: Colors.white,
                                )),
                            Text(
                              "${items[position].number} members",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                            // IconButton(
                            //     icon: const Icon(Icons.remove_circle_outline),
                            //     onPressed: () => _deleteProject(
                            //         context, items[position], position)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _createNewProject(context),
        ),
      ),
    );
  }

  void _deleteProject(BuildContext context, Project note, int position) async {
    db.deleteProject(note.id).then((notes) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToProject(BuildContext context, Project note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProjectScreen(note)),
    );
  }

  void _createNewProject(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProjectScreen(Project(null, '', ''))),
    );
  }
}

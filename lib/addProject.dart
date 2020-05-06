import 'package:flutter/material.dart';
import 'package:project_add/model/project.dart';
import 'package:project_add/services/crud.dart';

class ProjectScreen extends StatefulWidget {
  final Project project;
  ProjectScreen(this.project);

  @override
  State<StatefulWidget> createState() => new _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  TextEditingController _pnController;
  TextEditingController _nuController;

  @override
  void initState() {
    super.initState();

    _pnController = new TextEditingController(text: widget.project.projectName);
    _nuController = new TextEditingController(text: widget.project.number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Add'),
        backgroundColor: Color(0xFF183E8D),
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                controller: _pnController,
                decoration: InputDecoration(
                    labelText: 'Project Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                controller: _nuController,
                decoration: InputDecoration(
                    labelText: 'Number of Members',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            Container(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                  onPressed: () {
                    if (widget.project.id != null) {
                      db
                          .updateProject(Project(widget.project.id,
                              _pnController.text, _nuController.text))
                          .then((_) {
                        Navigator.pop(context);
                      });
                    } else {
                      db
                          .createProject(_pnController.text, _nuController.text)
                          .then((_) {
                        Navigator.pop(context);
                      });
                    }
                  },
                  color: Color(0xff183E8D),
                  child: (widget.project.id != null)
                      ? Text('UPDATE',
                          style: TextStyle(fontSize: 20.0, color: Colors.white))
                      : Text('SAVE',
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ))
          ],
        ),
      ),
    );
  }
}

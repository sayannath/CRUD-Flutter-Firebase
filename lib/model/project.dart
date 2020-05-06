class Project {
  String _id;
  String _projectName;
  String _number;

  Project(this._id, this._projectName, this._number);

  Project.map(dynamic obj) {
    this._id = obj['id'];
    this._projectName = obj['projectName'];
    this._number = obj['number'];
  }

  String get id => _id;
  String get projectName => _projectName;
  String get number => _number;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['projectName'] = _projectName;
    map['number'] = _number;

    return map;
  }

  Project.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._projectName = map['projectName'];
    this._number = map['number'];
  }
}

class User {
  int _id;
  String _name;
  String _email;
  String _tipe;
  String _token;
  String _kecamatan;

  User(this._id, this._name,this._email, this._tipe,this._token, this._kecamatan);

  User.map(dynamic obj) {
    this._id = obj["id"];
    this._name = obj["name"];
    this._email = obj["email"];
    this._tipe = obj["tipe"].toString();
    this._token = obj["token"];
    this._kecamatan = obj["kecamatan"];
  }

  int get id => _id;
  String get username => _name;
  String get email => _email;
  String get tipe => _tipe;
  String get token => _token;
  String get kecamatan => _kecamatan;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["name"] = _name;
    map["email"] = _email;
    map["tipe"] = _tipe;
    map["token"] = _token;
    map["kecamatan"] = _kecamatan;

    return map;
  }
}
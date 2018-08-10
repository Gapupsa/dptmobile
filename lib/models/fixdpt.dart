class FixDpt {
  String _userid;
  String _nik;
  String _name;
  String _alamat;
  String _kecamatan;
  String _kelurahan;
  String _nohp;
  String _picname;

  FixDpt(this._userid,this._nik ,this._name,this._alamat, this._kecamatan,this._kelurahan, this._nohp,this._picname);

  FixDpt.map(dynamic obj) {
    this._userid = obj["user_id"];
    this._nik = obj["nik"];
    this._name = obj["full_name"];
    this._alamat = obj["alamat"];
    this._kecamatan = obj["kecamatan"];
    this._kelurahan = obj["kelurahan"];
    this._nohp= obj["nohp"];
    this._picname= obj["pic_name"];
  }

  String get userid => _userid;
  String get nik => _nik;
  String get name => _name;
  String get alamat => _alamat;
  String get kecamatan => _kecamatan;
  String get kelurahan => _kelurahan;
  String get nohp => _nohp;
  String get picname => _picname;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["user_id"]=this._userid; 
    map["nik"]=this._nik ;
    map["full_name"]=this._name ;
    map["alamat"]=this._alamat ;
    map["kecamatan"]=this._kecamatan ;
    map["kelurahan"]=this._kelurahan ;
    map["nohp"]=this._nohp ;
    map["pic_name"]=this._picname ;

    return map;
  }
}
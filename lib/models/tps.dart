import 'dart:io';

class Tps {
  String _kecamatan;
  String _kelurahan;
  String _tps;
  String _votes;
  String _note;
  File _pic;

  Tps(this._kecamatan,this._kelurahan,this._tps, this._votes,this._pic,this._note);

  Tps.map(dynamic obj) {
    this._kecamatan = obj["kecamatan"];
    this._kelurahan = obj["kelurahan"];
    this._tps = obj["tps"];
    this._votes= obj["votes"];
    this._note= obj["note"];
    this._pic= obj["pic_reference"];
  }

  String get kecamatan => _kecamatan;
  String get kelurahan => _kelurahan;
  String get tps => _tps;
  String get votes => _votes;
  String get note => _note;
  File get pic => _pic;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["kecamatan"]=this._kecamatan ;
    map["kelurahan"]=this._kelurahan ;
    map["tps"]=this._tps ;
    map["votes"]=this._votes ;
    map["note"]=this._note ;
    map["pic_reference"]=this._pic ;

    return map;
  }
}
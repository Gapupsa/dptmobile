import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:dptmobile/models/fixdpt.dart';
import 'package:dptmobile/models/tps.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import 'package:dptmobile/models/user.dart';
import 'package:path/path.dart';

class RestDatasource {
  static final BASE_URL = "http://databaseak.kjppgear.co.id/api/auth";
  static final LOGIN_URL = BASE_URL + "/login";
  static final INPUT_URL = BASE_URL + "/fixsend";
  static final INPUT_URLTPS = BASE_URL + "/tpssend";
  static final REGISTER_URL = BASE_URL + "/register";
  static final CHECKDATA_URL = BASE_URL + "/check/";
  static final EXPORTONE_URL = BASE_URL + "/exporttoexcelByKMT/";
  static final EXPORTTWO_URL = BASE_URL + "/exporttoexcelByKLR/";
  static final INPUT_URLUPLOAD = BASE_URL + "/uploaddata";
  //static final _API_KEY = "somerandomkey";

  Future<Map> login(String username, String password) async {
    // TODO: implement fetchCurrencies
    http.Response response = await http.post(LOGIN_URL,
      headers: {
        "Accept": "application/json",
      },
      body: {
        "email": username,
        "password": password
      }
    );

    final Map responseBody = json.decode(response.body);
    final statusCode = response.statusCode;

    return responseBody;
  }

  Future<Map> inactiveuser(String token,String id, String active) async {
    // TODO: implement fetchCurrencies
    http.Response response = await http.post("http://databaseak.kjppgear.co.id/api/auth/updateactivated",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token
      },
      body: {
        "id": id,
        "aktif": active
      }
    );

    final Map responseBody = json.decode(response.body);
    final statusCode = response.statusCode;

    return responseBody;
  }

  Future<bool> logout(String token) async {
    http.Response response = await http.get("http://databaseak.kjppgear.co.id/api/auth/logout",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token
      }
    );

    final Map responseBody = json.decode(response.body);
    if(responseBody['flag']==1){
      return true;
    }
    return false;
  }

  Future<List<User>> fetchUsers(String token) async {
    // TODO: implement fetchCurrencies
    try {
      http.Response response = await http.get("http://databaseak.kjppgear.co.id/api/auth/getusers",
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer " + token
        }
      );

      final List responseBody = json.decode(response.body);
      final statusCode = response.statusCode;
      
      if (statusCode != 200 || responseBody == null) {
        throw new FetchDataException(
            "An error ocurred : [Status Code : $statusCode]");
      }

      return responseBody.map((c) => new User.map(c)).toList();

    } catch (e){
      return null;  
    }
  }

  Future<Map> sendData(FixDpt data,String token) async {
    // TODO: implement fetchCurrencies
    http.Response response = await http.post(INPUT_URL,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token
      },
      body: {
        "user_id": data.userid,
        "nik": data.nik,
        "full_name": data.name,
        "alamat": data.alamat,
        "kecamatan": data.kecamatan,
        "kelurahan": data.kelurahan,
        "nohp": data.nohp,
        "pic_name": data.picname
      }
    );

    final Map responseBody = json.decode(response.body);

    return responseBody;
  }

  Future<Map> sendDataTps(Tps data,String token) async {
      //Map result;
      var stream= new http.ByteStream(DelegatingStream.typed(data.pic.openRead()));
      var length= await data.pic.length();
      var uri = Uri.parse(INPUT_URLTPS);
      Map<String, String> headers = { 
        "Accept": "application/json",
        "Authorization": "Bearer " + token,
      };

      var request = new http.MultipartRequest("POST", uri);

      var multipartFile = new http.MultipartFile("image", stream, length, filename: basename(data.pic.path)); 
      
      request.headers.addAll(headers);
      request.fields['kecamatan'] = data.kecamatan;
      request.fields['kelurahan'] = data.kelurahan;
      request.fields['tps'] = data.tps;
      request.fields['votes'] = data.votes;
      request.files.add(multipartFile); 

      var response = await request.send();

      if(response.statusCode==200){
        // response.stream.transform(utf8.decoder).listen((value) {
        //   return json.decode(value);
        // });
        return json.decode('{"flag":1,"success":"Data has been saved"}');
      }else if(response.statusCode==100){
        return json.decode('{"flag":2,"error":"Your account is not activated. Please contact administrator."}');
        
      }else{
        return json.decode('{"flag":3,"error":"Connection failed or Data Exists"}');
      }
  }

  Future<Map> upload(String userid,File file,String token) async {
      //Map result;
      var stream= new http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length= await file.length();
      var uri = Uri.parse(INPUT_URLUPLOAD);
      
      Map<String, String> headers = { 
        "Accept": "application/json",
        "Authorization": "Bearer " + token,
      };

      var request = new http.MultipartRequest("POST", uri);

      var multipartFile = new http.MultipartFile("excel", stream, length, filename: basename(file.path)); 
      
      request.headers.addAll(headers);
      request.files.add(multipartFile); 

      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      if(response.statusCode==200){
        return json.decode('{"flag":1,"success":"Data has been saved"}');
      }else if(response.statusCode==100){
        return json.decode('{"flag":2,"error":"Your account is not activated. Please contact administrator."}');
      }else{
        return json.decode('{"flag":3,"error":"Connection failed or Data Exists"}');
      }
  }

  Future<Map> sendDataUser(User data,String password) async {
    // TODO: implement fetchCurrencies
    http.Response response = await http.post(REGISTER_URL,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + data.token
      },
      body: {
        "name": data.username,
        "email": data.email,
        "password": password,
        "password-confirm":password,
        "kecamatan": data.kecamatan
      }
    );

    final Map responseBody = json.decode(response.body);

    return responseBody;
  }

  Future<Map> checkData(String nik,String token) async {
    // TODO: implement fetchCurrencies
    http.Response response = await http.get(CHECKDATA_URL + nik,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token
      }
    );

    final Map responseBody = json.decode(response.body);

    return responseBody;
  }

  Future<Map> downloadAsKec(String token,String kecamatan) async {
    // TODO: implement fetchCurrencies
    http.Response response = await http.get(EXPORTONE_URL+kecamatan+"/xls",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token
      }
    );

    final Map responseBody = json.decode(response.body);

    return responseBody;
  }

  Future<String> downloadAsKel(String token,String kelurahan) async {
    // TODO: implement fetchCurrencies
    http.Response response = await http.get(EXPORTTWO_URL+kelurahan+"/xls",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token
      }
    );

    final Map responseBody = json.decode(response.body);

    return responseBody['success'].toString();
  }

  Future<Map> getTotalData(String token) async {
    http.Response response = await http.get("http://databaseak.kjppgear.co.id/api/auth/getfixdptatacount",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token
      }
    );

    final Map responseBody = json.decode(response.body);

    return responseBody;
  }

  Future<Map> changeUserPassword(String token,String password,String id) async {
    http.Response response = await http.post("http://databaseak.kjppgear.co.id/api/auth/updatepassword",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token
      },
      body: {
        "id" : id,
        "password": password
      }
    );

    
    final Map responseBody = json.decode(response.body);
    final statucCode = response.statusCode;
    if (statucCode != 200 || responseBody == null) {
      throw new FetchDataException(
          "An error ocurred : [Status Code : $statucCode]");
    }

    return responseBody;
  }
}

class FetchDataException implements Exception {
  final _message;

  FetchDataException([this._message]);

  String toString() {
    if (_message == null) return "Exception";
    return "Exception: $_message";
  }
}
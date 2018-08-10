import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

class ExportData {
  Permission permission;
  static var httpClient = new HttpClient();
  ExportData() {}

  Future<File> download(String filename) async {
    String url = "http://databaseak.kjppgear.co.id/storage/public/exports/" + filename;
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      bool res = await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
      bool res1 = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
      String dir = (await getExternalStorageDirectory()).path;
      File file = new File('$dir/$filename');
      await file.writeAsBytes(bytes);
      return file;
  }
}

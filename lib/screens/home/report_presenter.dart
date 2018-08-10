import 'package:dptmobile/data/rest_ds.dart';

abstract class ReportScreenContract {
  void onSuccess(Map result);
  void onSuccessTotal(Map result);
  void onSuccessOne(Map result);
  void onError(String errorTxt);
}

abstract class UserActiveContract {
  void onSuccess(Map result);
  void onError(String errorTxt);
}

class UserScreenPresenter {
  UserActiveContract _view;
  RestDatasource api = new RestDatasource();
  UserScreenPresenter(this._view);

  changeActiveUser(String token,String id,String aktif) {
    api.inactiveuser(token,id,aktif).then((Map result) {
      _view.onSuccess(result);
    }).catchError((Exception error) => _view.onError(error.toString()));
  }
}

class ReportScreenPresenter {
  ReportScreenContract _view;
  
  RestDatasource api = new RestDatasource();
  ReportScreenPresenter(this._view);

  checkData(String nik, String token) {
    api.checkData(nik, token).then((Map result) {
      _view.onSuccess(result);
    }).catchError((Exception error) => _view.onError(error.toString()));
  }

  downloadAsKec(String token,String kecamatan){
    api.downloadAsKec(token,kecamatan).then((Map result){
      _view.onSuccessOne(result);
    }).catchError((Exception error) => _view.onError(error.toString()));
  }
  getTotalData(String token){
    api.getTotalData(token).then((Map result){
      _view.onSuccessTotal(result);
    }).catchError((Exception error) => _view.onError(error.toString()));
  }
}
import 'package:dptmobile/data/rest_ds.dart';
import 'package:dptmobile/models/user.dart';

abstract class RegisterScreenContract {
  void onLoginSuccess(Map result);
  void onGetSuccess(List<User> result);
  void onSuccessChangePassword(Map result);
  void onActiveSuccess(Map result);
  void onLoginError(String errorTxt);
}

class RegisterScreenPresenter {
  RegisterScreenContract _view;
  RestDatasource api = new RestDatasource();
  RegisterScreenPresenter(this._view);

  sendData(User data,String password) {
    api.sendDataUser(data,password).then((Map result) {
      _view.onLoginSuccess(result);
    }).catchError((Exception error) => _view.onLoginError(error.toString()));
  }

  loadUsers(String token) {
    api.fetchUsers(token).then((List<User> users) {
      _view.onGetSuccess(users);
    }).catchError((Exception error) => _view.onLoginError(error.toString()));
  }

  changePassword(String token,String password,String id) {
    api.changeUserPassword(token,password,id).then((Map result) {
      _view.onSuccessChangePassword(result);
    }).catchError((Exception error) => _view.onLoginError(error.toString()));
  }

  changeActiveUser(String token,String id,String aktif) {
    api.inactiveuser(token,id,aktif).then((Map result) {
      _view.onActiveSuccess(result);
    }).catchError((Exception error) => _view.onLoginError(error.toString()));
  }
}
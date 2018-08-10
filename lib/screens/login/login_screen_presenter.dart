import 'package:dptmobile/data/rest_ds.dart';
import 'package:dptmobile/models/user.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(Map data);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password) {
    api.login(username, password).then((Map data) {
      _view.onLoginSuccess(data);
    }).catchError((Exception error) => _view.onLoginError(error.toString()));
  }
}
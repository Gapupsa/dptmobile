import 'package:dptmobile/data/rest_ds.dart';
import 'package:dptmobile/models/fixdpt.dart';
import 'package:dptmobile/models/tps.dart';

abstract class InputScreenContract {
  void onLoginSuccess(Map result);
  void onLoginError(String errorTxt);
}

class InputScreenPresenter {
  InputScreenContract _view;
  RestDatasource api = new RestDatasource();
  InputScreenPresenter(this._view);

  sendData(FixDpt data, String token) {
    api.sendData(data, token).then((Map result) {
      _view.onLoginSuccess(result);
    }).catchError((Exception error) => _view.onLoginError(error.toString()));
  }

  sendDataTps(Tps data, String token) {
    api.sendDataTps(data, token).then((Map result) {
      _view.onLoginSuccess(result);
    }).catchError((Exception error) => _view.onLoginError(error.toString()));
  }
}
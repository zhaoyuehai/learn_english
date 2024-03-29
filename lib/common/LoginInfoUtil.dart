import 'dart:convert';

import 'package:learn_english/bean/TokenBean.dart';
import 'package:learn_english/bean/TokensBean.dart';
import 'package:learn_english/bean/login_Info.dart';

import 'Constants.dart';
import 'StorageUtil.dart';

class LoginInfoUtil {
  static final LoginInfoUtil _instance = LoginInfoUtil._internal();

  factory LoginInfoUtil() => _instance;

  LoginInfoUtil._internal();

  LoginInfoBean _info;

  Future<bool> isLogin() async {
    var infoOK = false;
    if (_info == null) {
      await StorageUtil.getString(Constants.LOGIN_INFO).then((String value) {
        if (value != null && value.isNotEmpty) {
          _info = LoginInfoBean.fromJson(json.decode(value));
          infoOK = true;
        }
      }).catchError((e) {
        exitLogin();
        infoOK = false;
      });
    } else {
      infoOK = true;
    }
    return infoOK;
  }

  LoginInfoBean getInfo() => _info;

  Future<bool> setLoginInfo(LoginInfoBean infoBean) {
    _info = infoBean;
    return StorageUtil.set(Constants.LOGIN_INFO, infoBean.toJson());
  }

  Future<bool> setToken(TokensBean data) async {
    var ok = false;
    if (_info != null) {
      _info.accessToken = data?.accessToken;
      _info.refreshToken = data?.refreshToken;
      ok = await StorageUtil.set(Constants.LOGIN_INFO, _info.toJson());
    }
    return ok;
  }

  Future<bool> exitLogin() {
    this._info = null;
    return StorageUtil.set(Constants.LOGIN_INFO, '');
  }

  TokenBean getToken() => _info.accessToken;

  TokenBean getRefreshToken() => _info.refreshToken;
}

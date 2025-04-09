import 'dart:convert';

import 'package:apitayari/app/models/country_model.dart';
import 'package:get_storage/get_storage.dart';

class StorageHelper {
  static final GetStorage box = GetStorage();

  //Keys--------//

  static const _token = 'token';
  static const _useModel = 'userModel';
  static const _isLoggedIn = 'isLoggedIn';


  void saveToken(String? token) {
    box.write(_token, token);
  }

  String? getToken() {
    return box.read(_token) ?? "";
  }


  void saveIsLoggedIn(bool? isLoggedIn){
     box.write(_isLoggedIn, isLoggedIn);

  }

  bool? getIsLoggedIn(){
      return box.read(_isLoggedIn);
  }

  void saveUserModel(CountryModel? country) {
    final jsonString = jsonEncode(country?.toJson());
    box.write(_useModel, jsonString);
  }

  static CountryModel? getUser(){
    final jsonString = box.read(_useModel);
    if(jsonString == null) return null;
    final jsonMap = jsonDecode(jsonString);
    return CountryModel.fromJson(jsonMap);

  }



}

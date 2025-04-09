import 'package:apitayari/app/data/api_constants.dart';
import 'package:apitayari/app/models/country_model.dart';
import 'package:dio/dio.dart';

class ApiProvider{

  final Dio _dio = Dio(BaseOptions(

    headers: {
    'Authorization': 'Bearer YOUR_TOKEN_HERE',
    'Accept': 'application/json',
  },

    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  ));



  Future<List<CountryModel>> getData() async {

    try{
      var response = await _dio.get(ApiConstants.url,);
      if(response.statusCode==200){
        return (response.data as List).map((e) => CountryModel.fromJson(e)).toList();
      } else {
    print("Unexpected response format");
    return [];
    }

    }on DioException catch(e){
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }
    return [];
  }



  Future <CountryModel?> getDataSingleObject() async {

    try{
      var response = await _dio.get(ApiConstants.url,);
      if(response.statusCode==200){
        return CountryModel.fromJson(response.data);
      } else {
        print("Unexpected response format");
        return null;
      }

    }on DioException catch(e){
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }
    return null;
  }


}
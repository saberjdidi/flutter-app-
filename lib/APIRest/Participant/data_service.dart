import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'Utils/app_constants.dart';

class DataService extends GetConnect implements GetxService {

  Future<Response> getData(String uri) async{
    if(kDebugMode){
      print(AppConstants.PATICIPANT_URL);
    }
    Response response = await get(
      uri,
      headers: {
        'Content-Type':' application/json; charset=UTF8'
      }
    );
    return response;
  }

  Future<Response> postData(String uri, dynamic body) async{
    Response response = await post(
        uri,
        body,
        headers: {
          'Content-Type':' application/json'
        }
    );
    return response;
  }
}
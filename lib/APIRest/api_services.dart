import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {

  getRequest(String url) async {
    //await Future.delayed(Duration(seconds: 2));
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        print("Error ${response.statusCode}");
        throw Exception(response.statusCode);
      }
    }
    catch (ex){
      print("throwing new error " + ex.toString());
      throw Exception("Error " + ex.toString());
    }
  }

  postRequest(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        print("Error ${response.statusCode}");
        throw Exception(response.statusCode);
      }
    }
    catch (ex){
      print("throwing new error " + ex.toString());
      throw Exception("Error " + ex.toString());
    }
  }

  putRequest(String url, Map data) async {
    try {
      var response = await http.put(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        print("Error ${response.statusCode}");
        throw Exception(response.statusCode);
      }
    }
    catch (ex){
      print("throwing new error " + ex.toString());
      throw Exception("Error " + ex.toString());
    }
  }

  deleteRequest(String url) async {
    try {
      var response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        print("Error ${response.statusCode}");
        throw Exception(response.statusCode);
      }
    }
    catch (ex){
      print("throwing new error " + ex.toString());
      throw Exception("Error " + ex.toString());
    }
  }
}
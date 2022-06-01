import 'package:first_app_flutter/APIRest/Participant/Utils/app_constants.dart';
import 'package:get/get.dart';
import 'data_service.dart';

class DataController extends GetxController {

  DataService service = DataService();
  bool _isLoading = false;
  bool get isloading=>_isLoading;
  List<dynamic> _myData = [];
  List<dynamic> get myData=>_myData;

  Future<void> getData() async {
    _isLoading = true;
    Response response = await service.getData(AppConstants.PATICIPANT_URL);
    if(response.statusCode == 200){
      _myData = response.body['fetchedParticipants'];
      //_myData = response.body;
      print('get data');
      update();
    }
    else {
      print('An error has occured');
    }
  }

  Future<void> postData(String fullName, String email, String job) async {
    try {
      _isLoading = true;
      Response response = await service.postData(
          AppConstants.PATICIPANT_URL,
          {
        "fullName":fullName,
        "email":email,
        "job":job
      });
      if(response.statusCode == 200){
        update();
      }
      else {
        print('An error has occured');
      }
    }
    catch (ex){
      print("throwing new error " + ex.toString());
      throw Exception("Error " + ex.toString());
    }
    _isLoading = false;
  }

  Future<void> getDataById(String id) async {
    _isLoading = true;
    Response response = await service.getData('${AppConstants.PATICIPANT_URL}/${id}');
    if(response.statusCode == 200){
      //_myData = response.body['fetchedParticipants'];
      print('get data');
      update();
    }
    else {
      print('An error has occured');
    }
    _isLoading = false;
  }
}
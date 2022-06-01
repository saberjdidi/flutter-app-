
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data_controller.dart';

class ViewParticipant extends StatelessWidget {
  final int id;
  const ViewParticipant({Key? key, required this.id}) : super(key: key);

  _loadDataById() async {
    await Get.find<DataController>().getDataById(id.toString());
    print('id passed : ${id}');
  }

  @override
  Widget build(BuildContext context) {
    _loadDataById();
    return Container();
  }
}

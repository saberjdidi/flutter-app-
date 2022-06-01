
import 'package:first_app_flutter/APIRest/Participant/participant_widget.dart';
import 'package:first_app_flutter/APIRest/Participant/view_participant.dart';
import 'package:first_app_flutter/Config/customcolors.dart';
import 'package:first_app_flutter/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import '../../UI/dashboardscreen.dart';
import 'add_participant.dart';
import 'data_controller.dart';

class AllParticipants extends StatelessWidget {
  const AllParticipants({Key? key}) : super(key: key);

  _loadData() async {
    await Get.find<DataController>().getData();
  }
  @override
  Widget build(BuildContext context) {

   /* loadData() async {
      Get.lazyPut(() => DataController());
      await Get.find<DataController>().getData();
    } */
    _loadData();

    final leftEditIcon = Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: CustomColors.blueAccent.withOpacity(0.5),
      child: Icon(
        Icons.edit,
        color: Colors.white,
      ),
      alignment: Alignment.centerLeft,
    );

    final rightDeleteIcon = Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.redAccent,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
      alignment: Alignment.centerRight,
    );

    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                lightPrimary,
                darkPrimary,
              ])),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: RaisedButton(
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.idScreen, (route) => false);
            },
            elevation: 0.0,
            child: Icon(Icons.arrow_back, color: CustomColors.blueAccent,),
            color: Colors.white,
          ),
          title: Text(
            'Participants',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: GetBuilder<DataController>(builder: (controller){
              return ListView.builder(
                  itemCount: Get.find<DataController>().myData.length,
                  itemBuilder: (context, index){
                    return Dismissible(
                      background: leftEditIcon,
                      secondaryBackground: rightDeleteIcon,
                      onDismissed: (DismissDirection direction){

                      },
                      confirmDismiss: (DismissDirection direction) async{
                        if(direction == DismissDirection.startToEnd){
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              barrierColor: Colors.transparent,
                              context: context,
                              builder: (_){
                                return Container(
                                  height: 500,
                                  decoration: const BoxDecoration(
                                      color: const Color(0xff87878e),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20, right: 20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                            onTap: (){
                                               //Get.off(()=>ViewParticipant(id: controller.myData[index]["_id"].toString()));
                                            },
                                            child: ButtonWidget(backgroundColor: CustomColors.blueAccent, text: "Edit", textColor: Colors.white)
                                        ),
                                        SizedBox(height: 20.0,),
                                        GestureDetector(
                                            onTap: (){
                                              //Get.off(()=>ViewParticipant(id: controller.myData[index]["_id"].toString()));
                                              Get.off(()=>ViewParticipant(id: int.parse(controller.myData[index]["_id"].toString())));
                                            },
                                            child: ButtonWidget(backgroundColor: CustomColors.blueAccent, text: "View", textColor: Colors.white)
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                          return false;
                        }
                        else {
                          return Future.delayed(Duration(seconds: 1), ()=>direction == DismissDirection.endToStart);
                        }
                      },
                      key: ObjectKey(index),
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        child: ParticipantWidget(
                          //text: controller.myData[index]["fullName"],
                          text: controller.myData[index]["fullName"],
                          color: Colors.blueGrey,
                        ),
                      ),
                    );
                  }
              );
            })
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          spacing: 10.0,
          closeManually: false,
          backgroundColor: Colors.blue,
          spaceBetweenChildren: 15.0,
          children: [
            SpeedDialChild(
                child: Icon(Icons.add, color: Colors.blue, size: 32),
                label: 'New Participant',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => AddParticipant()));
                  Get.to(()=>AddParticipant(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                }
            ),
          ],
        ),
      ),
    );
  }
}

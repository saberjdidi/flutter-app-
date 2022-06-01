import 'package:first_app_flutter/APIRest/Participant/error_message.dart';
import 'package:first_app_flutter/Config/customcolors.dart';
import 'package:first_app_flutter/Widgets/button_widget.dart';
import 'package:first_app_flutter/Widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Validators/validator.dart';

class NewParticipant extends StatelessWidget {
  const NewParticipant({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final _addItemFormKey = GlobalKey<FormState>();
    bool _isProcessing = false;

    TextEditingController  fullNameController = TextEditingController();
    TextEditingController  emailController = TextEditingController();
    TextEditingController  jobController = TextEditingController();

    bool _dataValidation(){
      if(fullNameController.text.trim()==''){
        //Get.snackbar("fullName", "FullName is required");
        Message.taskErrorOrWarning("FullName", "FullName is required");
        return false;
      }
      if(emailController.text.trim()==''){
        Message.taskErrorOrWarning("Email", "email is required");
        return false;
      }
      if(jobController.text.trim()==''){
        Message.taskErrorOrWarning("Job", "job is required");
        return false;
      }
      return true;
    }

    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        padding: const EdgeInsets.only(left: 20, right: 20, ),
       /* decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/logo.png")
          )
        ),*/
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 20,),
                IconButton(onPressed: (){
                  Get.back();
                },
                    icon: Icon(Icons.arrow_back,
                    color: CustomColors.bleuCiel,)
                )
              ],
            ),
            SingleChildScrollView(
              child: Form(
                key: _addItemFormKey,
                child: Column(
                  children: [
                    TextFieldWidget(
                      textEditingController: fullNameController,
                      hintText: "FullName",
                      maxlines: 1,
                    ),
                    SizedBox(height: 20.0,),
                    TextFieldWidget(
                      textEditingController: emailController,
                      hintText: "Email",
                      maxlines: 1,
                    ),
                    SizedBox(height: 20.0,),
                    TextFieldWidget(
                      textEditingController: jobController,
                      hintText: "Job",
                      borderradius: 15,
                      maxlines: 3,
                    ),
                    SizedBox(height: 20.0,),
                    GestureDetector(
                      onTap: (){
                        _dataValidation();
                      },
                      child: ButtonWidget(
                          backgroundColor: CustomColors.blueAccent,
                          text: "Save",
                          textColor: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/10,
            )
          ],
        ),
      ),
    );
  }
}

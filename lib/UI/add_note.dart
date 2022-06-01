import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:first_app_flutter/Config/utility_file.dart';
import 'package:first_app_flutter/UI/activities_screen.dart';
import 'package:first_app_flutter/UI/notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Config/customcolors.dart';
import '../Models/Note.dart';
import '../Services/note_service.dart';
import '../Validators/validator.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  NoteService service = NoteService();

  TextEditingController  nameController = TextEditingController();
  TextEditingController  descriptionController = TextEditingController();

  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  File? pickedImage;
  String imgString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, NotesScreen.noteScreen, (route) => false);
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Center(
          child: Text("Ajouter Note"),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: SingleChildScrollView(
              child: Form(
                key: _addItemFormKey,
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                      children: <Widget>[
                        SizedBox(height: 8.0,),
                        imageProfile(),
                        SizedBox(
                          height: 20,
                        ),
                        nameTextField(),
                        SizedBox(height: 10.0,),
                        descriptionTextField(),
                        SizedBox(height: 20.0,),
                        _isProcessing
                            ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              CustomColors.firebaseOrange,
                            ),
                          ),
                        )
                            :
                        ElevatedButton(
                          onPressed: () async {
                            saveData();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              CustomColors.googleBackground,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Save',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.firebaseWhite,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        )
                      ]
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //textfieldform name
  Widget nameTextField() {
    return TextFormField(
      controller: nameController,
      validator: (value) {
        if (value!.isEmpty) return "Name is required";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueAccent,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.person,
          color: Color(0xFF8E8E93),
        ),
        labelText: "Name",
        //helperText: "Name is required",
        hintText: "name",
      ),
    );
  }

  //textfieldform description
  Widget descriptionTextField() {
    return TextFormField(
      controller: descriptionController,
      validator: (value) {
        if (value!.isEmpty) return "Description is required";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueAccent,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.description,
          color: Color(0xFF8E8E93),
        ),
        labelText: "Description",
        //helperText: "Description is required",
        hintText: "description",
      ),
    );
  }

  //1. Image Picker UI
  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        /*  CircleAvatar(
          radius: 80.0,
          backgroundImage: _imageFile == null
              ? AssetImage("assets/images/user_icon.png")
              : FileImage(File(_imageFile.path)), //use with method takePhoto
          //backgroundImage: Image.network(
          //             'https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic.jpg',
          //             width: 170,
          //             height: 170,
          //             fit: BoxFit.cover,
          //           ),
        ), */
        ClipOval(
          child: pickedImage != null
              ? Image.file(
            pickedImage!,
            width: 170,
            height: 170,
            fit: BoxFit.cover,
          )
              : Image.asset(
            'assets/images/user_icon.png',
            width: 170,
            height: 170,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 5,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.add_a_photo_rounded,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  //2.Create BottomSheet
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                //takePhoto(ImageSource.camera);
                pickImage(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            SizedBox(width : 20.0,),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                //takePhoto(ImageSource.gallery);
                pickImage(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  //1 method
  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile!;
    });
  }
  //2 method
  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
        imgString = UtilityFile.base64String(tempImage.readAsBytesSync());
      });

      Navigator.of(context).pop();
    } catch (error) {
      debugPrint(error.toString());
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(child: Text(
          error.toString(),
          style: TextStyle(fontStyle: FontStyle.italic),
        ),),
        title: 'Error',
        btnCancel: Text('Cancel'),
        btnOkOnPress: () {
          Navigator.of(context).pop();
        },
      )..show();
    }
  }


  Future saveData() async {
    if (_addItemFormKey.currentState!.validate()) {
      try {
       /* if(imgString == null || imgString == ''){
          return;
        } */
        setState(() {
          _isProcessing = true;
        });

        var model = Note();
        model.name = nameController.text.trim();
        model.description = descriptionController.text.trim();
        model.image = imgString;
        print('name note ${model.name}');
        print('------------------------------');
        print('${model.image}');
        print('------------------------------');

        var result = await service.saveData(model);
        if (result > 0) {
          //Navigator.pop(context);
          print(result);
          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.SUCCES,
            body: Center(child: Text(
              'Note save successfully',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),),
            title: 'Note saved',
            btnCancel: Text('Cancel'),
            btnOkOnPress: () {
              Navigator.of(context).pushNamedAndRemoveUntil(NotesScreen.noteScreen, (route) => false);
            },
          )..show();
        }
        setState(() {
          _isProcessing = false;
        });
      }
      catch (ex){
        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: Center(child: Text(
            ex.toString(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),),
          title: 'Error',
          btnCancel: Text('Cancel'),
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        )..show();
        print("throwing new error " + ex.toString());
        throw Exception("Error " + ex.toString());
      }

    }
  }
}

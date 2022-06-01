import 'package:first_app_flutter/Config/utility_file.dart';
import 'package:first_app_flutter/Models/Note.dart';
import 'package:first_app_flutter/Services/note_service.dart';
import 'package:first_app_flutter/UI/add_activity.dart';
import 'package:first_app_flutter/UI/add_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../Widgets/loading_widget.dart';
import 'dashboardscreen.dart';
import 'multiple_images_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  static const String noteScreen = "noteScreen";

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  NoteService service = NoteService();
  List<Note> notesList = <Note>[];
  /// this variable use to check if the app still fetching data or not. ///
  bool _isLoading = true;

  // This method will run once widget is loaded
  // i.e when widget is mounting
  @override
  void initState() {
    super.initState();
    loadList();
  }

  Future loadList() async {
    //keyRefresh.currentState?.show();
    //await Future.delayed(Duration(milliseconds: 4000));

    var response = await service.readData();
    response.forEach((action){
      setState(() {
        var model = Note();
        model.id = action['id'];
        model.name = action['name'];
        model.description = action['description'];
        model.image = action['image'];
        notesList.add(model);
        _isLoading = false;

        print('name note ${model.name}');
        print('-----------------------');
        print('image note ${model.image}');
        print('-----------------------');
      });
    });
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    var response = await service.readData();
    response.forEach((action){
      setState(() {
        var model = Note();
        model.id = action['id'];
        model.name = action['name'];
        model.description = action['description'];
        model.image = action['image'];
        notesList.add(model);
        _isLoading = false;
      });
    });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Icon(Icons.arrow_back, color: Colors.blue,),
            color: Colors.white,
          ),
          title: Text(
            'Note List',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: notesList.isNotEmpty ?
            Container(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                //onLoading: _onLoading,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    
                    final name = notesList[index].name;
                    final image = UtilityFile.imageFromBase64String(notesList[index].image);
                    //final img2 = UtilityFile.dataFromBase64StringTest();
                    
                    if (!_isLoading) {
                      return Card(
                        color: Color(0xFFEEF3F6),
                        child: ListTile(
                          textColor: Colors.black87,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(35.0),
                            child: image,
                          ),
                          title: Text(name, style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Brand-Regular",
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal,//make underline
                            decorationStyle: TextDecorationStyle.double, //dou
                            decorationThickness: 1.5,// ble underline
                          ),),
                          subtitle: Text("${notesList[index].description}"),
                       /* trailing: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 25,
                          child: Image.memory(img2),
                        ), */
                        ),
                      );
                    } else {
                      return LoadingView();
                    }
                  },
                  itemCount: notesList.length,
                ),
              ),
            )
                : const Center(child: Text('Empty List', style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Brand-Bold'
            )),)
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
                label: 'New Note',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddNote()));
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.photo, color: Colors.blue, size: 32),
                label: 'multiple images',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MultipleImageScreen()));
                }
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:first_app_flutter/APIRest/card_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../Config/url_api.dart';
import '../UI/dashboardscreen.dart';
import '../Widgets/loading_widget.dart';
import 'add_book.dart';
import 'api_services.dart';
import 'edit_book.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({Key? key}) : super(key: key);

  static const String bookScreen = "bookScreen";

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

//second method use with ApiServices
class _BooksScreenState extends State<BooksScreen> with ApiServices {

  //first method
  //ApiServices _apiService = ApiServices();
  //List<Book> booksList = <Book>[];

  getData() async {
    var response = await getRequest(book_url);
    //booksList = response.map((e) => Book.fromJson(e)).toList();
    //return booksList;
    return response;
  }

 /* //if use headers
  getDataWithToken() async {
    var response = await postRequest(book_url, {
      "token": SharedPreference.getUsername();
    });
    return response;
  } */

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
            'Books',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: //sourcesList.isNotEmpty ?
            Container(
              child: ListView(
                children: [
                  FutureBuilder(
                    future: getData(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.hasData){

                      return snapshot.data.length==0
                          ? const Center(child: Text('Empty List', style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Brand-Bold'
                      )),)
                      : ListView.builder(
                        //itemCount: snapshot.data['data'].length,
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            String fullName = snapshot.data['fetchedParticipants'][index]['fullName'];
                            String job = snapshot.data['fetchedParticipants'][index]['job'];
                            //return Text("${snapshot.data['fetchedParticipants'][index]['fullName']}");
                            return CardBook(
                              //book: snapshot.data['fetchedParticipants'][index],
                              fullName: fullName,
                                job: job,
                                onTap: (){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) =>
                                  EditBook(book: snapshot.data['fetchedParticipants'][index])
                              ));
                            },
                              onDelete: () async {
                                deleteData(context, snapshot.data['fetchedParticipants'][index]['_id']);
                              },
                            );
                          });
                    }
                    if(snapshot.connectionState == ConnectionState.waiting){
                     return LoadingView();
                    }
                    return LoadingView();
                  })
                ],
              ),
            )
             /*   : const Center(child: Text('Empty List', style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Brand-Bold'
            )),) */
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
                label: 'New Book',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddBook()));
                }
            ),
          ],
        ),
      ),
    );
  }

  deleteData(context, position){
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(child: Text(
          'Are you sure to delete this item ${position}',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),),
        title: 'Delete',
        btnOk: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.blue,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          onPressed: () async {
            //int response = await service.deleteData(position);
            var response = await deleteRequest("${book_url}/${position}");
            if(response['message'] == "Participant Deleted successfully"){
              setState(() {});
              Navigator.of(context).pop();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Ok',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        closeIcon: Icon(Icons.close, color: Colors.red,),
        btnCancel: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.redAccent,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        )
    )..show();
  }
}

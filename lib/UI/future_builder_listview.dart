import 'package:first_app_flutter/UI/add_site.dart';
import 'package:flutter/material.dart';

import '../Config/customcolors.dart';
import '../Repositories/db_helper.dart';
import 'dashboardscreen.dart';

class FutureBuilderList extends StatefulWidget {
  const FutureBuilderList({Key? key}) : super(key: key);

  @override
  State<FutureBuilderList> createState() => _FutureBuilderListState();
}

class _FutureBuilderListState extends State<FutureBuilderList> {

  DBHelper dbHelper = DBHelper();

  Future<List<Map>> readData() async {
    List<Map> response = await dbHelper.readSite("select * from site");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const DashboardScreen()));
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Text("Sites"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: ListView(
          children: [
            /*MaterialButton(onPressed: () async {
             await dbHelper.deletingDatabase();
            },
            child: Text("delete database"),), */
            FutureBuilder(
                future: readData(),
                builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          return Card(
                            child: ListTile(
                              title: Text("${snapshot.data![index]['name']}"),
                              subtitle: Text("${snapshot.data![index]['description']}"),
                              trailing: IconButton(
                                onPressed: () async {
                                  int response = await dbHelper.deleteSite("DELETE FROM site WHERE id = ${snapshot.data![index]['id']}");
                                  if(response > 0){
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FutureBuilderList()));
                                  }
                                },
                                icon: Icon(Icons.delete, color: Colors.red,),
                              ),
                            ),
                          );
                        }
                    );
                  }
                  return Center(child: CircularProgressIndicator(),);
                }
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddSite()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,),
        backgroundColor: CustomColors.googleBackground,
      ),
    );

  }
}

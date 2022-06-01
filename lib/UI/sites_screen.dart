import 'package:first_app_flutter/Services/site_service.dart';
import 'package:first_app_flutter/UI/add_site.dart';
import 'package:first_app_flutter/UI/edit_site.dart';
import 'package:flutter/material.dart';

import '../Config/customcolors.dart';
import '../Models/site.dart';
import '../Repositories/db_helper.dart';
import 'dashboardscreen.dart';
import 'search_sites.dart';

class SiteScreen extends StatefulWidget {
  const SiteScreen({Key? key}) : super(key: key);

  @override
  State<SiteScreen> createState() => _SiteScreenState();
}

class _SiteScreenState extends State<SiteScreen> {

  DBHelper dbHelper = DBHelper();
  SiteService siteService = SiteService();
  bool isLoading = true;
  //List sites = [];
  List<Site> sites = [];

  Future readData() async {
    //List<Map> response = await siteService.readData();
    //sites.addAll(response);
    var response = await siteService.readData();
    response.forEach((site){
      setState(() {
        var siteModel = Site();
        siteModel.name = site['name'];
        siteModel.description = site['description'];
        siteModel.id = site['id'];
        sites.add(siteModel);
      });
    });
    isLoading = false;
    if(this.mounted){
      //change UI
      setState(() {});
    }
  }

  @override
  void initState() {
    readData();
    super.initState();
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
          actions: <Widget>[
            IconButton(
                onPressed: (){
                  showSearch(
                    context: context,
                    delegate: SearchSiteDelegate(sites),
                  );
                },
                icon: Icon(Icons.search)
            )
          ]
      ),
      body: isLoading==true ?
      Center(child: CircularProgressIndicator(),)
      : Container(
        color: Colors.white,
        child: ListView(
          children: [
           /* MaterialButton(onPressed: () async {
             await dbHelper.deletingDatabase();
            },
            child: Text("delete database"),), */
           ListView.builder(
                   itemCount: sites.length,
                   physics: NeverScrollableScrollPhysics(),
                     shrinkWrap: true,
                     itemBuilder: (context, index){
                       return Card(
                         color: Colors.white60,
                         child: ListTile(
                           textColor: Colors.black87,
                           //title: Text("${sites[index]['name']}"),
                           title: Text("${sites[index].name}"),
                           subtitle: Text("${sites[index].description}"),
                           trailing: Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               IconButton(
                                 onPressed: () async {
                                   _showDialog(context, sites[index].id);

                                 },
                                 icon: Icon(Icons.delete, color: Colors.red,),
                               ),
                               IconButton(
                                 onPressed: () async {
                                   Navigator.of(context)
                                       .push(MaterialPageRoute(builder: (context) => EditSite(
                                     id: sites[index].id,
                                     name: sites[index].name,
                                     description: sites[index].description,
                                   )));
                                 },
                                 icon: Icon(Icons.edit, color: Colors.green,),
                               )
                             ],
                           ),
                         ),
                       );
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

  void _showDialog(context, position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Are you sure to delete this site?'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () async {
                  int response = await siteService.deleteData(position);
                  if(response > 0){
                    //sites.removeWhere((element) => element['id'] == position);
                    sites.removeWhere((element) => element.id == position);
                    setState(() {});
                  }
                  Navigator.of(context).pop();
                }
            ),
            new FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


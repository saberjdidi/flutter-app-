
import 'package:first_app_flutter/Models/site.dart';
import 'package:flutter/material.dart';

import '../Services/site_service.dart';
import 'edit_site.dart';
import 'sites_screen.dart';

class SearchSiteDelegate extends SearchDelegate<Site> {

  SiteService siteService = SiteService();
  final List<Site> sites;
  List<Site> _filter = [];

  SearchSiteDelegate(this.sites);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      onPressed: () {
        close(context, Site());
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: _filter.length,
      itemBuilder: (_, index) {
        return Container(
          color: Colors.white,
          child: ListView(
            children: [
              /* MaterialButton(onPressed: () async {
             await dbHelper.deletingDatabase();
            },
            child: Text("delete database"),), */
              ListView.builder(
                  itemCount: _filter.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Card(
                      color: Colors.white60,
                      child: ListTile(
                        textColor: Colors.black87,
                        //title: Text("${sites[index]['name']}"),
                        title: Text("${_filter[index].name}"),
                        subtitle: Text("${_filter[index].description}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                //_showDialog(context, sites[index].id);

                              },
                              icon: Icon(Icons.delete, color: Colors.red,),
                            ),
                            IconButton(
                              onPressed: () async {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => EditSite(
                                  id: _filter[index].id,
                                  name: _filter[index].name,
                                  description: _filter[index].description,
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
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _filter = sites.where((site) {
      return site.name.toLowerCase().contains(query.trim().toLowerCase())
          || site.description.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();
    return ListView.builder(
      itemCount: _filter.length,
      itemBuilder: (_, index) {
        return Card(
          color: Colors.white60,
          child: ListTile(
            textColor: Colors.black87,
            //title: Text("${sites[index]['name']}"),
            title: Text("${_filter[index].name}"),
            subtitle: Text("${_filter[index].description}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    _showDialog(context, _filter[index].id);
                  },
                  icon: Icon(Icons.delete, color: Colors.red,),
                ),
                IconButton(
                  onPressed: () async {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => EditSite(
                      id: _filter[index].id,
                      name: _filter[index].name,
                      description: _filter[index].description,
                    )));
                  },
                  icon: Icon(Icons.edit, color: Colors.green,),
                )
              ],
            ),
          ),
        );
      },
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
                    //setState(() {});
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>SiteScreen()),
                            (route) => false);
                  }
                  //Navigator.of(context).pop();
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
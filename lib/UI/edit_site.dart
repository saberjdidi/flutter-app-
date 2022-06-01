import 'package:flutter/material.dart';

import '../Authentication/register_screen.dart';
import '../Repositories/db_helper.dart';
import '../Services/site_service.dart';
import 'sites_screen.dart';

class EditSite extends StatefulWidget {
  final id;
  final name;
  final description;
  const EditSite({Key? key, this.id, this.name, this.description}) : super(key: key);

  @override
  State<EditSite> createState() => _EditSiteState();
}

class _EditSiteState extends State<EditSite> {
  SiteService siteService = SiteService();

  GlobalKey<FormState> _formState = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    nameController.text = widget.name;
    descriptionController.text = widget.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Site"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Form(
              key: _formState,
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        hintText: 'Write a name',
                        labelText: 'Name'
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Write a description',
                        labelText: 'Description'
                    ),
                  ),

                  SizedBox(height: 20.0,),

                  MaterialButton(
                    onPressed: () async {
                      int response = await siteService.editData(widget.id, nameController.text, descriptionController.text);
                      displayToatMessage("Data updated ! ", context);
                      print(response);
                      if(response > 0) {
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>SiteScreen()),
                                (route) => false);
                      }
                    },
                    child: Text("Save"),
                    textColor: Colors.white,
                    color: Colors.blue,)

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

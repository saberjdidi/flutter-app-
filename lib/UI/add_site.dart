import 'package:first_app_flutter/Repositories/db_helper.dart';
import 'package:first_app_flutter/UI/sites_screen.dart';
import 'package:flutter/material.dart';

import '../Authentication/register_screen.dart';
import '../Services/site_service.dart';

class AddSite extends StatefulWidget {
  const AddSite({Key? key}) : super(key: key);

  @override
  State<AddSite> createState() => _AddSiteState();
}

class _AddSiteState extends State<AddSite> {

  //DBHelper dbHelper = DBHelper();
  SiteService siteService = SiteService();

  GlobalKey<FormState> _formState = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Site"),
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
                     newSite();
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

  newSite() async {
    /* int response = await dbHelper.insertData(
                        '''
                        INSERT INTO site (`name`, `description`)
                        VALUES ("${nameController.text}", "${descriptionController.text}")
                        '''
                      ); */
    int response = await siteService.saveData(nameController.text, descriptionController.text);
    displayToatMessage("Data saved ", context);
    print(response);
    if(response > 0) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>SiteScreen()),
              (route) => false);
    }
  }
}

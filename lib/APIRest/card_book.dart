import 'package:flutter/material.dart';

class CardBook extends StatelessWidget {
  final String fullName;
  final String job;
  final void Function() onTap;
  //final Book book;
  final void Function() onDelete;

  const CardBook({Key? key, required this.fullName, required this.job, required this.onTap, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
                child: ListTile(
                  title: Text("${fullName}"),
                  subtitle: Text("${job}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: onDelete,
                        icon: Icon(Icons.delete, color: Colors.red,),
                      ),
                     /* IconButton(
                        onPressed: () async {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) =>
                              EditSource(source: sourcesList[index])
                          ));
                        },
                        icon: Icon(Icons.edit, color: Colors.green,),
                      ) */
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

}

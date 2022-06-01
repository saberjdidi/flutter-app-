
import 'package:flutter/material.dart';

class FormationFlutter extends StatefulWidget {
  const FormationFlutter({Key? key}) : super(key: key);

  @override
  State<FormationFlutter> createState() => _FormationFlutterState();
}

class _FormationFlutterState extends State<FormationFlutter> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Hello Saphir',
        style: TextStyle(
          fontSize: 100.0,
          color: Colors.amber
        ),
      ),
    );
  }
}


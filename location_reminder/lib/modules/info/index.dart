
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget{
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Info"),
      ),
      body: ListView( 
        padding: const EdgeInsets.all(10.0),
        children:<Widget>[
          ListTile(
          leading: Icon(Icons.info),
          title: Text("What is Location Reminder"),
          subtitle: Text("Location Reminder is created for users to remember certain places which they want to memorize at some place"),
        ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("Which Version You are using"),
            subtitle: Text("1.0.0"),
            onTap: (){
              showAboutDialog(
                context: context,
                applicationName: "Location Reminder",
                applicationVersion: "1.0.0",
              );
            },
          )
        ],
      ),
    );
  }
}
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:locationreminder/modules/add_location/models/add_new_location.dart';
import 'package:locationreminder/services/loader/config_loader.dart';
import 'package:locationreminder/services/sqlite/sqlite_database_service.dart';
import 'package:image_picker/image_picker.dart';
class AddANewLocationPage extends StatefulWidget{
  _AddANewLocationPageState createState()=>_AddANewLocationPageState();
}
class _AddANewLocationPageState extends State<AddANewLocationPage>{
  final GlobalKey<FormState> _formKey=new GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey=new GlobalKey();
  AddANewLocation addANewLocation=new AddANewLocation(creation_date: DateTime.now().toIso8601String());
  SqliteDatabaseService sqliteDatabaseService;
  Future<File> imageFile;
  File file;
  void initState(){
    super.initState();
    sqliteDatabaseService=ConfigLoader().sqliteDatabaseService;
  }

  Widget showImage() {
    return Container(
      width: 150,
      height: 150,
      decoration:
      BoxDecoration(border: Border.all(color: Colors.grey.shade300),borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: FutureBuilder<File>(
              future: imageFile,
              builder:
                  (BuildContext context, AsyncSnapshot<File> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  file = snapshot.data;
                  return Image.file(
                    snapshot.data,
                    width: 150,
                    height: 150,
                  );
                } else if (snapshot.error != null) {
                  return const Text(
                    'Error Picking Image',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const Text(
                    'No Image Added',
                    textAlign: TextAlign.center,
                  );
                }
              },
            )

      ),
    ));
  }

  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source, imageQuality: 30);
    });
  }

  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add New Location"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                autocorrect: true,
                textCapitalization: TextCapitalization.words,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(gapPadding: 0.0),
                    helperText: "Please Enter Caption of the location"
                ),
                initialValue: "",
                validator: (val){
                  if(val.trim().isEmpty)
                    return "Please enter correct value";
                  return null;
                },
                onSaved: (val){
                  addANewLocation.name=val.trim();
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                autocorrect: true,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    helperText: "Please Enter Description of the location"
                ),
                initialValue: "",
                validator: (val){
                  if(val.trim().isEmpty)
                    return "Please enter correct value";
                  return null;
                },
                onSaved: (val){
                  addANewLocation.description=val.trim();
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    showImage(),
                    RaisedButton(
                      splashColor: Colors.grey.shade200,
                      child: Text('Select Image',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        pickImageFromGallery(ImageSource.camera);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: ()async{
            if(_formKey.currentState.validate()) {
              if(file==null){
                await _scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text("Please add an Image"),backgroundColor: Colors.red,duration: Duration(seconds: 2)));
              }else {
                _formKey.currentState.save();
                final bytes = await file.readAsBytes();
                addANewLocation.image = base64.encode(bytes);
                //TODO-Encode file and save
                await _scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text("Adding new Location")));
                await sqliteDatabaseService.insertUserInfo(addANewLocation);
                Future.delayed(Duration(seconds: 2), () {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("Added"), backgroundColor: Colors.green));
                  Navigator.popAndPushNamed(context, '/dashboard');
                });
              }
            }
          },
          label: Text("Add"),
          icon: Icon(Icons.add),
      ),
    );
  }
}
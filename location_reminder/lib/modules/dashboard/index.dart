import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locationreminder/modules/add_location/models/add_new_location.dart';
import 'package:locationreminder/services/loader/config_loader.dart';
import 'package:locationreminder/services/sqlite/sqlite_database_service.dart';
import 'package:share/share.dart';
import '../../shared/assets/icons.dart';
class DashboardPage extends StatefulWidget{
  DashboardPage({Key key}):super(key:key);
  _DashboardPageState createState()=>_DashboardPageState();
}
class _DashboardPageState extends State<DashboardPage>{
  AddANewLocation addANewLocation=new AddANewLocation(creation_date: DateTime.now().toIso8601String());
  SqliteDatabaseService sqliteDatabaseService;
  var dateMap={
    1:"Jan",2:"Feb",3:"Mar",4:"Apr",5:"May",6:"Jun",7:"July",8:"Aug",9:"Sep",10:"Oct",11:"Nov",12:"Dec"
  };
  void initState(){
    super.initState();
    sqliteDatabaseService=ConfigLoader().sqliteDatabaseService;
  }
  Widget build(BuildContext context){
    return sqliteDatabaseService==null ? Center(child: Text("Loading")):
    SafeArea(
      child: Scaffold(
          drawer: Drawer(
            elevation: 10.0,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
                    )
                  )
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Home"),
                  trailing: IconSize.forwardNavigationSmallSizeBlackColor,
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/dashboard');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add_location),
                  title: Text("Add New Location"),
                  trailing: IconSize.forwardNavigationSmallSizeBlackColor,
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/add');
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text("App Info"),
                  trailing: IconSize.forwardNavigationSmallSizeBlackColor,
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/info');
                  },
                ),
              ],
            ),
          ),
          body:CustomScrollView(
            scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: true,
              actions: <Widget>[
                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, "/add");
                  },
                  child: Icon(Icons.add,color: Colors.white,
                      semanticLabel: "Add"),
                )

              ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text("Locations",style: TextStyle(color: Colors.white)),
              background: Image.asset("assets/images/background.jpg",fit:BoxFit.cover),
            )
          ),
          SliverFillRemaining(
            child: Container(
              height: MediaQuery.of(context).size.height*0.5,
              child: FutureBuilder(
                future: sqliteDatabaseService.getAll(),
                builder: (context,AsyncSnapshot<List<AddANewLocation>> snapshot){
                  switch(snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if(snapshot.data.length>0) {
                        return ListView.separated(
                          padding: const EdgeInsets.all(10.0),
                            separatorBuilder: (context,index){
                              return Divider(height: 1.0,color: Colors.grey);
                            },
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, int index) {
                            DateTime dateTime=DateTime.parse(snapshot.data[index].creation_date);
                            String date=dateTime.day.toString()+"-"+dateMap[dateTime.month]+"-"+
                              dateTime.year.toString();
                              return Dismissible(
                                key: ObjectKey(snapshot.data[index]),
                                onDismissed: (direction)async{
                                  if(direction==DismissDirection.startToEnd){

                                   await sqliteDatabaseService.deleteUserInfo(snapshot.data[index].id);
                                   setState(() {
                                     snapshot.data.remove(snapshot.data[index]);
                                   });
                                  }
                                },
                                child: ListTile(
                                  //leading: Image.memory(base64.decode(snapshot.data[index].image)),
                                  leading: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Color(0xffFDCF09),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: MemoryImage(base64.decode(snapshot.data[index].image)),
                                    ),
                                  ),
                                  title: Text(snapshot.data[index].name),
                                  subtitle: Text(snapshot.data[index].description),
                                  trailing:
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.35,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[

                                        Text("${date}"),
                                        IconButton(
                                          onPressed: (){
                                            Share.share(snapshot.data[index].description);
                                          },
                                          icon: Icon(Icons.share),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                        );
                      }else
                        return Center(
                            child:
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("No Location saved till now",style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold
                                ),),
                                IconButton(
                                  onPressed: (){
                                    Navigator.popAndPushNamed(context, '/add');
                                  },
                                  icon: Icon(Icons.add_location),
                                )
                              ],
                            )
                        );
                  }
                },
              ),
            )
          )
        ],
      )),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  final String title;
  HomePage({this.title});
  _HomePageState createState()=>_HomePageState();
}
class _HomePageState extends State<HomePage>{

  void initState(){
    super.initState();

  }
  Widget build(BuildContext context){
    return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/splash.jpg"),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
            )
          ),
          child: Center(
            child:
                Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.height*0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.white,width: 1.0),
                    color: Colors.white.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                          )),
                      Text(
                        "Remember Your memories",
                        style: TextStyle(
                            fontSize: 16.0
                        ),
                        ),
                        SizedBox(height: 10.0,),
                        RaisedButton.icon(onPressed: (){
                          Navigator.popAndPushNamed(context, '/dashboard');
                        },
                            icon: Icon(Icons.arrow_forward_ios,color: Colors.white,size: 12.0,),
                            label: Text("Continue",style: TextStyle(color: Colors.white)))
                      ],
                    ),
                  ),
                ),


          ),
        )
    );
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({this.firestore});

  final Firestore firestore;

  String _userName;
  String _password;

  /*Future<Null> _addMessage() async {
    var db = Firestore.instance;

    String wholeFile = await getFileData("assets/gampys_soda.json");

    Map<String, dynamic> data = json.decode(wholeFile);

    String storeName = "gampys_soda";
    List<String> storeOptions = ["Coca-Cola","Pepsi","Sprite","Dr Pepper","Mountain Dew","Food"];
    db.collection(storeName).document("meta").setData(data["meta"]);
    db.collection(storeName).document(storeOptions[0]).setData(data[storeOptions[0]]);
    db.collection(storeName).document(storeOptions[1]).setData(data[storeOptions[1]]);
    db.collection(storeName).document(storeOptions[2]).setData(data[storeOptions[2]]);
    db.collection(storeName).document(storeOptions[3]).setData(data[storeOptions[3]]);
    db.collection(storeName).document(storeOptions[4]).setData(data[storeOptions[4]]);
    db.collection(storeName).document(storeOptions[5]).setData(data[storeOptions[5]]);


  }*/

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }
  
  Future<void> setLocation() async{
    var currentLocation = <String, double>{};

    var location = new Location();

// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();
      var db = Firestore.instance;
      Map<String,dynamic> data = {"long":currentLocation["latitude"],"lat":currentLocation["longitude"]};
      db.collection("little_poblano").document("meta").updateData(data);
      
      
    } on PlatformException {
      currentLocation = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: const Text("Bama Food Trucks"),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: new RaisedButton(
                    child: new Text(
                      "Update Location", style: new TextStyle(fontSize: 40.0),),
                    onPressed: () {
                      setLocation();
                    })
            )
          ],
        ),
      ),
    );
  }
}

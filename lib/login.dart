import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings.dart';

class LoginPage extends StatelessWidget {
  LoginPage({this.firestore});

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
            new TextFormField(
              style: new TextStyle(fontSize: 40.0, color: Colors.black),
              onSaved: (val) => _userName = val,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                labelText: 'Username',
                labelStyle: new TextStyle(fontSize: 30.0),
                hintText: "Username",
                hintStyle: new TextStyle(fontSize: 40.0),
                semanticCounterText: "Username",
              ),
            ),
            new TextFormField(
              style: new TextStyle(fontSize: 40.0, color: Colors.black),
              obscureText: true,
              onSaved: (val) => _password = val,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                labelText: 'Password',
                labelStyle: new TextStyle(fontSize: 30.0),
                hintText: "Password",
                hintStyle: new TextStyle(fontSize: 40.0),
                semanticCounterText: "Password",
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: new RaisedButton(
                    child: new Text(
                      "Submit",
                      style: new TextStyle(fontSize: 40.0),
                    ),
                    onPressed: () {
                      if (_password != "fail" ||
                          _password == "little_poblano" ||
                          _password == "gampys_soda") {
                        Navigator.pop(context);
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (BuildContext context) {
                          return new SettingsPage(
                            firestore: firestore,
                          );
                        }));
                      } else {
                        Navigator.pop(context);
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (BuildContext context) {
                          return new AlertDialog(
                            title: new Text("UNAUTHORIZED"),
                            actions: <Widget>[
                              new FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: new Text("Ok"))
                            ],
                          );
                        }));
                      }
                    }))
          ],
        ),
      ),
    );
  }
}

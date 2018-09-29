import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'test',
    options: const FirebaseOptions(
      googleAppID: '1:1037770152093:android:970c718748b0e012',
      gcmSenderID: '1037770152093',
      apiKey: 'AIzaSyBB2VBM7JT3Phpwc4o7gpcT0oLuj1vDREE',
      projectID: 'test1-ac6bd',
    ),
  );
  final Firestore firestore = new Firestore(app: app);

  runApp(new MaterialApp(
      title: 'Bama Food Trucks', home: new MyHomePage(firestore: firestore)));
}

class MessageList extends StatelessWidget {
  MessageList({this.firestore});

  final Firestore firestore;

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('local_roots').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('No Menu Avaliable...'); // If there isn't any data, say no Menu

        // Removes the Meta Data document.
        var metaIndex = snapshot.data.documents.indexWhere((document) => document.documentID == "meta");
        if(metaIndex != -1) var meta = snapshot.data.documents.removeAt(metaIndex);


        return new ListView(
          children: expandedWidgetList(snapshot.data.documents),
        );
      },
    );
  }

  List<Widget> expandedWidgetList(List<DocumentSnapshot> snapshots){
    List<Widget> expansionList = [];

    if(snapshots != null &&  snapshots.isNotEmpty) {
      for (var snapshot in snapshots) {
        //var text = snapshot.data["test"];

        expansionList.add(new ExpansionTile(title: new Text(snapshot.documentID),
          children: tileWidgetList(snapshot.data["items"]),
        ));
      }
    }
    return expansionList;
  }
  List<Widget> tileWidgetList(List<dynamic> list){
    List<Widget> expansionList = [];
    for(Map map in list) {
      expansionList.add(new ListTile(
        title: new Text(map["name"]),
        //isThreeLine: true,
        subtitle: map.containsKey("description") ? new Text(map["description"]) : null,
      ),);
    }
    return expansionList;
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({this.firestore});
  final Firestore firestore;

  CollectionReference get messages => firestore.collection('messages');

  Future<Null> _addMessage() async {
    /*var db = Firestore.instance;

    String wholeFile = await getFileData("assets/local_roots.json");

    Map<String, dynamic> data = json.decode(wholeFile);

    db.collection("local_roots").document("meta").setData(data["meta"]);
    db.collection("local_roots").document("Entrees").setData(data["Entrees"]);
    db.collection("local_roots").document("Sides").setData(data["Sides"]);
    db.collection("local_roots").document("Drinks").setData(data["Drinks"]);*/
  }

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Firestore Example'),
      ),
      body: new MessageList(firestore: firestore),
      floatingActionButton: new FloatingActionButton(
        onPressed: _addMessage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
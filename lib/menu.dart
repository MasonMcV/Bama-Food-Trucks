import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';


class MessageList extends StatelessWidget {
  MessageList({this.firestore, this.reference, this.title});

  final Firestore firestore;
  final String reference;
  final String title;

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      stream: firestore.collection(reference).snapshots(),
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

  List<Widget> expandedWidgetList(List<DocumentSnapshot> snapshotList){
    List<Widget> expansionList = [];

    if(snapshotList != null &&  snapshotList.isNotEmpty) {
      for (var snapshotDocument in snapshotList) {
        //var text = snapshot.data["test"];

        expansionList.add(new ExpansionTile(title: new Text(snapshotDocument.documentID),
          children: tileWidgetList(snapshotDocument.data["items"]),
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

class MenuPage extends StatelessWidget {
  MenuPage({this.firestore, this.reference, this.title});
  final Firestore firestore;
  final String reference;
  final String title;

  CollectionReference get messages => firestore.collection('messages');

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: Text(title),
      ),
      body: new MessageList(firestore: firestore, reference: reference, title: title),
    );
  }
}
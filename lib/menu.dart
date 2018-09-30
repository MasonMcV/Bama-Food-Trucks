import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'map.dart';


class MessageList extends StatelessWidget {
  MessageList({this.firestore, this.context, this.reference, this.title});

  BuildContext context;

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
        var meta = snapshot.data.documents.removeAt(metaIndex);

        var send = {"lat":meta["lat"],"long":meta["long"]};
        return new ListView(
          children: expandedWidgetList(snapshot.data.documents, send),
        );
      },
    );
  }

  Widget imageCard(var lat, var long) {
    String firstHalf = "https://api.mapbox.com/styles/v1/mapbox/streets-v10/static/";
    var _lat = lat;
    var _long = long;
    var _zoom = 17.00;
    String secondHalf = ",0,0/600x600?access_token=pk.eyJ1IjoibWFzb25tY3YiLCJhIjoiY2ptbmd3NThvMHRvdDNwcGR2ZTkzajhheCJ9.ad1bCvlsdErHKmTom2GPgQ";
    String imageString = firstHalf + _lat.toString() + "," + _long.toString() +
        "," + _zoom.toString() + secondHalf;
    return new Card(
        child: new Stack(
          children: <Widget>[
            new Center(
              child: new Image.network(imageString,),
            ),
            new Container(
              child: new Icon(
                Icons.add_location,
                size: 40.0,
                color: Colors.red,
              ),
              alignment: Alignment(0.0, 0.0),
            ),
          ],
          alignment: Alignment(0.0, 0.0),
        )
    );
  }


  List<Widget> expandedWidgetList(List<DocumentSnapshot> snapshotList, var sent){
    List<Widget> expansionList = [];

    expansionList.add(
        imageCard(sent["lat"], sent["long"])
    );

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
        backgroundColor: Colors.red,
        title: Text(title),
      ),
      body: new MessageList(firestore: firestore, reference: reference, title: title),
    );
  }
}
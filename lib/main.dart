import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_gl/controller.dart';
import 'package:mapbox_gl/overlay.dart';
import 'dart:convert';
import 'menu.dart';

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
    DocumentSnapshot snapshots;
    AsyncSnapshot<QuerySnapshot> snapshot;

    return new StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('store_list').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('No Menu Avaliable...'); // If there isn't any data, say no Menu

        //print(snapshot.data.documents);

        // Removes the Meta Data document.
        //var metaIndex = snapshot.data.documents.indexWhere((document) => document.documentID == "meta");
        //if(metaIndex != -1) var meta = snapshot.data.documents.removeAt(metaIndex);

        //print(snapshot.data.documents[0]["truck"]);

        return new ListView(
          children: storeNameWidgetList(snapshot.data.documents, context),
        );
      },
    );
    /*print(data);
    print(snapshots);
    List<dynamic> list;

    for(var that in snapshots.data["stores"]){
      Future<DocumentSnapshot> data = firestore.collection(that).document("meta").get();

      data.then((DocumentSnapshot stuff) => snapshots);

      list.add(snapshots);
    }
    return new ListView(
      children: tileWidgetList(list, context),
    );*/
  }

  List<Widget> storeNameWidgetList(List<DocumentSnapshot> snapshotList,
      BuildContext context) {
    List<Widget> expansionList = [];

    if (snapshotList != null && snapshotList.isNotEmpty) {
      for (var snapshotDocument in snapshotList) {
        //var text = snapshot.data["test"];
        for (var iterator in snapshotDocument["stores"]) {
          String truckTitle;
          var metaIndex = firestore.collection(iterator).document("meta").get();
          var metaFound = metaIndex.then((DocumentSnapshot snap){
            truckTitle = snap.data["truck"];
          });


          expansionList.add(new ListTile(
            title: new Text(iterator),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (BuildContext context) {
                    return new MenuPage(firestore: firestore,title: truckTitle, reference: iterator,);
                  })
              );
            },
          ),);

        }
        /*new ExpansionTile(title: new Text(snapshotDocument.documentID),
          children: tileWidgetList(snapshotDocument.data["items"],context),
        ));*/
      }
    }
    return expansionList;
  }

  /*List<Widget> tileWidgetList(List<dynamic> list, BuildContext context) {
    List<Widget> expansionList = [];
    for (Map map in list) {
      expansionList.add(new ListTile(
        title: new Text(map["truck"]),
        onTap: () {
          Navigator.push(
              context, new MaterialPageRoute(builder: (BuildContext context) {
            return new MenuPage(firestore: firestore,);
          }));
        },
      ),);
    }
    return expansionList;
  }*/
}

class MyHomePage extends StatelessWidget {
  final MapboxOverlayController controller = new MapboxOverlayController();
  MyHomePage({this.firestore});
  final Firestore firestore;

  Future<Null> _addMessage() async {
    /*var db = Firestore.instance;

    String wholeFile = await getFileData("assets/little_poblano.json");

    Map<String, dynamic> data = json.decode(wholeFile);

    String storeName = "little_poblano";
    List<String> storeOptions = ["Tacos","Tamales","Sides","drinks"];
    db.collection(storeName).document("meta").setData(data["meta"]);
    db.collection(storeName).document("Tacos").setData(data["Tacos"]);
    db.collection(storeName).document("Tamales").setData(data["Tamales"]);
    db.collection(storeName).document("Sides").setData(data["Sides"]);
    db.collection(storeName).document("Drinks").setData(data["Drinks"]);*/
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
      body: new Container(
        child: new MapboxOverlay(
          controller: controller,
          options: new MapboxMapOptions(
            style: Style.mapboxStreets,
            camera: new CameraPosition(
                target: new LatLng(lat: 37.8155984, lng: -97.9640312),
                zoom: 11.0,
                bearing: 0.0,
                tilt: 0.0),
          ),
        ),
      ),
      //body: new MessageList(firestore: firestore),
      floatingActionButton: new FloatingActionButton(
        onPressed: _addMessage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_gl/controller.dart';
import 'package:mapbox_gl/overlay.dart';
import 'dart:convert';
import 'menu.dart';
import 'map.dart';
import 'dart:io';
import 'login.dart';

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
      title: 'Bama Food Trucks',
      theme: new ThemeData(accentColor: Colors.red),
      home: new MyHomePage(firestore: firestore)));
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

        return new ListView(
          children: storeNameWidgetList(snapshot.data.documents, context),
        );
      },
    );
  }

  List<Widget> storeNameWidgetList(List<DocumentSnapshot> snapshotList,
      BuildContext context) {
    List<Widget> expansionList = [];

    expansionList.add(
        new GestureDetector(child:
        new Card(
          child: new Image.network(
              "https://api.mapbox.com/styles/v1/mapbox/streets-v10/static/-87.5466108,33.2116995,14.25,0,0/600x400?access_token=pk.eyJ1IjoibWFzb25tY3YiLCJhIjoiY2ptbmd3NThvMHRvdDNwcGR2ZTkzajhheCJ9.ad1bCvlsdErHKmTom2GPgQ",
          ),

           /*Image.asset(
            'assets/image.png',
            width: 600.0,
            height: 240.0,
            fit: BoxFit.cover,
          ),*/
        ),
          /*onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return new MapPage(lat: -87.5466108, long: 33.2116995,);
                })
            );
          },*/
        )
    );

    if (snapshotList != null && snapshotList.isNotEmpty) {
      for (var snapshotDocument in snapshotList) {
        //var text = snapshot.data["test"];
        for (var iterator in snapshotDocument["stores"]) {
          String truckTitle = "this is a text";
          /*var metaIndex = firestore.collection(iterator).document("meta").get();
          var metaFound = metaIndex.then((DocumentSnapshot snap){
            truckTitle = snap.data["truck"];
          });*/

          if(iterator == "gampys_soda")
            truckTitle = "Gampy's Soda";
          if(iterator == "little_poblano")
            truckTitle = "Little Poblano Mexican Grill";
          if(iterator == "local_roots")
            truckTitle = "Local Roots";

          expansionList.add(new ListTile(
            title: new Text(truckTitle),
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
      }
    }
    return expansionList;
  }
}

class MyHomePage extends StatelessWidget {
  final MapboxOverlayController controller = new MapboxOverlayController();
  MyHomePage({this.firestore});
  final Firestore firestore;

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
      /*body: new Container(
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
      ),*/
      body: new MessageList(firestore: firestore),
      /*floatingActionButton: new FloatingActionButton(
        onPressed: _addMessage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new DrawerHeader(
              child: null,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage('assets/icon.png'),
                  )
              ),
            ),
            new ListTile(
              leading: new Icon(Icons.settings),
              title: new Text("Settings"),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (BuildContext context) {
                      return new LoginPage(firestore: firestore,);
                    })
                );
              },
            )
          ],
        )
      ),
    );
  }
}
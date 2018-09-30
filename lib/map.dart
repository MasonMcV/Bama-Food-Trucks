import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_gl/controller.dart';
import 'package:mapbox_gl/overlay.dart';
import 'dart:convert';
import 'menu.dart';


class MapPage extends StatelessWidget {
  final MapboxOverlayController controller = new MapboxOverlayController();
  MapPage({this.lat, this.long});


  String firstHalf = "https://api.mapbox.com/styles/v1/mapbox/streets-v10/static/";
  var lat = -87.5466108;
  var long = 33.2116995;
  var zoom = 14.25;
  String secondHalf = ",0,0/600x600?access_token=pk.eyJ1IjoibWFzb25tY3YiLCJhIjoiY2ptbmd3NThvMHRvdDNwcGR2ZTkzajhheCJ9.ad1bCvlsdErHKmTom2GPgQ";



  @override
  Widget build(BuildContext context) {
    String imageString = firstHalf + lat.toString() + "," + long.toString() + "," +zoom.toString() + secondHalf;
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: const Text('Bama Food Trucks'),
      ),
      /*body: new Container(
          *//*constraints: new BoxConstraints.expand(
            height: 200.0,
          ),
          padding: new EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: null,
              *//**//*image: new Image.network(imageString);*//**//*
              fit: BoxFit.cover,
            ),
          ),*//*
          child: new Stack(
            children: <Widget>[
              new Center(
                child: new Image.network(imageString),
              ),
              new Center(
                child: new Icon(Icons.add_location, size: 40.0, color: Colors.red,),
              ),
            ],
          )
      )*/

      body: new Container(
        child: new MapboxOverlay(
          controller: controller,
          options: new MapboxMapOptions(
            style: Style.mapboxStreets,
            camera: new CameraPosition(
                target: new LatLng(lat: 33.2116995, lng: -87.5466108),
                zoom: 14.25,
                bearing: 0.0,
                tilt: 0.0),
          ),
        ),
      ),
      //body: new MessageList(firestore: firestore),
    );
  }
}
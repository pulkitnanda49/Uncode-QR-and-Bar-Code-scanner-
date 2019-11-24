import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:qr_scanner_apk/play_video/play_video.dart';
import 'package:video_player/video_player.dart';


void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    ));

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String result = "Scan to Authenticate";

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera Permission denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "Back Button Pressed ";
      });
    }catch(ex){
      setState(() {
        result='unknown error $ex';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(result);
    return Scaffold(
      appBar: AppBar(
        title: Text('Uncode QR & Bar Code'),
        
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: <Widget>[
          _getPlayer(),
          _getImage(),
          Container(child: Text(result,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w400),)),
        ],
      ),
          
         
        
        

      
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        icon: Icon(Icons.center_focus_weak),
        label: Text('Scan'),

        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _getPlayer() {
    Map<String, dynamic> j;
    
    try {
      j = json.decode(result);
      if (j['video_urls'][0].trim().substring(0, 4) == 'http') {
        return Container(
        child: Column(children: <Widget>[
          Container(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Video From API',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.w600),),
              ),
              PlayVideo(
            videoPlayerController: VideoPlayerController.network(j['video_urls'][0]),
            looping:true,
          ),

            ],
          ))]));
      } else {
        return Text('result is not a url');
      }

    } catch (e) {
      
      return Center(child: Text('No Video Attached'));
    }

    
  }
  Widget _getImage() {
    Map<String, dynamic> j;
    
    try {
      j = json.decode(result);
      if (j['img_urls'][0].trim().substring(0, 4) == 'http') {
        return  Container(
            height: 500.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Images From API',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.w600),),
                ),
                Flexible(
                 
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                  height: 150.0,
                  width:160,
                  child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(j['img_urls'][0],fit: BoxFit.fill,),
                  ),
                ),
                Container(
                  height: 150.0,
                  width:160,
                  child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(j['img_urls'][0],fit: BoxFit.fill,),
                  ),
                ),
                    ],
                  ),
                ),
              ],
            ),
          );

        
      } else {
        return Text('Image result is not a url');
      }

    } catch (e) {
      
      return Center(child: Text('No Image Attached'));
    }
   

    
  }
}

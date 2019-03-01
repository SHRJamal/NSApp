import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Image.asset(
                  'main_img.png',
                  width: 200.0,
                ),
              )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
                child: Center(
                  child: Text(
                    "Protection & Saftely Code System",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 50.0, top: 20.0),
                    width: MediaQuery.of(context).size.width - 40.0,
                    height: 50.0,
                    alignment: AlignmentDirectional.center,
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        "SEARCH QR CODE",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  _scanQR();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      print(qrResult);
      FlutterWebviewPlugin().launch(
        qrResult,
        rect: new Rect.fromLTWH(
          0.0,
          25.0,
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height - 25.0,
        ),
      );
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Camera permission was denied"),
          ),
        );
      } else {
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("SomeThing went"),
          ),
        );
      }
    } on FormatException {
      print("You pressed the back button before scanning anything");
    } catch (ex) {
      print("Unknown Error: $ex");
    }
  }
}

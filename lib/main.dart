import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

void main() => runApp(new MaterialApp(
      home: new HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;
  Icon icon= new Icon(Icons.assignment_late, color: Colors.white70,);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      print(_connectionStatus);
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
            icon= new Icon((result == ConnectivityResult.wifi) ? Icons.wifi:Icons.date_range,color: Colors.white,);
      
      }
      if(result == ConnectivityResult.none) icon= new Icon(Icons.assignment_late, color: Colors.red,);
      setState(() {});
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future getData() async {
    http.Response response =
        await http.get("https://jsonplaceholder.typicode.com/posts/");
    if (response.statusCode == HttpStatus.OK) {
      var result = jsonDecode(response.body);
      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text("Connectivy"),
        actions: <Widget>[
          icon ,
        ],),
        body: new FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var mydata = snapshot.data;
              return new ListView.builder(
                itemBuilder: (context, i) => new ListTile(
                      title: Text(mydata[i]['title']),
                      // subtitle: Text(mydata[i]['body']),
                    ), 
                itemCount: mydata.length,
              );
            } else {
              return Center(
                child: new CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
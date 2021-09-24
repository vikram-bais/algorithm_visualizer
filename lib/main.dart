import 'package:flutter/material.dart';
import 'package:algorithm_visualizer/screens/graphs.dart';

void main() {
  runApp(
    myflutterapp()
    );
}

class myflutterapp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Algorithms Visualizer"),
          backgroundColor: Colors.blueGrey.shade900,
          ),
        body: Material(
        child: try_graph()
      ),
      )
    );
  }
}

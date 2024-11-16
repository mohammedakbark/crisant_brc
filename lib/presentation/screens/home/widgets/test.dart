import 'package:flutter/material.dart';

class FloatingWidgetExample extends StatefulWidget {
  @override
  _FloatingWidgetExampleState createState() => _FloatingWidgetExampleState();
}

class _FloatingWidgetExampleState extends State<FloatingWidgetExample> {
  double top = 100;
  double left = 50;
  bool isMinimized = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Floating Widget Example"),
      ),
      body: Stack(
        children: [
          // Main content
          Center(
            child: Text("Main Content Here"),
          ),

          // Floating widget
          
        ],
      ),
    );
  }
}
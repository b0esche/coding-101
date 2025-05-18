import 'package:flutter/material.dart';
import 'package:gig_hub/tut.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Selected Colors')),
      body: Center(
        child: Column(
          children: [
            if (isSelected1)
              Container(height: 80, width: 80, color: Colors.green),
            if (isSelected2)
              Container(height: 80, width: 80, color: Colors.red),
            if (isSelected3)
              Container(height: 80, width: 80, color: Colors.blue),
            if (isSelected4)
              Container(height: 80, width: 80, color: Colors.yellow),
          ],
        ),
      ),
    );
  }
}

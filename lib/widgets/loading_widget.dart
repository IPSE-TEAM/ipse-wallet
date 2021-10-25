import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
  }
}
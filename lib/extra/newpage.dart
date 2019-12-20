import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  final String title;
  final BuildContext appContext;

  NewPage(this.appContext, this.title);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Text(title),
        ),
      ),
    );
  }
}

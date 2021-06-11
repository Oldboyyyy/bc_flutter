import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String id;
  DetailPage(this.id);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text('详情, id:${widget.id}'),
      ),
    );
  }
}

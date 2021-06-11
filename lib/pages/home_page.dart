import 'package:bc_flutter/navigator/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  late ValueChanged<String> onJumpDetail;
  HomePage({onJumpDetail});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text('首页'),
            MaterialButton(
              onPressed: () {
                const map = {'id': '222'};
                BCNavigator.getInstance()
                    .onNavigateTo(RouteStatus.detail, args: map);
              },
              child: Text('跳转详情'),
            )
          ],
        ),
      ),
    );
  }
}

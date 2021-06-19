import 'package:bc_flutter/navigator/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  late ValueChanged<String> onJumpDetail;
  HomePage({onJumpDetail});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  var listener;
  @override
  void initState() {
    super.initState();
    BCNavigator.getInstance().addListener(this.listener = (current, pre) {
      print('current page: ${current.widget}');
      print('pre page: ${pre?.widget}');
      if (widget == current.widget || current.widget is HomePage) {
        print('homePage:onResume');
      } else if (widget == pre?.widget || pre?.widget is HomePage) {
        print('homePage:onPause');
      }
    });
  }

  @override
  void dispose() {
    BCNavigator.getInstance().removeListener(this.listener);
    super.dispose();
  }

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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

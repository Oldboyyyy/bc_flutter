import 'package:bc_flutter/navigator/navigator.dart';
import 'package:bc_flutter/pages/home_tab_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  late ValueChanged<String> onJumpDetail;
  HomePage({onJumpDetail});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var listener;
  var tabs = [
    'tab1',
    'tab2',
    'tab3',
    'tab4',
    'tab5',
    'tab6',
    'tab7',
    'tab8',
    'tab9',
    'tab10',
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this);

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
      // appBar: AppBar(),

      body: Column(
        children: [
          Container(
            color: Colors.blue,
            padding: EdgeInsets.only(top: 30),
            child: _tabBar(),
          ),
          Flexible(
              child: TabBarView(
            controller: _tabController,
            children: tabs.map((tab) {
              return HomeTabPage(title: tab);
            }).toList(),
          )),
          // Text('首页'),
          // MaterialButton(
          //   onPressed: () {
          //     const map = {'id': '222'};
          //     BCNavigator.getInstance()
          //         .onNavigateTo(RouteStatus.detail, args: map);
          //   },
          //   child: Text('跳转详情'),
          // )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _tabBar() {
    return TabBar(
      tabs: tabs.map<Tab>((tab) {
        return Tab(
            child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Text(
            tab,
            style: TextStyle(fontSize: 16),
          ),
        ));
      }).toList(),
      controller: _tabController,
      isScrollable: true,
      labelColor: Colors.white,
      indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.pinkAccent, width: 3),
          insets: EdgeInsets.only(left: 15, right: 15)),
    );
  }
}

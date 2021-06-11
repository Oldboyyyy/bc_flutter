import 'package:bc_flutter/navigator/navigator.dart';
import 'package:bc_flutter/pages/detail_page.dart';
import 'package:bc_flutter/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BCApp());
}

class BCApp extends StatefulWidget {
  @override
  _BCAppState createState() => _BCAppState();
}

class _BCAppState extends State<BCApp> {
  BCRouteDelegate _routeDelegate = BCRouteDelegate();
  BCRouteInfomationParser _routeInfomationParser = BCRouteInfomationParser();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      /// 异步初始化
      future: Future.delayed(Duration(seconds: 5), () => 2),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        var widget = snapshot.connectionState == ConnectionState.done
            ? Router(
                routeInformationParser: _routeInfomationParser,
                routerDelegate: _routeDelegate,
                routeInformationProvider: PlatformRouteInformationProvider(
                    initialRouteInformation: RouteInformation(location: '/')),
              )
            : Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );

        return MaterialApp(
          home: widget,
          // theme: ThemeData(primarySwatch: Colors.white),
        );
      },
    );
  }
}

class BCRouteDelegate extends RouterDelegate<BCRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BCRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  BCRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    BCNavigator.getInstance().registerNavigateChangeListener(
        RouteChangeListener(navigateTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.detail) {
        this.id = args != null ? args['id'] : '';
      }
      notifyListeners();
    }));
  }
  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = [];
  BCRoutePath path = BCRoutePath.home();
  String id = '0';

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> temPages = pages;
    if (index > -1) {
      /// 要打开的页面已经在堆栈中存在 将该页面和他上面的页面进行出栈
      /// 这里要求栈中只允许有一个同样的实例
      temPages = temPages.sublist(0, index);
    }
    var page;
    print(routeStatus);
    if (routeStatus == RouteStatus.home) {
      pages.clear();
      page = pageWrap(HomePage());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(DetailPage(id));
    }

    temPages = [...temPages, page];
    pages = temPages;

    return WillPopScope(
        child: Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (route, result) {
            // 拦截操作
            if (route.settings is MaterialPage) {}
            if (!route.didPop(result)) {
              return false;
            }
            pages.removeLast();
            return true;
          },
        ),
        // fix 安卓物理返回键
        onWillPop: () async => !await navigatorKey.currentState!.maybePop());
  }

  @override
  Future<void> setNewRoutePath(BCRoutePath path) async {
    this.path = path;
  }

  /// 路由拦截
  RouteStatus get routeStatus {
    if (id != '0') {
      return RouteStatus.detail;
    }
    return _routeStatus;
  }
}

/// 可缺省
class BCRouteInfomationParser extends RouteInformationParser<BCRoutePath> {
  @override
  Future<BCRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '');
    if (uri.pathSegments.length == 0) {
      return BCRoutePath.home();
    }
    return BCRoutePath.detail();
  }
}

/// 定义路由数据
class BCRoutePath {
  final String location;
  BCRoutePath.home() : location = '/';
  BCRoutePath.detail() : location = '/detail';
}

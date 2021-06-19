import 'package:bc_flutter/navigator/bottom_navigator.dart';
import 'package:bc_flutter/pages/detail_page.dart';
import 'package:flutter/material.dart';

typedef RouteChangeListener(RouteStatusInfo current, RouteStatusInfo pre);

/// 创建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

/// 获取页面在堆栈的下标
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

/// 路由状态
enum RouteStatus {
  ///首页
  home,

  /// 详情
  detail,

  /// 未知页面
  unknown
}

/// 获取路由状态
RouteStatus getStatus(MaterialPage page) {
  if (page.child is BottomNavigator) {
    return RouteStatus.home;
  } else if (page.child is DetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknown;
  }
}

/// 路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget widget;

  RouteStatusInfo(this.routeStatus, this.widget);
}

class BCNavigator extends _RouteJumpListener {
  BCNavigator._();

  static BCNavigator _navigator = BCNavigator._();

  List<RouteChangeListener> _listeners = [];

  late RouteJumpListener _routeJumpListener;
  // 首页底部tab
  late RouteStatusInfo _bottomTab;

  late RouteStatusInfo _current;

  static BCNavigator getInstance() {
    return _navigator;
  }

  /// 底部导航切换监听
  void onBottomTabChange(int index, Widget page) {
    _bottomTab = RouteStatusInfo(RouteStatus.home, page);
    _notify(_bottomTab);
  }

  /// 添加监听
  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// 移除监听
  void removeListener(RouteChangeListener listener) {
    _listeners.remove(listener);
  }

  /// 出发监听执行
  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) {
      return;
    }
    var current =
        RouteStatusInfo(getStatus(currentPages.last), currentPages.last.child);
    _notify(current);
  }

  /// 注册跳转监听
  void registerNavigateChangeListener(RouteJumpListener routeJumpListener) {
    this._routeJumpListener = routeJumpListener;
  }

  /// 跳转
  @override
  void onNavigateTo(RouteStatus routeStatus, {Map<dynamic, dynamic>? args}) {
    _routeJumpListener.navigateTo(routeStatus, args: args ?? {});
  }

  /// 实际监听执行方法
  void _notify(RouteStatusInfo current) {
    if (current.widget is BottomNavigator && _bottomTab != null) {
      current = _bottomTab;
    }
    _listeners.forEach((listener) {
      listener(current, _current);
    });
    _current = current;
  }
}

abstract class _RouteJumpListener {
  void onNavigateTo(RouteStatus routeStatus, {Map<dynamic, dynamic> args});
}

typedef NavigateTo = void Function(RouteStatus routeStatus,
    {Map<dynamic, dynamic> args});

class RouteJumpListener {
  late final NavigateTo navigateTo;
  RouteJumpListener({navigateTo}) {
    this.navigateTo = navigateTo;
  }
}

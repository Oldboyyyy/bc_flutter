import 'package:bc_flutter/pages/detail_page.dart';
import 'package:bc_flutter/pages/home_page.dart';
import 'package:flutter/material.dart';

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
  if (page.child is HomePage) {
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

class BCNavigator extends _RouteChangeListener {
  BCNavigator._();

  static BCNavigator _navigator = BCNavigator._();

  late RouteChangeListener _routeChangeListener;
  static BCNavigator getInstance() {
    return _navigator;
  }

  void registerNavigateChangeListener(RouteChangeListener routeChangeListener) {
    this._routeChangeListener = routeChangeListener;
  }

  @override
  void onNavigateTo(RouteStatus routeStatus, {Map<dynamic, dynamic>? args}) {
    _routeChangeListener.navigateTo(routeStatus, args: args ?? {});
  }
}

abstract class _RouteChangeListener {
  void onNavigateTo(RouteStatus routeStatus, {Map<dynamic, dynamic> args});
}

typedef NavigateTo = void Function(RouteStatus routeStatus,
    {Map<dynamic, dynamic> args});

class RouteChangeListener {
  late final NavigateTo navigateTo;
  RouteChangeListener({navigateTo}) {
    this.navigateTo = navigateTo;
  }
}

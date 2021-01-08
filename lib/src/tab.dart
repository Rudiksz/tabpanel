import '../tabpanel.dart';
import 'tab_panel.dart';
import 'package:flutter/material.dart' hide Tab;
import 'package:mobx/mobx.dart';

part 'tab.g.dart';

class Tab = TabBase with _$Tab;

abstract class TabBase with Store {
  String id = uuid.v1().toString();

  TabPanel panel;

  TabBase({
    @required this.panel,
    List<AppPage> pages,
    this.locked = false,
  }) {
    this.pages = pages?.asObservable() ?? <AppPage>[].asObservable();
  }

  @observable
  bool locked = false;

  @observable
  ObservableList<AppPage> pages = <AppPage>[].asObservable();

  @action
  void toggleLock() => locked = !locked;

  @action
  void pop() {
    if (pages.length > 1) pages.removeLast();
  }

  @action
  void push(
    Widget page, {
    IconData iconData = Icons.tab,
    Widget icon,
    String title = '',
    bool forceNewTab = false,
  }) =>
      panel.pushPage(
        page: page,
        icon: icon,
        iconData: iconData,
        title: title,
        forceNewTab: forceNewTab,
      );
}

class AppPage = AppPageBase with _$AppPage;

abstract class AppPageBase with Store {
  String id = uuid.v1().toString();

  AppPageBase({
    this.title = 'Home',
    this.iconData = Icons.tab,
    this.icon,
    this.body,
  });

  @observable
  IconData iconData;

  @observable
  Widget icon;

  @observable
  String title = '';

  @observable
  Widget body;
}

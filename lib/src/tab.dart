import '../tabpanel.dart';
import 'tab_panel.dart';
import 'package:flutter/material.dart' hide Tab;
import 'package:mobx/mobx.dart';

part 'tab.g.dart';

/// Stores the state of a tab, including its page stack
class Tab = TabBase with _$Tab;

abstract class TabBase with Store {
  String id = uuid.v1().toString();

  /// The panel this tab belongs to
  TabPanel panel;

  TabBase({
    required this.panel,
    List<Widget> pages = const [],
    this.locked = false,
  }) {
    this.pages = pages.asObservable();
  }

  /// When locked, the tab cannot be closed by conventional means
  @observable
  bool locked = false;

  /// The pages if this tab
  @observable
  ObservableList<Widget> pages = <Widget>[].asObservable();

  @action
  void toggleLock() => locked = !locked;

  /// Pop the last page from the stack
  @action
  void pop() {
    if (pages.length > 1) pages.removeLast();
  }

  /// Push a new page to the stack
  @action
  void push(
    Widget page, {
    bool forceNewTab = false,
  }) =>
      panel.pushPage(
        page: page,
        forceNewTab: forceNewTab,
      );
}

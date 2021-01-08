import 'dart:math';

import 'package:flutter/material.dart' hide Tab;
import 'package:mobx/mobx.dart';

import '../tabpanel.dart';
import 'tab.dart';

part 'tab_panel.g.dart';

class TabPanel = TabPanelBase with _$TabPanel;

abstract class TabPanelBase with Store {
  String id = uuid.v4().toString();

  TabPanel parent;

  /// The layout constraints are used to check when to recalculate the sizes of the
  /// child panels
  BoxConstraints constraints;

  TabPanelBase({
    this.parent,
    this.panels,
    this.panelSizes,
    List<Tab> tabs,
    this.axis = Axis.horizontal,
    this.defaultPage,
  }) {
    this.tabs = tabs?.asObservable() ?? <Tab>[].asObservable();
  }

  Widget defaultPage;

  /// Child panels
  @observable
  ObservableList<TabPanel> panels;

  /// The sizes of the child panels
  @observable
  ObservableList<double> panelSizes;

  /// Tabs of this panel. Ignored if [panels] is not empty.
  @observable
  ObservableList<Tab> tabs = <Tab>[].asObservable();

  /// The index of the selected tab
  @observable
  int selectedTab = 0;

  @observable
  Axis axis = Axis.horizontal;

  /// Splits the current panel in two, moving the tabs to the one specified by [position]
  @action
  void splitPanel({
    String panelId,
    String tabId,
    Axis axis,
    TabPosition position,
  }) {
    final newPanel = TabPanel(parent: this, defaultPage: defaultPage);

    // If the panel has a parent with the same axis as the one requested,
    // we insert a new panel into the parent instead of splitting this one
    if (parent != null &&
        parent.axis == axis &&
        (parent.panels?.isNotEmpty ?? false)) {
      newPanel.parent = parent;
      final index = parent.panels.indexWhere((element) => element.id == id);
      if (index == -1) {
        parent.panels.add(newPanel);
      } else {
        parent.panels.insert(index, newPanel);
      }
      return;
    }

    if (panels?.isEmpty ?? true) {
      this.axis = axis;

      // Create a copy of the current panel, and update its tabs to point to the new panel
      final oldPanel = TabPanel(
        parent: this,
        tabs: tabs,
        defaultPage: defaultPage,
      );
      oldPanel.tabs.forEach((element) => element.panel = oldPanel);

      // Set the two panels depending on the position
      panels = position == TabPosition.after
          ? <TabPanel>[oldPanel, newPanel].asObservable()
          : <TabPanel>[newPanel, oldPanel].asObservable();

      // This panel now has child panels so we clear the tabs
      tabs = <Tab>[].asObservable();
      selectedTab = 0;
    }
  }

  @action
  void selectTab(String id) =>
      selectedTab = tabs.indexWhere((element) => element.id == id);

  @action
  void closeTab(String id) {
    tabs.removeWhere((t) => t.id == id);
    selectedTab = tabs.isNotEmpty ? min(selectedTab, tabs.length - 1) : 0;
  }

  @action
  void closeOtherTabs(String id) {
    tabs.removeWhere((t) => !t.locked && t.id != id);
    selectedTab = tabs.indexWhere((t) => t.id == id);
  }

  @action
  void closeRight(String id) {
    final index = tabs.indexWhere((t) => t.id == id);
    if (index == tabs.length - 1) return;
    tabs.removeWhere((t) => !t.locked && tabs.indexOf(t) > index);
    selectedTab = index;
  }

  @action
  void closeLeft(String id) {
    final index = tabs.indexWhere((t) => t.id == id);
    if (index == 0) return;
    tabs.removeWhere((t) => !t.locked && tabs.indexOf(t) < index);
    selectedTab = tabs.indexWhere((t) => t.id == id);
  }

  @action
  void closePanel(String id) {
    parent?.panels?.removeWhere((element) => element.id == id);

    // If only one child panel is left, then we "flatten" it
    if (parent?.panels?.length == 1) {
      parent.tabs = parent.panels.first.tabs;
      parent.selectedTab = parent.panels.first.selectedTab;
      parent.panels = null;
    }
  }

  bool willAcceptTab(Tab tab) =>
      (panels?.isEmpty ?? true) && id != tab.panel.id;

  void acceptTab(Tab tab) {
    tab.panel.closeTab(tab.id);
    tabs.add(tab);
    selectedTab = tabs.length - 1;
    tab.panel = this;
  }

  @action
  void moveTab(String tabId, TabPosition position) {
    position ??= TabPosition.after;
    final tabIndex = tabs.indexWhere((t) => t.id == tabId);
    final panelIndex = parent.panels.indexWhere((p) => p.id == id);

    if (tabIndex == -1 && panelIndex == -1 ||
        (position == TabPosition.after && panelIndex == parent.panels.length) ||
        (position == TabPosition.before && panelIndex == 0)) {
      return;
    }

    final newPanel = parent.panels[
        position == TabPosition.before ? panelIndex - 1 : panelIndex + 1];

    newPanel.tabs.add(tabs[tabIndex]);
    tabs[tabIndex].panel = newPanel;
    newPanel.selectedTab = newPanel.tabs.length - 1;
    tabs.removeAt(tabIndex);
    selectedTab = max(0, min(selectedTab, tabs.length - 1));
  }

  @action
  void newTab({
    Widget page,
    IconData iconData = Icons.tab,
    Widget icon,
    String title = '',
    String tabId = '',
    TabPosition position = TabPosition.after,
  }) {
    final index =
        tabId.isNotEmpty ? tabs.indexWhere((e) => e.id == tabId) : selectedTab;

    selectedTab = index == -1
        ? (position == TabPosition.after ? tabs.length + 1 : 0)
        : index + (position == TabPosition.after ? 1 : 0);

    // Make sure the value is in the proper range
    selectedTab = max(0, min(selectedTab, tabs.length));

    tabs.insert(
      selectedTab,
      Tab(
        panel: this,
        pages: [
          AppPage(
            title: title,
            iconData: iconData,
            icon: icon,
            body: page ?? defaultPage,
          )
        ].asObservable(),
      ),
    );
  }

  @action
  void pushPage({
    Widget page,
    IconData iconData = Icons.tab,
    Widget icon,
    String title = '',
    bool forceNewTab = false,
  }) {
    if (tabs.isNotEmpty && !tabs[selectedTab].locked && !forceNewTab) {
      tabs[selectedTab].pages.add(AppPage(
            title: title,
            iconData: iconData,
            icon: icon,
            body: page ?? defaultPage,
          ));
    } else {
      newTab(
        iconData: iconData,
        icon: icon,
        title: title,
        page: page ?? defaultPage,
      );
    }
  }

  @action
  void updateSize(int index, DragUpdateDetails dragDetails) {
    final delta =
        axis == Axis.vertical ? dragDetails.delta.dy : dragDetails.delta.dx;

    if (panelSizes[index] + delta > 50 && panelSizes[index + 1] - delta > 50) {
      panelSizes[index] += delta;
      panelSizes[index + 1] -= delta;
    }
  }
}

/// Used to specify where new tab panels or tabs should be inserted relative to the current one
enum TabPosition { before, after }

mixin TabPageMixin {
  final Widget icon = Icon(null);
  final IconData iconData = null;
  final String title = '';
}

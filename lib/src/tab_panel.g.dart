// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_panel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TabPanel on TabPanelBase, Store {
  final _$panelsAtom = Atom(name: 'TabPanelBase.panels');

  @override
  ObservableList<TabPanel> get panels {
    _$panelsAtom.reportRead();
    return super.panels;
  }

  @override
  set panels(ObservableList<TabPanel> value) {
    _$panelsAtom.reportWrite(value, super.panels, () {
      super.panels = value;
    });
  }

  final _$panelSizesAtom = Atom(name: 'TabPanelBase.panelSizes');

  @override
  ObservableList<double> get panelSizes {
    _$panelSizesAtom.reportRead();
    return super.panelSizes;
  }

  @override
  set panelSizes(ObservableList<double> value) {
    _$panelSizesAtom.reportWrite(value, super.panelSizes, () {
      super.panelSizes = value;
    });
  }

  final _$tabsAtom = Atom(name: 'TabPanelBase.tabs');

  @override
  ObservableList<Tab> get tabs {
    _$tabsAtom.reportRead();
    return super.tabs;
  }

  @override
  set tabs(ObservableList<Tab> value) {
    _$tabsAtom.reportWrite(value, super.tabs, () {
      super.tabs = value;
    });
  }

  final _$selectedTabAtom = Atom(name: 'TabPanelBase.selectedTab');

  @override
  int get selectedTab {
    _$selectedTabAtom.reportRead();
    return super.selectedTab;
  }

  @override
  set selectedTab(int value) {
    _$selectedTabAtom.reportWrite(value, super.selectedTab, () {
      super.selectedTab = value;
    });
  }

  final _$axisAtom = Atom(name: 'TabPanelBase.axis');

  @override
  Axis get axis {
    _$axisAtom.reportRead();
    return super.axis;
  }

  @override
  set axis(Axis value) {
    _$axisAtom.reportWrite(value, super.axis, () {
      super.axis = value;
    });
  }

  final _$TabPanelBaseActionController = ActionController(name: 'TabPanelBase');

  @override
  void splitPanel(
      {String panelId, String tabId, Axis axis, TabPosition position}) {
    final _$actionInfo = _$TabPanelBaseActionController.startAction(
        name: 'TabPanelBase.splitPanel');
    try {
      return super.splitPanel(
          panelId: panelId, tabId: tabId, axis: axis, position: position);
    } finally {
      _$TabPanelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectTab(String id) {
    final _$actionInfo = _$TabPanelBaseActionController.startAction(
        name: 'TabPanelBase.selectTab');
    try {
      return super.selectTab(id);
    } finally {
      _$TabPanelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeTab(String id) {
    final _$actionInfo = _$TabPanelBaseActionController.startAction(
        name: 'TabPanelBase.closeTab');
    try {
      return super.closeTab(id);
    } finally {
      _$TabPanelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeOtherTabs(String id) {
    final _$actionInfo = _$TabPanelBaseActionController.startAction(
        name: 'TabPanelBase.closeOtherTabs');
    try {
      return super.closeOtherTabs(id);
    } finally {
      _$TabPanelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeRight(String id) {
    final _$actionInfo = _$TabPanelBaseActionController.startAction(
        name: 'TabPanelBase.closeRight');
    try {
      return super.closeRight(id);
    } finally {
      _$TabPanelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeLeft(String id) {
    final _$actionInfo = _$TabPanelBaseActionController.startAction(
        name: 'TabPanelBase.closeLeft');
    try {
      return super.closeLeft(id);
    } finally {
      _$TabPanelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closePanel(String id) {
    final _$actionInfo = _$TabPanelBaseActionController.startAction(
        name: 'TabPanelBase.closePanel');
    try {
      return super.closePanel(id);
    } finally {
      _$TabPanelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void moveTab(String tabId, TabPosition position) {
    final _$actionInfo = _$TabPanelBaseActionController.startAction(
        name: 'TabPanelBase.moveTab');
    try {
      return super.moveTab(tabId, position);
    } finally {
      _$TabPanelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newTab(
      {Widget page,
      IconData iconData = Icons.tab,
      Widget icon,
      String title = '',
      String tabId = '',
      TabPosition position = TabPosition.after}) {
    final _$actionInfo =
        _$TabPanelBaseActionController.startAction(name: 'TabPanelBase.newTab');
    try {
      return super.newTab(
          page: page,
          iconData: iconData,
          icon: icon,
          title: title,
          tabId: tabId,
          position: position);
    } finally {
      _$TabPanelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void pushPage(
      {Widget page,
      IconData iconData = Icons.tab,
      Widget icon,
      String title = '',
      bool forceNewTab = false}) {
    final _$actionInfo = _$TabPanelBaseActionController.startAction(
        name: 'TabPanelBase.pushPage');
    try {
      return super.pushPage(
          page: page,
          iconData: iconData,
          icon: icon,
          title: title,
          forceNewTab: forceNewTab);
    } finally {
      _$TabPanelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateSize(int index, DragUpdateDetails dragDetails) {
    final _$actionInfo = _$TabPanelBaseActionController.startAction(
        name: 'TabPanelBase.updateSize');
    try {
      return super.updateSize(index, dragDetails);
    } finally {
      _$TabPanelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
panels: ${panels},
panelSizes: ${panelSizes},
tabs: ${tabs},
selectedTab: ${selectedTab},
axis: ${axis}
    ''';
  }
}

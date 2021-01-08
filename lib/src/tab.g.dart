// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Tab on TabBase, Store {
  final _$lockedAtom = Atom(name: 'TabBase.locked');

  @override
  bool get locked {
    _$lockedAtom.reportRead();
    return super.locked;
  }

  @override
  set locked(bool value) {
    _$lockedAtom.reportWrite(value, super.locked, () {
      super.locked = value;
    });
  }

  final _$pagesAtom = Atom(name: 'TabBase.pages');

  @override
  ObservableList<AppPage> get pages {
    _$pagesAtom.reportRead();
    return super.pages;
  }

  @override
  set pages(ObservableList<AppPage> value) {
    _$pagesAtom.reportWrite(value, super.pages, () {
      super.pages = value;
    });
  }

  final _$TabBaseActionController = ActionController(name: 'TabBase');

  @override
  void toggleLock() {
    final _$actionInfo =
        _$TabBaseActionController.startAction(name: 'TabBase.toggleLock');
    try {
      return super.toggleLock();
    } finally {
      _$TabBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void pop() {
    final _$actionInfo =
        _$TabBaseActionController.startAction(name: 'TabBase.pop');
    try {
      return super.pop();
    } finally {
      _$TabBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void push(Widget page,
      {IconData iconData = Icons.tab,
      Widget icon,
      String title = '',
      bool forceNewTab = false}) {
    final _$actionInfo =
        _$TabBaseActionController.startAction(name: 'TabBase.push');
    try {
      return super.push(page,
          iconData: iconData,
          icon: icon,
          title: title,
          forceNewTab: forceNewTab);
    } finally {
      _$TabBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
locked: ${locked},
pages: ${pages}
    ''';
  }
}

mixin _$AppPage on AppPageBase, Store {
  final _$iconDataAtom = Atom(name: 'AppPageBase.iconData');

  @override
  IconData get iconData {
    _$iconDataAtom.reportRead();
    return super.iconData;
  }

  @override
  set iconData(IconData value) {
    _$iconDataAtom.reportWrite(value, super.iconData, () {
      super.iconData = value;
    });
  }

  final _$iconAtom = Atom(name: 'AppPageBase.icon');

  @override
  Widget get icon {
    _$iconAtom.reportRead();
    return super.icon;
  }

  @override
  set icon(Widget value) {
    _$iconAtom.reportWrite(value, super.icon, () {
      super.icon = value;
    });
  }

  final _$titleAtom = Atom(name: 'AppPageBase.title');

  @override
  String get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  final _$bodyAtom = Atom(name: 'AppPageBase.body');

  @override
  Widget get body {
    _$bodyAtom.reportRead();
    return super.body;
  }

  @override
  set body(Widget value) {
    _$bodyAtom.reportWrite(value, super.body, () {
      super.body = value;
    });
  }

  @override
  String toString() {
    return '''
iconData: ${iconData},
icon: ${icon},
title: ${title},
body: ${body}
    ''';
  }
}

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
  ObservableList<Widget> get pages {
    _$pagesAtom.reportRead();
    return super.pages;
  }

  @override
  set pages(ObservableList<Widget> value) {
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
  void push(Widget page, {bool forceNewTab = false}) {
    final _$actionInfo =
        _$TabBaseActionController.startAction(name: 'TabBase.push');
    try {
      return super.push(page, forceNewTab: forceNewTab);
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

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final _defaultTabPanelTheme = const TabPanelThemeData();

/// Defines the visual properties of [MaterialBanner] widgets.
///
/// Descendant widgets obtain the current [TabPanelThemeData] object using
/// `TabPanelTheme.of(context)`. Instances of [TabPanelThemeData]
/// can be customized with [TabPanelThemeData.copyWith].
@immutable
class TabPanelThemeData with Diagnosticable {
  /// Creates a theme that can be used for [TabPanelTheme] or
  /// [ThemeData.bannerTheme].
  const TabPanelThemeData({
    this.dividerColor,
    this.dividerWidth = 4.0,
  });

  /// The color of the divider which acts as a drag handle to resize the panel.
  final Color dividerColor;

  /// The color of the divider which acts as a drag handle to resize the panel.
  final double dividerWidth;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  TabPanelThemeData copyWith({
    Color dividerColor,
    double dividerWidth,
  }) {
    return TabPanelThemeData(
      dividerColor: dividerColor ?? this.dividerColor,
      dividerWidth: dividerWidth ?? this.dividerWidth,
    );
  }

  /// Linearly interpolate between two Banner themes.
  ///
  /// The argument `t` must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static TabPanelThemeData lerp(
      TabPanelThemeData a, TabPanelThemeData b, double t) {
    return TabPanelThemeData(
        dividerColor: Color.lerp(a?.dividerColor, b?.dividerColor, t) ??
            Colors.transparent,
        dividerWidth: lerpDouble(a?.dividerWidth, b?.dividerWidth, t) ?? 4);
  }

  @override
  int get hashCode {
    return hashValues(dividerColor, 0);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is TabPanelThemeData &&
        other.dividerColor == dividerColor &&
        other.dividerWidth == dividerWidth;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ColorProperty('dividerColor', dividerColor, defaultValue: null));
    // TODO add all new properties...
  }
}

/// An inherited widget that defines the configuration for
/// [MaterialBanner]s in this widget's subtree.
///
/// Values specified here are used for [MaterialBanner] properties that are not
/// given an explicit non-null value.
class TabPanelTheme extends InheritedTheme {
  /// Creates a banner theme that controls the configurations for
  /// [MaterialBanner]s in its widget subtree.
  const TabPanelTheme({
    Key key,
    this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  /// The properties for descendant [MaterialBanner] widgets.
  final TabPanelThemeData data;

  /// The closest instance of this class's [data] value that encloses the given
  /// context.
  ///
  /// If there is no ancestor, it returns [ThemeData.bannerTheme]. Applications
  /// can assume that the returned value will not be null.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// TabPanelThemeData theme = TabPanelTheme.of(context);
  /// ```
  static TabPanelThemeData of(BuildContext context) {
    final bannerTheme =
        context.dependOnInheritedWidgetOfExactType<TabPanelTheme>();
    return bannerTheme?.data ?? _defaultTabPanelTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return TabPanelTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(TabPanelTheme oldWidget) => data != oldWidget.data;
}

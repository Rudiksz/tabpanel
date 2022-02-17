import 'dart:math';

import 'package:flutter/material.dart' hide Tab;
import 'package:mobx/mobx.dart';

import '../tabpanel.dart';

part 'tab_panel.g.dart';

class TabPanel = TabPanelBase with _$TabPanel;

abstract class TabPanelBase with Store {
  @observable
  String id = uuid.v4().toString();

  /// The parent panel
  TabPanel? parent;

  /// The initial flex factor to use when this panel is a child panel. Defaults to 1
  double flex = 1;

  /// The layout constraints are used to check when to recalculate the sizes of the
  /// child panels
  BoxConstraints? constraints;

  TabPanelBase({
    this.parent,
    List<TabPanel> panels = const <TabPanel>[],
    List<Tab> tabs = const <Tab>[],
    this.axis = Axis.horizontal,
    required this.defaultPage,
    this.flex = 1,
    this.body,
  })  : tabs = tabs.asObservable(),
        panels = panels.asObservable();

  /// Widget to display when a new tab is opened in this tab
  Widget defaultPage;

  // Widget to display when a new tab is opened in this tab
  Widget? body;

  /// Child panels
  @observable
  ObservableList<TabPanel> panels;

  /// The sizes of the child panels
  @observable
  ObservableList<double>? panelSizes;

  /// Tabs of this panel. Ignored if [panels] is not empty.
  @observable
  ObservableList<Tab> tabs = <Tab>[].asObservable();

  /// The index of the selected tab
  @observable
  int selectedTab = 0;

  /// The axis along which the child panel will be rendered
  @observable
  Axis axis = Axis.horizontal;

  /// Splits the current panel in two, moving the tabs to the one specified by [position]
  @action
  void splitPanel({
    required String panelId,
    String? tabId,
    Axis axis = Axis.horizontal,
    TabPosition? position,
  }) {
    final newPanel =
        TabPanel(parent: this as TabPanel, defaultPage: defaultPage);

    // If the panel has a parent with the same axis as the one requested,
    // we insert a new panel into the parent instead of splitting this one
    if (parent != null &&
        parent?.axis == axis &&
        (parent?.panels.isNotEmpty ?? false)) {
      newPanel.parent = parent;
      final index = parent!.panels.indexWhere((element) => element.id == id);
      if (index == -1) {
        parent!.panels.add(newPanel);
      } else {
        parent!.panels.insert(index, newPanel);
      }
      return;
    }

    if (panels.isEmpty) {
      this.axis = axis;

      // Create a copy of the current panel, and update its tabs to point to the new panel
      final oldPanel = TabPanel(
        parent: this as TabPanel,
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

  /// Close the tab with the [id]. This does not respect the [locked] values
  @action
  void closeTab(String id) {
    tabs.removeWhere((t) => t.id == id);
    selectedTab = tabs.isNotEmpty ? min(selectedTab, tabs.length - 1) : 0;
  }

  /// Close all tabs other than the one having [id]. Locked tabs are not closed.
  @action
  void closeOtherTabs(String id) {
    tabs.removeWhere((t) => !t.locked && t.id != id);
    selectedTab = tabs.indexWhere((t) => t.id == id);
  }

  /// Close all tabs to the right of the one with [id]. Locked tabs are not closed.
  @action
  void closeRight(String id) {
    final index = tabs.indexWhere((t) => t.id == id);
    if (index == tabs.length - 1) return;
    tabs.removeWhere((t) => !t.locked && tabs.indexOf(t) > index);
    selectedTab = index;
  }

  /// Close all tabs to the left of the one with [id]. Locked tabs are not closed.
  @action
  void closeLeft(String id) {
    final index = tabs.indexWhere((t) => t.id == id);
    if (index == 0) return;
    tabs.removeWhere((t) => !t.locked && tabs.indexOf(t) < index);
    selectedTab = tabs.indexWhere((t) => t.id == id);
  }

  /// Close the panel including all its tabs
  @action
  void closePanel() {
    final parent = this.parent;
    if (parent == null) return;

    parent.panels.removeWhere((element) => element.id == id);

    // If only one child panel is left, then we "flatten" it
    if (parent.panels.length == 1) {
      // Move the tab
      parent.tabs = parent.panels.first.tabs;
      parent.selectedTab = parent.panels.first.selectedTab;

      // Move the panel one level "up"
      parent.axis = parent.panels.first.axis;
      parent.panels.first.parent = parent.parent;

      parent.panels = parent.panels.first.panels;
      parent.panels.forEach((p) => p.parent = parent);
      parent.panelSizes = <double>[].asObservable();
    }
  }

  /// Callback to check if a dragged [tab] is acceptable by the current panel.
  bool willAcceptTab(Tab? tab) => panels.isEmpty && id != tab?.panel.id;

  /// Move the dragged [tab] to this panel.
  void acceptTab(Tab tab) {
    tab.panel.closeTab(tab.id);
    tabs.add(tab);
    selectedTab = tabs.length - 1;
    tab.panel = this as TabPanel;
  }

  /// Open a new tab with [page] as the body.
  @action
  void newTab({
    Widget? page,
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
        panel: this as TabPanel,
        pages: [page ?? defaultPage].asObservable(),
      ),
    );
  }

  /// Push a [page] to the current tab.
  @action
  void pushPage({
    Widget? page,
    bool forceNewTab = false,
  }) {
    if (tabs.isNotEmpty && !tabs[selectedTab].locked && !forceNewTab) {
      tabs[selectedTab].pages.add(page ?? defaultPage);
    } else {
      newTab(page: page ?? defaultPage);
    }
  }

  /// Calculates the sizes of the child panel when they change, or when the parent
  /// viewport dimensions change
  void calculatePanelSizes(BoxConstraints constraints, double dividerWidth) {
    if (panels.isEmpty) return;

    final axisSize =
        axis == Axis.horizontal ? constraints.maxWidth : constraints.maxHeight;

    // Calculate panel sizes, if we have to
    // Calculate new sizes if:
    //  1. it's the first layout or
    //  2. the number of panels changed

    if (panelSizes == null ||
        panelSizes!.isEmpty ||
        panelSizes!.length != panels.length) {
      panelSizes = _computeInitialSizes(axisSize, dividerWidth);
    }
    // Otherwise, resize the panels keeping their aspect ratios
    else {
      var newPanelSize = (axis == Axis.horizontal
          ? constraints.maxWidth
          : constraints.maxHeight);

      final panelSize = (axis == Axis.horizontal
              ? this.constraints?.maxWidth
              : this.constraints?.maxHeight) ??
          newPanelSize;
      if (newPanelSize != panelSize) {
        // To account for rounding errors, the last panel should take up
        // the remaining available space, this accumulates the amount of space used up
        var usedSize = 0.0;
        for (var i = 0; i < panelSizes!.length; i++) {
          if (i != panelSizes!.length - 1) {
            panelSizes![i] = panelSizes![i] * newPanelSize / panelSize;
            usedSize += panelSizes![i];
          } else {
            panelSizes![i] =
                newPanelSize - dividerWidth * (panels.length - 1) - usedSize;
          }
        }
      }
    }
  }

  ObservableList<double> _computeInitialSizes(
    double axisSize,
    double dividerWidth,
  ) {
    final availableSpace = axisSize - dividerWidth * (panels.length - 1);
    final totalFlex = panels.fold<double>(0.0, (v, p) => v + p.flex);
    var sizes = List.filled(panels.length, availableSpace / panels.length);
    if (totalFlex != 0 && totalFlex != panels.length) {
      final spacePerFlex = availableSpace / totalFlex;
      var allocatedSpace = 0.0;
      for (var i = 0; i < panels.length - 1; i++) {
        sizes[i] = panels[i].flex * spacePerFlex;
        allocatedSpace += sizes[i];
      }

      var last = panels.length - 1;
      sizes[last] = availableSpace - allocatedSpace;
    }

    return sizes.asObservable();
  }

  /// Resize the child panels when the user is draggin the using the panel dividers.
  @action
  void updateSize(int index, DragUpdateDetails dragDetails) {
    if (panelSizes == null || panelSizes!.length <= index) return;

    final delta =
        axis == Axis.vertical ? dragDetails.delta.dy : dragDetails.delta.dx;

    if (panelSizes![index] + delta > 50 &&
        panelSizes![index + 1] - delta > 50) {
      panelSizes![index] += delta;
      panelSizes![index + 1] -= delta;
    }
  }
}

/// Used to specify where new tab panels or tabs should be inserted relative to the current one
enum TabPosition { before, after }

/// Mixin to set the [icon], and [title] of the tab when displaying the widget in the body.
///
///
/// Example:
/// ```
/// class PageB extends StatelessWidget with TabPageMixin {
///   @override
///   final String title = 'PageB';
///
///   @override
///   final Icon icon = const Icon(Icons.dashboard);
///
///   @override
///   final IconData iconData = Icons.dashboard;
///
///   @override
///   Widget build(BuildContext context) {
///     return Placeholder();
///   }
/// }
/// ```
mixin TabPageMixin {
  final Widget icon = Icon(null);
  final IconData? iconData = null;
  final String title = '';
}

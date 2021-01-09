import 'package:flutter/material.dart' hide Tab;
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tabpanel/src/tab_panel_theme.dart';
import 'context_menu.dart';
import 'tab_panel.dart';

import 'tab.dart';
import 'tab_widget.dart';

/// Displays a tab panel. Tab panels can be split horizontally or vertically
/// and can nest indefinitely.
///
/// You should hold on to a reference of the root panel separately to prevent
/// hot-reload from resetting your state.
///
/// ```dart
/// void main() async {
///   final tabPanel = TabPanel(defaultPage: YourDefaultPage());

///   runApp(
///     MaterialApp(
///       home: TabPanelWidget(tabPanel),
///     ),
///   );
/// }
/// ```
class TabPanelWidget extends StatelessWidget {
  final TabPanel panel;

  const TabPanelWidget(
    this.panel, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget<Tab>(
      onWillAccept: panel.willAcceptTab,
      onAccept: panel.acceptTab,
      builder: (_, __, ___) => Material(
        child: Observer(builder: (_) {
          final panels = panel.panels;
          final panelsCount = panels?.length ?? 0;

          if (panels?.isNotEmpty ?? false) {
            return LayoutBuilder(builder: (context, constraints) {
              final tabPanelTheme = TabPanelTheme.of(context);

              panel.calculatePanelSizes(
                  constraints, tabPanelTheme.dividerWidth);

              // Store the constraints for later
              panel.constraints = constraints;

              // Create the divider widget
              final divider = panel.axis == Axis.vertical
                  ? MouseRegion(
                      cursor: SystemMouseCursors.resizeRow,
                      child: Container(
                        height: tabPanelTheme.dividerWidth,
                        width: constraints.maxWidth,
                        color: tabPanelTheme.dividerColor ??
                            Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                      ),
                    )
                  : MouseRegion(
                      cursor: SystemMouseCursors.resizeColumn,
                      child: Container(
                        width: tabPanelTheme.dividerWidth,
                        height: constraints.maxHeight,
                        color: tabPanelTheme.dividerColor ??
                            Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                      ),
                    );

              // Create the children panel widgets, separated by the dividers
              final children = <Widget>[];
              for (var i = 0; i < panelsCount; i++) {
                children.add(
                  Observer(builder: (_) {
                    final size = (panel?.panelSizes?.isNotEmpty ?? false)
                        ? panel?.panelSizes[i]
                        : 20.0;
                    return SizedBox(
                      height:
                          panel.axis == Axis.vertical ? size : double.infinity,
                      width: panel.axis == Axis.horizontal
                          ? size
                          : double.infinity,
                      child: i < panels.length
                          ? TabPanelWidget(panels[i])
                          : SizedBox.shrink(),
                    );
                  }),
                );

                if (i != panelsCount - 1) {
                  children.add(
                    Draggable(
                      maxSimultaneousDrags: 1,
                      child: divider,
                      axis: panel.axis,
                      affinity: panel.axis,
                      feedback: SizedBox.shrink(),
                      onDragUpdate: (details) => panel.updateSize(i, details),
                    ),
                  );
                }
              }

              return panel.axis == Axis.horizontal
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    );
            });
          }

          // -- The panel has no children panel, so we render the tabs instead
          final selectedTab =
              panel.tabs.isNotEmpty && panel.selectedTab < panel.tabs.length
                  ? panel.tabs[panel.selectedTab]
                  : null;

          return Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: (selectedTab?.pages?.length ?? 0) > 1
                        ? selectedTab.pop
                        : null,
                  ),
                  // -- TabBar
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: panel.tabs
                            .map((tab) => TabWidget(
                                  tab,
                                  selected: tab.id == selectedTab?.id,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  _panelMenu(context),
                ],
              ),
              Container(
                height: 1,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.2),
              ),
              Expanded(
                child: ParentTab(
                  tab: selectedTab,
                  child: ((selectedTab?.pages?.isNotEmpty ?? false) &&
                          selectedTab?.pages?.last != null)
                      ? selectedTab?.pages?.last
                      : EmptyPanel(panel),
                  // child: selectedTab?.pages?.last?.body ?? EmptyPanel(tabPanel), <- nullsafety version
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  ContextMenu _panelMenu(BuildContext context) {
    return ContextMenu(
      icon: Icon(
        Icons.more_horiz,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      showOnTap: true,
      menuItems: [
        ContextMenuItem(
          title: Text('New Tab'),
          icon: Icon(Icons.edit),
          onPressed: () => panel.newTab(),
        ),
        ContextMenuItem(),
        ContextMenuItem(
          title: Text('Split right'),
          icon: Icon(Icons.arrow_right),
          onPressed: () => panel.splitPanel(
            panelId: panel.id,
            axis: Axis.horizontal,
            position: TabPosition.after,
          ),
        ),
        ContextMenuItem(
          title: Text('Split left'),
          icon: Icon(Icons.arrow_left),
          onPressed: () => panel.splitPanel(
            panelId: panel.id,
            axis: Axis.horizontal,
            position: TabPosition.before,
          ),
        ),
        ContextMenuItem(
          title: Text('Split down'),
          icon: Icon(Icons.arrow_drop_down),
          onPressed: () => panel.splitPanel(
            panelId: panel.id,
            axis: Axis.vertical,
            position: TabPosition.after,
          ),
        ),
        ContextMenuItem(
          title: Text('Split up'),
          icon: Icon(Icons.arrow_drop_up),
          onPressed: () => panel.splitPanel(
            panelId: panel.id,
            axis: Axis.vertical,
            position: TabPosition.before,
          ),
        ),
        if (panel.parent != null) ...[
          ContextMenuItem(),
          ContextMenuItem(
            title: Text('Close'),
            icon: Icon(Icons.close),
            onPressed: panel.closePanel,
          ),
        ],
      ],
    );
  }
}

class ParentTab extends InheritedWidget {
  final Tab tab;
  const ParentTab({
    Key key,
    @required this.tab,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant ParentTab oldWidget) =>
      oldWidget.tab?.id != tab?.id;

  static Tab of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ParentTab>()?.tab;
}

class EmptyPanel extends StatelessWidget {
  final TabPanel tabPanel;
  const EmptyPanel(this.tabPanel);

  @override
  Widget build(BuildContext context) => Container(
        child: FittedBox(
          fit: BoxFit.contain,
          child: InkWell(
            onTap: tabPanel.pushPage,
            child: Icon(Icons.dashboard_customize,
                color: Colors.grey.withOpacity(.2)),
          ),
        ),
      );
}

import 'package:flutter/material.dart' hide Tab;
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:tabpanel/src/tab_panel_theme.dart';
import 'context_menu.dart';
import 'tab_panel.dart';

import 'tab.dart';
import 'tab_widget.dart';

/// Displays a tab panel. Tab panels can be split horizontally or vertically
/// and can nest indefinitely.
///
/// Requires a material ancestor widget.
///
/// You should hold on to a reference of the root panel separately to prevent
/// hotreload from resetting your state.
///
/// ```dart
/// void main() async {
///   final tabPanel = TabPanel();

///   runApp(MaterialApp(
///     debugShowCheckedModeBanner: false,
///     home: HomeWidget(tabPanel: tabPanel),
///   ));
/// }

/// class HomeWidget extends StatelessWidget {
///   const HomeWidget({
///     Key? key,
///     required this.tabPanel,
///   }) : super(key: key);

///   final TabPanel tabPanel;

///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: TabPanelTheme(
///         data: TabPanelThemeData(
///           dividerWidth: 4,
///           dividerColor: Colors.grey,
///         ),
///         child: TabPanelWidget(tabPanel: tabPanel),
///       ),
///     );
///   }
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
      builder: (_, __, ___) => Observer(builder: (_) {
        final panels = panel.panels;
        final panelsCount = panels?.length ?? 0;

        if (panels?.isNotEmpty ?? false) {
          return LayoutBuilder(builder: (context, constraints) {
            final tabPanelTheme = TabPanelTheme.of(context);

            final axisSize = panel.axis == Axis.horizontal
                ? constraints.maxWidth
                : constraints.maxHeight;

            // Calculate panel sizes, if we have to
            if (panels != null) {
              // Calculate new sizes if:
              //  1. it's the first layout or
              //  2. the number of panels changed
              if ((panel.panelSizes?.isEmpty ?? true) ||
                  panel.panelSizes.length != panelsCount) {
                panel.panelSizes = List.filled(
                  panelsCount,
                  (axisSize - tabPanelTheme.dividerWidth * (panelsCount - 1)) /
                      panelsCount,
                ).asObservable();
              }
              // Otherwise, resize the panels keeping their aspect ratios
              else {
                var newAxisSize = (panel.axis == Axis.horizontal
                    ? constraints?.maxWidth
                    : constraints?.maxHeight);
                final panelSize = panel.axis == Axis.horizontal
                    ? panel.constraints?.maxWidth
                    : panel.constraints?.maxHeight;
                if (newAxisSize != panelSize) {
                  // Adjust the new container size to account for the the separators
                  newAxisSize -= tabPanelTheme.dividerWidth * (panelsCount - 1);

                  // To account for rounding errors, the last panel should take up
                  // the remaining available space, this accumulates the amount of space used up
                  var usedSize = 0.0;
                  for (var i = 0; i < panel.panelSizes.length; i++) {
                    if (i != panel.panelSizes.length - 1) {
                      panel.panelSizes[i] =
                          panel.panelSizes[i] * newAxisSize / panelSize;
                      usedSize += panel.panelSizes[i];
                    } else {
                      panel.panelSizes[i] = newAxisSize - usedSize;
                    }
                  }
                }
              }
            }

            // Store the constraints for later
            panel.constraints = constraints;

            // Create the divider widget
            final divider = panel.axis == Axis.vertical
                ? MouseRegion(
                    cursor: SystemMouseCursors.resizeRow,
                    child: Container(
                      height: tabPanelTheme.dividerWidth,
                      width: constraints.maxWidth,
                      color: tabPanelTheme.dividerColor,
                    ),
                  )
                : MouseRegion(
                    cursor: SystemMouseCursors.resizeColumn,
                    child: Container(
                      width: tabPanelTheme.dividerWidth,
                      height: constraints.maxHeight,
                      color: tabPanelTheme.dividerColor,
                    ),
                  );

            // Create the children panel widgets, separated by the dividers
            final children = <Widget>[];
            for (var i = 0; i < panelsCount; i++) {
              children.add(
                Observer(builder: (_) {
                  final size =
                      panel?.panelSizes != null ? panel?.panelSizes[i] : 100.0;
                  return SizedBox(
                    height:
                        panel.axis == Axis.vertical ? size : double.infinity,
                    width:
                        panel.axis == Axis.horizontal ? size : double.infinity,
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
            AppBar(
              automaticallyImplyLeading: false,
              // leadingWidth: 32,
              elevation: 0,
              toolbarHeight: 42,
              titleSpacing: 0,
              leading: IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: (selectedTab?.pages?.length ?? 0) > 1
                    ? selectedTab.pop
                    : null,
              ),
              actions: [_panelMenu(context)],
              title: Row(
                children: [
                  // -- TabBar
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: panel.tabs
                            .map((tab) => AppTabWidget(
                                  tab,
                                  selected: tab.id == selectedTab?.id,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ParentTab(
                tab: selectedTab,
                child: ((selectedTab?.pages?.isNotEmpty ?? false) &&
                        selectedTab?.pages?.last?.body != null)
                    ? selectedTab?.pages?.last?.body
                    : EmptyPanel(panel),
                // child: selectedTab?.pages?.last?.body ?? EmptyPanel(tabPanel), <- nullsafety version
              ),
            ),
          ],
        );
      }),
    );
  }

  ContextMenu _panelMenu(BuildContext context) {
    return ContextMenu(
      icon: Icon(Icons.more_horiz),
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
            onPressed: () => panel.closePanel(panel.id),
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

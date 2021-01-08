import 'context_menu.dart';
import 'tab_panel.dart';
import 'package:flutter/material.dart' hide Tab;
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'tab.dart';

class AppTabWidget extends StatelessWidget {
  final Tab tab;
  final bool selected;
  final bool feedback;

  const AppTabWidget(
    this.tab, {
    Key key,
    this.selected = false,
    this.feedback = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastPage = tab.pages.isNotEmpty ? tab.pages.last : null;

    Widget icon;
    String title;
    if (lastPage?.body is TabPageMixin) {
      final tabPage = lastPage?.body as TabPageMixin;

      icon = tabPage.iconData != null
          ? Icon(tabPage.iconData,
              color: Theme.of(context).colorScheme.onSurface)
          : tabPage.icon;

      title = tabPage.title;
    } else {
      icon = lastPage?.icon != null
          ? SizedBox(height: 40, child: lastPage?.icon)
          : Icon(Icons.tab, color: Theme.of(context).colorScheme.onSurface);

      title = lastPage != null && lastPage.title.isNotEmpty
          ? lastPage.title
          : 'Tab';
    }

    final _tab = Container(
      decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.surface.withOpacity(0.5),
          border: Border.symmetric(
            vertical: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            ),
          )),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 42),
        child: Observer(builder: (context) {
          return Row(
            children: [
              VerticalDivider(width: 1),
              SizedBox(width: 8),
              if (feedback)
                icon
              else
                Draggable<Tab>(
                  data: tab,
                  child: icon,
                  feedback: AppTabWidget(tab, feedback: true),
                ),
              SizedBox(width: 8),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 75),
                child: Tooltip(
                  message: title,
                  child: Text(
                    title,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Theme.of(context).textTheme.button?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              SizedBox(width: 8),
              if (!tab.locked)
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed:
                      !tab.locked ? () => tab.panel?.closeTab(tab.id) : null,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              SizedBox(width: 8),
              VerticalDivider(width: 1),
            ],
          );
        }),
      ),
    );

    if (feedback) return Material(child: _tab);

    return Observer(builder: (_) {
      final isLocked = tab.locked;
      return ContextMenu(
        child: InkWell(
          onTap: () => tab.panel.selectTab(tab.id),
          child: _tab,
        ),
        menuWidth: 250,
        menuItems: [
          ContextMenuItem(
            title: Text(isLocked ? 'Unlock' : 'Lock'),
            icon: Icon(isLocked ? Icons.lock : Icons.lock_open),
            onPressed: tab.toggleLock,
          ),
          ContextMenuItem(),
          ContextMenuItem(
            title: Text('New tab'),
            icon: Icon(Icons.add),
            onPressed: () => tab.panel.newTab(tabId: tab.id),
          ),
          ContextMenuItem(
            title: Text('New tab to the left'),
            icon: Icon(Icons.add),
            onPressed: () => tab.panel.newTab(
              tabId: tab.id,
              position: TabPosition.before,
            ),
          ),
          ContextMenuItem(),
          if (!isLocked)
            ContextMenuItem(
              title: Text('Close'),
              icon: Icon(Icons.close),
              onPressed: () => tab.panel.closeTab(tab.id),
            ),
          if ((tab.panel?.tabs?.length ?? 0) > 1) ...[
            ContextMenuItem(
              title: Text('Close others'),
              icon: Icon(Icons.remove_circle),
              onPressed: () => tab.panel.closeOtherTabs(tab.id),
            ),
            ContextMenuItem(
              title: Text('Close right'),
              icon: Icon(Icons.remove_circle),
              onPressed: () => tab.panel.closeRight(tab.id),
            ),
            ContextMenuItem(
              title: Text('Close left'),
              icon: Icon(Icons.remove_circle),
              onPressed: () => tab.panel.closeLeft(tab.id),
            ),
          ]
        ],
      );
    });
  }
}

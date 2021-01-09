import 'package:flutter/material.dart';
import 'package:tabpanel/tabpanel.dart';

void main() async {
  final tabPanel = TabPanel(
    defaultPage: PageA(),
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.dark,
    theme: ThemeData.dark(),
    home: HomeWidget(tabPanel: tabPanel),
  ));
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    Key key,
    @required this.tabPanel,
  }) : super(key: key);

  final TabPanel tabPanel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabPanelTheme(
        data: TabPanelThemeData(
          dividerWidth: 4,
          dividerColor: Theme.of(context).colorScheme.onSurface,
        ),
        child: TabPanelWidget(tabPanel),
      ),
    );
  }
}

class PageA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tab = ParentTab.of(context);
    return Column(
      children: [
        Icon(Icons.construction, size: 56),
        Text('Page A'),
        Divider(),
        Wrap(
          children: [
            RaisedButton.icon(
              icon: Icon(Icons.open_in_browser),
              onPressed: () => tab?.push(PageB()),
              label: Text('Page B'),
            ),
            SizedBox(width: 16),
            RaisedButton.icon(
              icon: Icon(Icons.open_in_new),
              onPressed: () => tab?.push(PageB(), forceNewTab: true),
              label: Text('Page B'),
            ),
          ],
        )
      ],
    );
  }
}

class PageB extends StatelessWidget with TabPageMixin {
  @override
  final String title = 'PageB';

  @override
  final Icon icon = const Icon(Icons.dashboard);

  @override
  final IconData iconData = Icons.dashboard;

  @override
  Widget build(BuildContext context) {
    final tab = ParentTab.of(context);
    return Column(
      children: [
        Icon(Icons.construction_outlined, size: 56),
        Text('Page B'),
        Divider(),
        Wrap(
          children: [
            RaisedButton.icon(
              icon: Icon(Icons.open_in_browser),
              onPressed: () => tab?.push(PageC()),
              label: Text('Page C'),
            ),
            SizedBox(width: 16),
            RaisedButton.icon(
              icon: Icon(Icons.open_in_new),
              onPressed: () => tab?.push(PageC(), forceNewTab: true),
              label: Text('Page C'),
            ),
            SizedBox(width: 16),
            if ((tab?.pages?.length ?? 0) > 1)
              RaisedButton.icon(
                icon: Icon(Icons.navigate_before),
                onPressed: tab?.pop,
                label: Text('Go back'),
              ),
          ],
        )
      ],
    );
  }
}

class PageC extends StatelessWidget with TabPageMixin {
  @override
  final String title = 'PageC';

  @override
  final IconData iconData = Icons.work;

  @override
  Widget build(BuildContext context) {
    final tab = ParentTab.of(context);
    return Column(
      children: [
        Icon(Icons.construction_outlined, size: 56),
        Text('Page C'),
        Divider(),
        Wrap(
          children: [
            if ((tab?.pages?.length ?? 0) > 1)
              RaisedButton.icon(
                icon: Icon(Icons.navigate_before),
                onPressed: tab?.pop,
                label: Text('Go back'),
              ),
          ],
        )
      ],
    );
  }
}

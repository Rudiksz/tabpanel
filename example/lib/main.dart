import 'package:flutter/material.dart';
import 'package:tabpanel/tabpanel.dart';

void main() async {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final tabPanel = TabPanel(
    defaultPage: PageA(),
    panels: [
      TabPanel(
        defaultPage: PageA(),
        panels: [],
        flex: 1,
      ),
      TabPanel(
        defaultPage: PageA(),
        axis: Axis.vertical,
        panels: [
          TabPanel(
            defaultPage: PageA(),
            panels: [],
            flex: 3,
          ),
          TabPanel(
            defaultPage: PageA(),
            panels: [],
            flex: 1,
          ),
        ],
        flex: 2,
      ),
      TabPanel(
        defaultPage: PageA(),
        panels: [],
        flex: 1,
      ),
    ],
  );

  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: Stack(
        children: [
          TabPanelWidget(tabPanel),
          Positioned(
            bottom: 0,
            right: 0,
            child: Card(
              child: IconButton(
                onPressed: () => setState(() => darkMode = !darkMode),
                icon:
                    Icon(darkMode ? Icons.lightbulb : Icons.lightbulb_outlined),
              ),
            ),
          ),
        ],
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

# Introduction

Tabbed inferface with support for nested and resizeable panels.

Video demo:

[![](https://raw.githubusercontent.com/Rudiksz/tabpanel/main/screenshot.png)](https://youtu.be/hLpL0jUBDuM)

# Example

```dart
void main() async {
  // One initial panel
  // final tabPanel = TabPanel(defaultPage: YourDefaultPage());

  // or Create a more complex initial tab structure
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

  runApp(
    MaterialApp(
      home: TabPanelWidget(tabPanel),
    ),
  );
}
```

See the example folder for details.

# Planned features and known issues
* Extend the Tab API to better control its navigation stack. Most things the built-in Navigator class has, and a few more.
* Integrate the Router class or write a custom implementation, for how to specify pages to be pushed.
* More customization options for panels and the tab bar and ability to set different themes for panels.
* Cupertino and Material versions.
* Adding an option to limit the level of nesting. Currently is unlimited.
* Clone tab
* Adding a new tabs does not scroll the tab bar to bring it into view. To be fixed soon.
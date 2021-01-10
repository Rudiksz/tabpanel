# Introduction

Tabbed inferface with support for nested and resizeable panels.

Video demo:

[![](https://raw.githubusercontent.com/Rudiksz/tabpanel/main/screenshot.png)](https://youtu.be/hLpL0jUBDuM)

**Note: Requires Flutter's master channel for the time being**

# Example

```dart
void main() async {
  final tabPanel = TabPanel(defaultPage: YourDefaultPage());

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
# Introduction

Tabbed inferface with support for nested and resizeable panels.

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
* Adding a new tabs does not scroll the tab bar to bring it into view. To be fixed soon.
* More complete themeing support for panels and the tab bar and ability to set different themes for panels.
* Cupertino and Material versions.
* Adding an option to limit the level of nesting. Currently is unlimited.
* Clone tab
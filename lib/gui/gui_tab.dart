import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_presentation.dart';

class Tabs extends ListBase<Tab> with ChangeNotifier, DiagnosticableTreeMixin {
  final List<Tab> _tabs = [];
  Tab? _selectedTab;

  @override
  int get length => _tabs.length;

  @override
  set length(int length) {
    _tabs.length = length;
  }

  @override
  void operator []=(int index, Tab value) {
    _tabs[index] = value;
    notifyListeners();
  }

  @override
  Tab operator [](int index) => _tabs[index];

  @override
  void add(Tab element) {
    if (_tabs.length >= 10) {
      _closeOneTab();
    }
    _tabs.add(element);
    _selectedTab = element;
    notifyListeners();
  }

  @override
  void addAll(Iterable<Tab> iterable) {
    _tabs.addAll(iterable);
    _selectedTab = iterable.last;
    notifyListeners();
  }

  Tab get selected {
    if (_tabs.contains(_selectedTab)) {
      return _selectedTab!;
    } else if (_tabs.isEmpty) {
      throw Exception('No tabs, so no selected tab');
    } else {
      _selectedTab = _tabs.last;
      return _selectedTab!;
    }
  }

  set selected(Tab selectedTab) {
    if (!_tabs.contains(selectedTab)) {
      add(selectedTab);
    }
    _selectedTab = selectedTab;
    notifyListeners();
  }

  int get selectedIndex {
    try {
      return _tabs.indexOf(selected);
    } on Exception {
      return -1;
    }
  }

  close(Tab tab) {
    if (tab.canCloseDirectly) {
      _tabs.remove(tab);
      notifyListeners();
    } else {
      var closeResult = tab.close;
      if (closeResult == TabCloseResult.closed) {
        _tabs.remove(tab);
        notifyListeners();
      }
    }
  }

  void closeAll() {
    _tabs.clear();
    notifyListeners();
  }

  void closeOthers(Tab tab) {
    _tabs.clear();
    _tabs.add(tab);
    notifyListeners();
  }

  void _closeOneTab() {
    Tab tabToClose = _findTabToClose()!;
    close(tabToClose);
    // We are not going to ask the user the close other tabs if
    // the tab.close result is TabCloseResult.CANCELED.
    // At least we tried to keep the number of open tabs below 10.
  }

  ///returns a [Tab] that can be closed directly, or otherwise the first (oldest) [Tab]
  Tab? _findTabToClose() {
    return _tabs.firstWhere((tab) => tab.canCloseDirectly,
        orElse: () => _tabs.first);
  }
}

abstract class Tab extends StatelessWidget {
  const Tab({Key? key}) : super(key: key);

  String get title;

  IconData get iconData;

  bool get canCloseDirectly;

  /// asks the [Tab] to close. The [Tab] could open a dialog if it contains
  /// unsaved data, so the user can decide if the [Tab] can be closed or not.
  TabCloseResult get close;
}

enum TabCloseResult { canceled, closed }

abstract class TabFactory {
  Tab create(ActionMethodPresentation actionMethod);
}

///TODO remove, only intended for testing
class ExampleTab extends Tab {
  final String _creationDateTime;

  final ActionMethodPresentation actionMethod;

  ExampleTab(this.actionMethod, {Key? key})
      : _creationDateTime = DateTime.now().toIso8601String(),
        super(key: key);

  @override
  bool get canCloseDirectly => true;

  @override
  TabCloseResult get close => TabCloseResult.closed;

  @override
  IconData get iconData {
    var i = Random().nextInt(5);
    switch (i) {
      case 0:
        return Icons.favorite;
      case 1:
        return Icons.info;
      case 2:
        return Icons.tab;
      case 3:
        return Icons.table_rows;
      case 4:
        return Icons.edit;
      default:
        return Icons.settings;
    }
  }

  @override
  String get title {
    return actionMethod.name.englishText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(_creationDateTime, textAlign: TextAlign.center),
    );
  }
}

///TODO remove, only intended for testing
class ExampleTabFactory implements TabFactory {
  @override
  Tab create(ActionMethodPresentation actionMethod) {
    return ExampleTab(actionMethod);
  }
}

import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';

const _libraryUri =
    'package:reflect_gui_builder/builder/domain/translation/reflect_translatables.dart';

class ReflectTranslatables {
  final tabsMenu = TabsMenuTranslatables();
}

class TabsMenuTranslatables {
  final title = Translatable(
    key: '$_libraryUri/tabsMenu.title',
    englishText: 'Tabs',
  );

  final closeOthers = Translatable(
    key: '$_libraryUri/tabsMenu.closeOthers',
    englishText: 'Close others',
  );

  final closeAll = Translatable(
    key: '$_libraryUri/tabsMenu.closeAll',
    englishText: 'Close all',
  );
}

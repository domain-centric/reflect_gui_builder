import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/application_class/generated_application_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/service_class/service_class_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/translation/reflect_translatables.dart';
import 'package:reflect_gui_builder/gui/gui_tab.dart' as reflect_tabs;

const tabletWidthBreakpoint = 720.0;
const desktopWidthBreakpoint = 1200.0;
const sideMenuWidth = 250.0;

const EdgeInsets buttonPadding = EdgeInsets.all(15);

class ReflectGuiApplication extends StatelessWidget {
  final GeneratedApplicationPresentation applicationPresentation;

  const ReflectGuiApplication(
    this.applicationPresentation, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => reflect_tabs.Tabs()),
      Provider(create: (_) => applicationPresentation),
    ], child: ReflectMaterialApp(reflectGuiApplication: this));
  }
}

class ReflectMaterialApp extends StatelessWidget {
  final ReflectGuiApplication reflectGuiApplication;

  const ReflectMaterialApp({Key? key, required this.reflectGuiApplication})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Provider.of<GeneratedApplicationPresentation>(context)
          .name
          .englishText,
      theme: reflectGuiApplication.applicationPresentation.lightTheme,
      darkTheme: reflectGuiApplication.applicationPresentation.darkTheme,
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, dimensions) {
      if (dimensions.maxWidth >= desktopWidthBreakpoint) {
        return const WideScaffold();
      } else {
        return const NarrowScaffold();
      }
    });
  }
}

class ApplicationTitle extends StatelessWidget {
  const ApplicationTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    reflect_tabs.Tabs tabs = Provider.of<reflect_tabs.Tabs>(context);
    String appTitle =
        Provider.of<GeneratedApplicationPresentation>(context).name.englishText;
    return LayoutBuilder(builder: (_, dimensions) {
      if (tabs.isEmpty) {
        return Text(appTitle);
      } else if (dimensions.maxWidth < tabletWidthBreakpoint) {
        return Text(tabs.selected.title);
      } else {
        return Row(children: [
          Text(appTitle),
          const SizedBox(width: 90),
          const TabButtons()
        ]); //TODO hide title if it does not fit and ensure correct distance (sizeBox)
        //Text('$appTitle - ${tabs.selected.title}');
      }
    });
  }
}

class TabButtons extends StatelessWidget {
  const TabButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    reflect_tabs.Tabs tabs = Provider.of<reflect_tabs.Tabs>(context);
    return LayoutBuilder(builder: (_, dimensions) {
      return Row(children: [
        for (int i = 0; i < tabs.length; i++) TabHeader(tabs[i]),
      ]); // TODO other tabs
    });
  }
}

class TabHeader extends StatelessWidget {
  final reflect_tabs.Tab? tab;

  const TabHeader(this.tab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    reflect_tabs.Tabs tabs = Provider.of<reflect_tabs.Tabs>(context);
    bool isSelected = tabs.selected == tab;
    return LayoutBuilder(builder: (_, dimensions) {
      return InkWell(
        onTap: () {
          if (!isSelected) {
            tabs.selected = tab!;
          }
        },
        child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 4),
                    top:
                        const BorderSide(color: Colors.transparent, width: 4))),
            child: Row(
              children: [
                Text(tab!.title),
                const SizedBox(width: 10),
                if (isSelected)
                  InkWell(
                      onTap: () {
                        tabs.close(tab!);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 17,
                      ))
              ],
            )),
      );
    });
  }
}

class NarrowScaffold extends StatelessWidget {
  const NarrowScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    reflect_tabs.Tabs tabs = Provider.of<reflect_tabs.Tabs>(context);
    return Scaffold(
        appBar: AppBar(
          title: const ApplicationTitle(),
          actions: [
            if (tabs.length > 1) const TabsIcon(),
          ],
        ),
        drawer: const Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: MainMenu(
          isDrawerMenu: true,
        )),
        body: Container(
          constraints: const BoxConstraints.expand(),
          child: const TabContainer(),
        ));
  }
}

class WideScaffold extends StatelessWidget {
  const WideScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    reflect_tabs.Tabs tabs = Provider.of<reflect_tabs.Tabs>(context);
    return Scaffold(
        appBar: AppBar(
          title: const ApplicationTitle(),
          //Text(ReflectFramework().reflection.applicationInfo.title),
          leading: InkWell(
            onTap: () {}, //TODO add
            child: const Icon(
              Icons.menu, // add custom icons also
            ),
          ),
          actions: [
            if (tabs.length > 1) const TabsIcon(),
          ],
        ),
        body: Center(
          child: Row(
            children: const [
              SizedBox(
                width: sideMenuWidth,
                child: MainMenu(
                  isDrawerMenu: false,
                ),
              ),
              VerticalDivider(thickness: 3),
              Expanded(
                child: TabContainer(),
              ),
            ],
          ),
        ));
  }
}

class TabsIcon extends StatelessWidget {
  const TabsIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          showTabSelectionDialog(context);
        },
        child: AspectRatio(
            aspectRatio: 1,
            child: Container(
                margin: const EdgeInsets.all(13.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1!
                            .color!,
                        width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                        '${Provider.of<reflect_tabs.Tabs>(context).length}')))));
  }

  showTabSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          var tabs = Provider.of<reflect_tabs.Tabs>(context);
          return AlertDialog(
            title: Text(Provider.of<ReflectTranslatables>(context)
                .tabsMenu
                .title
                .englishText),
            content: SizedBox(
              width: tabletWidthBreakpoint,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: tabs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    selected: tabs.selected == tabs[index],
                    title: Text(tabs[index].title),
                    leading: Icon(tabs[index].iconData),
                    trailing: InkWell(
                      child: const Icon(Icons.close),
                      onTap: () {
                        tabs.close(tabs[index]);
                        Navigator.pop(context);
                      },
                    ),
                    onTap: () {
                      tabs.selected = tabs[index];
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            actions: [
              if (tabs.length >= 3)
                ElevatedButton(
                    child: Padding(
                      padding: buttonPadding,
                      child: Text(Provider.of<ReflectTranslatables>(context)
                          .tabsMenu
                          .closeOthers
                          .englishText),
                    ),
                    onPressed: () {
                      tabs.closeOthers(tabs.selected);
                      Navigator.pop(context);
                    }),
              if (tabs.length >= 2)
                ElevatedButton(
                    child: Padding(
                      padding: buttonPadding,
                      child: Text(Provider.of<ReflectTranslatables>(context)
                          .tabsMenu
                          .closeAll
                          .englishText),
                    ),
                    onPressed: () {
                      tabs.closeAll();
                      Navigator.pop(context);
                    })
            ],
          );
        });
  }
}

class MainMenu extends StatelessWidget {
  final bool isDrawerMenu;

  const MainMenu({Key? key, required this.isDrawerMenu}) : super(key: key);

  onTab(BuildContext context, ActionMethodPresentation actionMethod) {
//TODO
// if (actionMethod.parameterFactory!=null) {
//   var parameter=actionMethod.parameterFactory!();
//   actionMethod.parameterProcessor.process(context, actionMethodOwner, actionMethod, parameter);
// } else {
//   actionMethod.parameterProcessor.process(context, actionMethodOwner, actionMethod, void);
// }

    if (isDrawerMenu) {
      Navigator.pop(context); //Hide Drawer
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isDrawerMenu) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
              Provider.of<GeneratedApplicationPresentation>(context)
                  .name
                  .englishText,
              style: Theme.of(context).primaryTextTheme.headline6),
        ),
        body: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: createChildren(context),
        ),
      );
    } else {
      return ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: createChildren(context),
      );
    }
  }

  List<Widget> createChildren(BuildContext context) {
    List<ServiceClassPresentation> serviceClasses =
        Provider.of<GeneratedApplicationPresentation>(context).serviceClasses;

    List<Widget> children = [];

    for (ServiceClassPresentation serviceClass in serviceClasses) {
      children.add(createServiceObjectTile(serviceClass));
      for (ActionMethodPresentation actionMethod in serviceClass.actionMethods
          .where((actionMethod) => !actionMethod.parameterNeeded)) {
        children.add(createActionMethodTile(actionMethod, context));
      }
    }
    return children;
  }

  Widget createServiceObjectTile(ServiceClassPresentation serviceClassInfo) {
    return SizedBox(
        height: 35,
        child: ListTile(
            title: Text(serviceClassInfo.name.englishText.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold))));
  }

  ListTile createActionMethodTile(
      ActionMethodPresentation actionMethod, BuildContext context) {
    return ListTile(
      leading: Icon(actionMethod.icon),
      //TODO of actionMethod.icon=null then
      // Container(
      //   width: 18,
      //   height: 18,
      // ),
      title: Transform(
          //remove extra space between leading and title
          transform: Matrix4.translationValues(-20, 0.0, 0.0),
          child: Text(
            actionMethod.name.englishText,
          )),
      onTap: () => {onTab(context, actionMethod)},
    );
  }
}

class TabContainer extends StatelessWidget {
  const TabContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reflect_tabs.Tabs tabs = Provider.of<reflect_tabs.Tabs>(context);
    if (tabs.isEmpty) {
      return const ApplicationTitleTab();
    } else {
      return IndexedStack(
        index: tabs.selectedIndex,
        children: [
          for (reflect_tabs.Tab tab in tabs) tab,
        ],
      );
    }
  }
}

class ApplicationTitleTab extends StatelessWidget {
  const ApplicationTitleTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.2,
            vertical: MediaQuery.of(context).size.height * 0.2),
        child: const ApplicationTitleWidget());
  }
}

class ApplicationTitleWidget extends StatelessWidget {
  const ApplicationTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<GeneratedApplicationPresentation>(context).titleImagePath ==
        null) {
      return const ApplicationTitleText();
    } else {
      return const ApplicationTitleImage();
    }
  }
}

class ApplicationTitleImage extends StatelessWidget {
  const ApplicationTitleImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
        Provider.of<GeneratedApplicationPresentation>(context).titleImagePath!);
  }
}

class ApplicationTitleText extends StatelessWidget {
  const ApplicationTitleText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        fit: BoxFit.fitWidth,
        //TODO re-implement flutter_shine when it is null-safe
        // child: FlutterShine(
        //   config: Config(offset: 0.05),
        //   builder: (BuildContext context, ShineShadow shineShadow) {
        //     return Opacity(
        //         opacity: 0.7,
        child: Text(
            Provider.of<GeneratedApplicationPresentation>(context)
                .name
                .englishText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              //       shadows: shineShadow.shadows),
              // ));
            )));
  }
}

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SearchList());
  }
}

class SearchList extends StatefulWidget {
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  Widget appbarTitle = Text(
    'Search Sample',
    style: TextStyle(
      color: Colors.white,
    ),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  TextEditingController controller = TextEditingController();
  List<String> list = [
    'Google',
    'IOS',
    'Android',
    'Dart',
    'Flutter',
    'Python',
    'React',
    'Java',
    'JavaScript'
  ];
  bool searching = false;
  String searchText = '';

  _SearchListState() {
    controller.addListener(() {
      if (controller.text.isEmpty) {
        setState(() {
          searching = false;
          searchText = '';
        });
      } else {
        setState(() {
          searching = true;
          searchText = controller.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        children: searching ? buildSearchList() : buildList(),
      ),
    );
  }

  List<Widget> buildList() {
    return list.map((element) {
      return ListTile(
        title: Text(element),
      );
    }).toList();
  }

  List<Widget> buildSearchList() {
    if (searchText.isEmpty) {
      return list.map((element) {
        return ListTile(
          title: Text(element),
        );
      }).toList();
    } else {
      List<String> searchList = [];
      for (int i = 0; i < list.length; i++) {
        String name = list.elementAt(i);
        if (name.toLowerCase().contains(searchText.toLowerCase())) {
          searchList.add(name);
        }
      }
      return searchList.map((element) {
        return ListTile(
          title: Text(element),
        );
      }).toList();
    }
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: appbarTitle,
      actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (actionIcon.icon == Icons.search) {
                actionIcon = Icon(
                  Icons.close,
                  color: Colors.white,
                );
                appbarTitle = TextField(
                  autofocus: true,
                  controller: controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.white)),
                );
                handleSearchStart();
              } else {
                handleSearchEnd();
              }
            });
          },
        )
      ],
    );
  }

  void handleSearchStart() {
    setState(() {
      searching = true;
    });
  }

  void handleSearchEnd() {
    setState(() {
      actionIcon = Icon(
        Icons.search,
        color: Colors.white,
      );
      appbarTitle = Text(
        'Search Sample',
        style: TextStyle(
          color: Colors.white,
        ),
      );
      searching = false;
      controller.clear();
    });
  }
}

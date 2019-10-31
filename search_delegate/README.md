# search_delegate

### ShowSearch

ShowSearch is a method in the material library in Flutter. Because of this, it can be accessed from anywhere in your widget tree. This method takes the build context and a SearchDelegate to handle the actual searching.

``` dart
AppBar(
  title: Text('Search App'),
  actions: <Widget>[
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        showSearch(
          context: context,
          delegate: CustomSearchDelegate(),
        )
      }
    )
  ]
);
```

### CustomSearchDelegate

To implement a custom search delegate, you need to create a new class that extends the SearchDelegate class.

``` dart
class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return null;
  }
}
```


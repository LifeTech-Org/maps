import 'package:flutter/material.dart';
import 'package:maps/screens/destinations.dart';

class Search extends StatefulWidget {
  const Search({super.key});
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      shape:
          MaterialStateProperty.all<OutlinedBorder>(BeveledRectangleBorder()),
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back)),
      hintText: 'Search from pupular bus stops',
      controller: _controller,
    );
  }
}

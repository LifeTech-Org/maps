import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key, required this.setSearch});
  final Function(String search) setSearch;
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      onChanged: (value) {
        widget.setSearch(value);
      },
    );
  }
}

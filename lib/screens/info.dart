import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before_rounded),
          onPressed: () => {Navigator.of(context).pop()},
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          // ListTile(
          //   title: const Text(
          //     'Licenses',
          //     style: TextStyle(fontWeight: FontWeight.w500),
          //   ),
          //   subtitle: const Text('Our Licenses'),
          //   leading: Icon(
          //     Icons.content_paste,
          //     color: Theme.of(context).primaryColor,
          //   ),
          //   trailing: const Icon(Icons.navigate_next_rounded),
          //   onTap: () {},
          // ),
          ListTile(
            title: const Text(
              'Contact Support',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Email us and we will reply shortly.'),
            leading: Icon(
              Icons.mail_outline,
              color: Theme.of(context).primaryColor,
            ),
            trailing: const Icon(Icons.navigate_next_rounded),
            onTap: () {},
          ),
          Divider(
            endIndent: 40,
            indent: 40,
            color: Theme.of(context).highlightColor,
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'This application represents a project by. No unnecceasry reproduction and some gibberish lorem ipsum will be included here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).dividerColor),
            ),
          ),
        ],
      ),
    );
  }
}

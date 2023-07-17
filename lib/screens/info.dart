import 'package:flutter/material.dart';
import 'package:maps/screens/privacy.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  Future<void> _launchURL() async {
    final url = Uri.parse('mailto:lanre.jubilee102010@gmail.com');
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong...')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Info'),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before_rounded),
          onPressed: () => {Navigator.of(context).pop()},
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
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
            onTap: _launchURL,
          ),
          ListTile(
            title: const Text(
              'Privacy Policy',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('How we handle your location data.'),
            leading: Icon(
              Icons.policy_outlined,
              color: Theme.of(context).primaryColor,
            ),
            trailing: const Icon(Icons.navigate_next_rounded),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const Privacy(),
              ));
            },
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
              'This project is the intellectual property and creation of IBIKUNLE, A.O, a student of the University of Ibadan with Matriculation Number 227225. Prior permission from the owner is required before adapting or deploying this app.',
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

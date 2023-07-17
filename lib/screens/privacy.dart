import 'package:flutter/material.dart';
import 'package:maps/resources/privacy.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before_rounded),
          onPressed: () => {Navigator.of(context).pop()},
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our Privacy Policy',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text('Effective Date: 2000 BC',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 10),
              Text(
                'This Privacy Policy outlines the practices of Go Smart regarding the collection, use, and disclosure of personal information when you use our [App/Service]. We are committed to protecting your privacy and ensuring the security of your personal information. By using our [App/Service], you consent to the terms outlined in this Privacy Policy.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 30),
              Column(
                  children: privacy.map((term) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      term['title']!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      term['content']!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList())
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../constants.dart';

class ModelLibraryButton extends StatelessWidget {
  const ModelLibraryButton({super.key});

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: () async {
          if (await canLaunchUrlString(ollamaLibraryUrl)) {
            launchUrlString(ollamaLibraryUrl);
          }
        },
        child: const Text('Voir les modèles disponibles'),
      );
}

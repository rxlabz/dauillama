import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import 'highlighter.dart';

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    String? language = '';

    final theme = Theme.of(context).brightness == Brightness.light
        ? rxLightOceanTheme
        : rxDarkOceanTheme;

    if (element.attributes['class'] != null ||
        element.textContent.contains('\n')) {
      final lg = element.attributes['class'];
      language = lg?.substring(9);

      return Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SelectionArea(
              child: language != null
                  ? HighlightView(
                      element.textContent,

                      // Specify language
                      // It is recommended to give it a value for performance
                      language: language,

                      // Specify highlight theme
                      // All available themes are listed in `themes` folder
                      theme: theme,

                      // Specify padding
                      padding: const EdgeInsets.all(8),

                      // Specify text style
                      /*textStyle: GoogleFonts.robotoMono(),*/
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(element.textContent),
                    ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () =>
                  Clipboard.setData(ClipboardData(text: element.textContent)),
              icon: const Icon(Icons.copy),
            ),
          ),
        ],
      );
    }
    return SelectionArea(
      child: HighlightView(
        element.textContent,

        // Specify language
        // It is recommended to give it a value for performance
        language: language,

        // Specify highlight theme
        // All available themes are listed in `themes` folder
        theme:
            theme /*MediaQuery.of(context).platformBrightness == Brightness.light
            ? rxLightOceanTheme
            : rxDarkOceanTheme*/
        ,

        // Specify padding
        padding: const EdgeInsets.all(8),

        // Specify text style
        /*textStyle: GoogleFonts.robotoMono(),*/
      ),
    );
  }
}

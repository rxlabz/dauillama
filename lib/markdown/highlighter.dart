import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:highlight/highlight.dart';

class MdHightLighter implements SyntaxHighlighter {
  Map<String, dynamic> get theme =>
      isDark ? rxDarkOceanTheme : rxLightOceanTheme;

  static const _defaultFontColor = Color(0xffcccccc);
  static const _rootKey = 'root';

  final TextStyle defaultStyle;

  final Brightness brightness;

  bool get isDark => brightness == Brightness.dark;

  MdHightLighter(this.defaultStyle, {this.brightness = Brightness.dark});

  @override
  TextSpan format(String source) {
    return _convert(highlight.parse(source, language: 'dart').nodes!);
  }

  TextSpan _convert(List<Node> nodes) {
    final themeColor =
        isDark ? (theme[_rootKey] as TextStyle?)?.color : Colors.grey.shade800;

    var textStyle = TextStyle(color: themeColor ?? _defaultFontColor);
    textStyle = textStyle.merge(defaultStyle);

    final spans = <TextSpan>[];
    var currentSpans = spans;
    final stack = <List<TextSpan>>[];

    void traverseFn(Node node) {
      if (node.value != null) {
        currentSpans.add(
          node.className == null
              ? TextSpan(text: node.value)
              : TextSpan(
                  text: node.value,
                  style: theme[node.className],
                ),
        );
      } else if (node.children != null) {
        final tmp = <TextSpan>[];
        currentSpans.add(
          TextSpan(
            children: tmp,
            style: theme[node.className],
          ),
        );
        stack.add(currentSpans);
        currentSpans = tmp;

        for (final n in node.children!) {
          traverseFn(n);
          if (n == node.children!.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        }
      }
    }

    // ignore: prefer_foreach
    for (final node in nodes) {
      traverseFn(node);
    }

    return TextSpan(style: textStyle, children: spans);
  }
}

const rxDarkOceanTheme = {
  'comment': TextStyle(color: Color(0xff65737e)),
  'quote': TextStyle(color: Color(0xff65737e)),
  'variable': TextStyle(color: Color(0xffbf616a)),
  'template-variable': TextStyle(color: Color(0xffbf616a)),
  'tag': TextStyle(color: Color(0xffbf616a)),
  'name': TextStyle(color: Color(0xffbf616a)),
  'selector-id': TextStyle(color: Color(0xffbf616a)),
  'selector-class': TextStyle(color: Color(0xffbf616a)),
  'regexp': TextStyle(color: Color(0xffbf616a)),
  'deletion': TextStyle(color: Color(0xffbf616a)),
  'number': TextStyle(color: Color(0xffd08770)),
  'built_in': TextStyle(color: Color(0xffd08770)),
  'builtin-name': TextStyle(color: Color(0xffd08770)),
  'literal': TextStyle(color: Color(0xffd08770)),
  'type': TextStyle(color: Color(0xffd08770)),
  'params': TextStyle(color: Color(0xffd08770)),
  'meta': TextStyle(color: Color(0xffd08770)),
  'link': TextStyle(color: Color(0xffd08770)),
  'attribute': TextStyle(color: Color(0xffebcb8b)),
  'string': TextStyle(color: Color(0xffa3be8c)),
  'symbol': TextStyle(color: Color(0xffa3be8c)),
  'bullet': TextStyle(color: Color(0xffa3be8c)),
  'addition': TextStyle(color: Color(0xffa3be8c)),
  'title': TextStyle(color: Color(0xff8fa1b3)),
  'class': TextStyle(color: Color(0xff8fa1b3)),
  'section': TextStyle(color: Color(0xff8fa1b3)),
  'subst': TextStyle(color: Color(0xff8cbbad)),
  'keyword': TextStyle(color: Color(0xffb48ead)),
  'selector-tag': TextStyle(color: Color(0xffb48ead)),
  'root':
      TextStyle(backgroundColor: Color(0xff192329), color: Color(0xffc0c5ce)),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
  'strong': TextStyle(fontWeight: FontWeight.bold),
};

const rxLightOceanTheme = {
  'comment': TextStyle(color: Color(0xff65737e)),
  'quote': TextStyle(color: Color(0xff65737e)),
  'variable': TextStyle(color: Color(0xff972c37)),
  'template-variable': TextStyle(color: Color(0xff972c37)),
  'tag': TextStyle(color: Color(0xff972c37)),
  'name': TextStyle(color: Color(0xff972c37)),
  'selector-id': TextStyle(color: Color(0xff972c37)),
  'selector-class': TextStyle(color: Color(0xff972c37)),
  'regexp': TextStyle(color: Color(0xff972c37)),
  'deletion': TextStyle(color: Color(0xff972c37)),
  'number': TextStyle(color: Color(0xffb94923)),
  'built_in': TextStyle(color: Color(0xffb94923)),
  'builtin-name': TextStyle(color: Color(0xffb94923)),
  'literal': TextStyle(color: Color(0xffb94923)),
  'type': TextStyle(color: Color(0xffb94923)),
  'params': TextStyle(color: Color(0xffb94923)),
  'meta': TextStyle(color: Color(0xffb94923)),
  'link': TextStyle(color: Color(0xffb94923)),
  'attribute': TextStyle(color: Color(0xffd3830a)),
  'string': TextStyle(color: Color(0xff218f58)),
  'symbol': TextStyle(color: Color(0xff218f58)),
  'bullet': TextStyle(color: Color(0xff218f58)),
  'addition': TextStyle(color: Color(0xff218f58)),
  'title': TextStyle(color: Color(0xff184e85)),
  'class': TextStyle(color: Color(0xff184e85)),
  'section': TextStyle(color: Color(0xff184e85)),
  'subst': TextStyle(color: Color(0xff0a8c65)),
  'keyword': TextStyle(color: Color(0xffa42e8e)),
  'selector-tag': TextStyle(color: Color(0xffa42e8e)),
  'root':
      TextStyle(backgroundColor: Color(0xDBE4E6E0), color: Color(0xff2b303b)),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
  'strong': TextStyle(fontWeight: FontWeight.bold),
};

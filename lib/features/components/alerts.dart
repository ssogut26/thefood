import 'package:flutter/material.dart';
import 'package:thefood/core/constants/paddings.dart';

class AlertWidgets {
  AlertWidgets._();
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    BuildContext context,
    String message,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static Future<dynamic> showMessageDialog(
    BuildContext context,
    String title,
    String message, {
    List<Widget>? actions = const [],
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline2,
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static Future<dynamic> showActionDialog(
    BuildContext context,
    String title,
    Widget? content,
    List<Widget>? actions,
  ) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: ProjectPaddings.pageLarge,
        scrollable: true,
        insetPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline1,
        ),
        content: content,
        actions: actions,
      ),
    );
  }
}

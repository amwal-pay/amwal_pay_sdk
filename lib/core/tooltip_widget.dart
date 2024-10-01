import 'package:flutter/material.dart';

class TooltipWidget extends StatelessWidget {
  final Widget title;
  final String? message;
  final TooltipTriggerMode triggerMode;

  const TooltipWidget({
    super.key,
    required this.title,
    required this.message,
    this.triggerMode = TooltipTriggerMode.tap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        title,
        if (message != null) ...[
          const SizedBox(width: 4),
          Tooltip(
            triggerMode: triggerMode,
            message: message,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.info,
              size: 22,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        ]
      ],
    );
  }
}

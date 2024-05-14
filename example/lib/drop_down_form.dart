import 'package:flutter/material.dart';

class DropdownForm<T> extends StatefulWidget {
  final String title;
  final List<T> options;
  final T? initialValue;
  final String Function(T) nameMapper;
  final String Function(T) valueMapper;
  final void Function(String?) onChanged;
  const DropdownForm({
    super.key,
    required this.title,
    required this.options,
    this.initialValue,
    required this.nameMapper,
    required this.valueMapper,
    required this.onChanged,
  });

  @override
  State<DropdownForm<T>> createState() => _DropdownFormState<T>();
}

class _DropdownFormState<T> extends State<DropdownForm<T>> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          const SizedBox(height: 4),
          DropdownButtonFormField(
            value: widget.initialValue != null
                ? widget.nameMapper(widget.initialValue as T)
                : null,
            items: widget.options
                .map((e) => DropdownMenuItem(
                      value: widget.nameMapper(e),
                      child: Text(widget.nameMapper(e)),
                    ))
                .toList(),
            onChanged: (item) {
              widget.onChanged(item);
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class CustomPopup extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final Function() onSave;
  final Function() onClose;

  const CustomPopup({
    Key? key,
    required this.title,
    required this.fields,
    required this.onSave,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
        height: 300, // Adjust height as needed
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...fields,
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onClose,
                    child: const Text('CANCEL'),
                  ),
                  ElevatedButton(
                    onPressed: onSave,
                    child: const Text('SAVE'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

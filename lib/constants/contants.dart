import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

final TextEditingController courseNameController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();
final TextEditingController subjectNameController = TextEditingController();
final TextEditingController courseIdController = TextEditingController();

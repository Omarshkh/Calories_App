import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadJsonToFirestore(String assetPath, String collectionName) async {
  try {
    String jsonString = await rootBundle.loadString(assetPath);
    List<dynamic> items = json.decode(jsonString);

    final collectionRef = FirebaseFirestore.instance.collection(collectionName);

    for (var item in items) {
      await collectionRef.add(Map<String, dynamic>.from(item));
    }

    print('✅ Uploaded ${items.length} items to "$collectionName"');
  } catch (e) {
    print('❌ Error uploading to Firestore: $e');
  }
}

Future<void> uploadAllJsonFiles() async {
  await uploadJsonToFirestore('assets/json_files/veg/veg.json', 'vegetables');
  await uploadJsonToFirestore('assets/json_files/meat/meat.json', 'meats');
  await uploadJsonToFirestore('assets/json_files/carb/carb.json', 'carbs');
}

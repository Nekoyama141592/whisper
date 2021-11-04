// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nftownersProvider = ChangeNotifierProvider(
  (ref) => NFTownersModel()
);

class NFTownersModel extends ChangeNotifier {
  Stream<QuerySnapshot> nftOwnersStream = FirebaseFirestore.instance
  .collection('nftOwners')
  .orderBy('number',descending: false)
  .snapshots();
}
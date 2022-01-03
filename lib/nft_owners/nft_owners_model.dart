// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/strings.dart';

final nftownersProvider = ChangeNotifierProvider(
  (ref) => NFTownersModel()
);

class NFTownersModel extends ChangeNotifier {
  Stream<QuerySnapshot> nftOwnersStream = FirebaseFirestore.instance.collection(nftOwnersKey).orderBy(numberKey,descending: false).snapshots();
}
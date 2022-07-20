// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nftownersProvider = ChangeNotifierProvider(
  (ref) => NFTownersModel()
);

class NFTownersModel extends ChangeNotifier {
  // Stream<QuerySnapshot> nftOwnersStream = FirebaseFirestore.instance.collection(nftOwnersFieldKey).orderBy(numberFieldKey,descending: false).snapshots();
}
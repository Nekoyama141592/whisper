import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final adminProvider = ChangeNotifierProvider(
  (ref) => AdminModel()
);

class AdminModel extends ChangeNotifier {
  
  Future adminMove() async {
    // try {
    //   WriteBatch batch = FirebaseFirestore.instance.batch();
    //   return 
    //   FirebaseFirestore.instance
    //   .collection('replys')
    //   .get()
    //   .then((qshot) {
    //     qshot.docs.forEach((doc) {
    //       batch.update(doc.reference, {
    //         'isNFTicon': false,
    //         'isOfficial': false,
    //       });
    //     });
    //     return batch.commit();
    //   });

    // } catch(e) {
    //   print(e.toString());
    // }
    await FirebaseFirestore.instance
    .collection('users')
    .doc('KduGe12Nf9w5JYCZPTAq')
    .update({
      'replyNotifications': [],
      'commentNotifications': [],
    });
  }
}
// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/nft_owners/components/nft_owner_card.dart';
// model
import 'package:whisper/nft_owners/nft_owners_model.dart';

class NFTownersPage extends ConsumerWidget {

  const NFTownersPage({
    Key? key
  }) : super(key: key);

  @override 
  Widget build(BuildContext context, WidgetRef ref) {

    final nftOwnersModel = ref.watch(nftownersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('NFT所有者様方'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(defaultPadding(context: context))
          )
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding(context: context)),
          child: StreamBuilder(
            stream: nftOwnersModel.nftOwnersStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) Text('something went wrong');
              if (snapshot.connectionState == ConnectionState.waiting) Loading();
              return !snapshot.hasData || snapshot.data == null  ?
              SizedBox.shrink()
              : Center(
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                    Map<String, dynamic> nftOwner = doc.data()! as Map<String, dynamic>;
                    return NFTownerCard(map: nftOwner);
                  }).toList(),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
// material
import 'package:flutter/material.dart';
// packages
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/links.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/rounded_button.dart';
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
            bottom: Radius.circular(15.0)
          )
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedButton(
                text: '購入ページのリンクをコピー', 
                widthRate: 0.90, 
                verticalPadding: 16.0, 
                horizontalPadding: 10.0, 
                press: () async {
                  await FlutterClipboard.copy(openSeaLink)
                  .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('NFTページのリンクをコピーしました')));
                  } );
                }, 
                textColor: Colors.white, 
                buttonColor: Theme.of(context).highlightColor
              ),
              Expanded(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
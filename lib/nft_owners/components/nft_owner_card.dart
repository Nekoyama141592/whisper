// material
import 'package:flutter/material.dart';
// packages
import 'package:url_launcher/url_launcher.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/others.dart';
// domain
import 'package:whisper/domain/nft_owner/nft_owner.dart';

class NFTownerCard extends StatelessWidget {

  const NFTownerCard({
    Key? key,
    required this.map
  }) : super(key: key);

  final Map<String,dynamic> map;

  @override 
  Widget build(BuildContext context) {
    final NFTOwner nftOwner = fromMapToNFTOwner(nftOwner: map);
    
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular( defaultPadding(context: context) ))
            ),
            child: Padding(
              padding: EdgeInsets.all( defaultPadding(context: context) ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nftOwner.userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: defaultPadding(context: context)/2.0 ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'number' + nftOwner.number.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: defaultPadding(context: context)/2.0),
                      Text(
                        nftOwner.ethPrice.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: defaultPadding(context: context)/2.0 ),
                      InkWell(
                        child: Icon(Icons.link),
                        onTap: () async {
                          final String link = nftOwner.link;
                          if ( await canLaunch(link) ) {
                            await launch(link);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('このURLは無効です')));
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
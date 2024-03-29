// material
import 'package:flutter/material.dart';
// packages
import 'package:url_launcher/url_launcher_string.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart';
// domain
import 'package:whisper/domain/nft_owner/nft_owner.dart';
import 'package:whisper/l10n/l10n.dart';

class NFTownerCard extends StatelessWidget {

  const NFTownerCard({
    Key? key,
    required this.map
  }) : super(key: key);

  final Map<String,dynamic> map;

  @override 
  Widget build(BuildContext context) {
    final NFTOwner nftOwner = fromMapToNFTOwner(nftOwner: map);
    final text2Size = defaultHeaderTextSize(context: context) / cardTextDiv2;
    final text2 = TextStyle(
      fontSize: text2Size,
      fontWeight: FontWeight.bold
    );
    final L10n l10n = returnL10n(context: context)!;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: kTertiaryColor.withOpacity(cardOpacity),
        ),
        borderRadius: BorderRadius.all(Radius.circular( defaultPadding(context: context) ))
      ),
      child: Padding(
        padding: EdgeInsets.all( defaultPadding(context: context) ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nftOwner.userName,
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: defaultHeaderTextSize(context: context)/cardTextDiv2 ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: defaultPadding(context: context)/2.0 ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'number${nftOwner.number.toString()}',
                  style: text2
                ),
                SizedBox(width: defaultPadding(context: context)/2.0),
                Text(
                  nftOwner.lastEthPrice.toString(),
                  style: text2,
                ),
                SizedBox(width: defaultPadding(context: context)/2.0 ),
                InkWell(
                  child: Icon(Icons.link,size: text2Size* 1.5,),
                  onTap: () async {
                    final String link = nftOwner.link;
                    await canLaunchUrlString(link) ? await launchUrlString(link) : showBasicFlutterToast(context: context, msg: l10n.invalidLink );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
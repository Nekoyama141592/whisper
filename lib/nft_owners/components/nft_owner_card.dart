// material
import 'package:flutter/material.dart';
// packages
import 'package:url_launcher/url_launcher.dart';
// constants
import 'package:whisper/constants/strings.dart';

class NFTownerCard extends StatelessWidget {

  const NFTownerCard({
    Key? key,
    required this.map
  }) : super(key: key);

  final Map<String,dynamic> map;

  @override 
  Widget build(BuildContext context) {
    final int x = map[ethPriceKey];
    final double doubleX = x.toDouble()/10000;
    
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(4.0))
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    map[userNameKey],
                    style: TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'number' + map[numberKey].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        doubleX.toString() + "ETH",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5.0),
                      InkWell(
                        child: Icon(Icons.link),
                        onTap: () async {
                          final String link = map[linkKey];
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
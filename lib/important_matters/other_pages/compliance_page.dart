// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/important_matters/components/h2_text.dart';

class CompliancePage extends StatelessWidget {

  const CompliancePage({
    Key? key
  }) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('コンプライアンスポリシー'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15.0)
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Text('このコンプライアンスポリシーは,開発者の松岡巧馬（以下、「開発者」といいます。）がこのアプリ上で提供するサービス（以下，「本サービス」といいます。）のコンプライアンスポリシーを定めるものです。'),
            H2Text(text: '第１条 （会社の使命）'),
            Text('開発者は人々が健康で文化的な生活を送れるようにサポートすることを使命としています。'),
            H2Text(text: '第２条 （社会的責任）'),
            Text('開発者は、社会の構成員としての自覚をもち社会の要請にこたえ、倫理にもとることのなく責任のある行動をとるように心がけます。'),
            H2Text(text: '第３条 （法令遵守）'),
            Text('開発者は、活動に関係する法令、条例、通達および規程等につき、その趣旨、目的を理解し、これを遵守します。'),
            H2Text(text: '第4条 （個人情報の保護）'),
            Text('開発者は、適正・適法な個人情報の使用を心がけ、その情報の漏えい・毀損・滅失防止に万全を期します。'),
            H2Text(text: '第5条 （反社会的勢力の排除）'),
            Text('開発者は、暴力団をはじめとした反社会的勢力と一切の関わりをもちません。反社会的勢力が当社に関わりを求めてくる場合は、毅然とした態度でこれを拒絶します。'),
            H2Text(text: '第6条 （贈答・接待の受領）'),
            Text('開発者は、社会通念上相当と認められる程度を超えた水準の贈答・接待は受容しません。'),
            SizedBox(height: 20.0),
            Text('2021/10/25制定')
          ],
        ),
      ),
    );
  }
}
// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/important_matters/components/h2_text.dart';
import 'package:whisper/important_matters/components/h3_text.dart';
class PrivacyPage extends StatelessWidget {

  const PrivacyPage({
    Key? key
  }) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('プライバシーポリシー'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15.0)
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('このプライバシーポリシーは,開発者の松岡巧馬（以下、「開発者」といいます。）がこのアプリ上で提供するサービス（以下，「本サービス」といいます。）のプライバシーポリシーを定めるものです。'),
              H2Text(text: '1.プライバシーポリシー'),
              Text('開発者は下記の「プライバシーポリシー」に基づき、お客様の個人情報を取り扱い、取得した個人情報の取扱いに関し、個人情報の保護に関する法律、個人情報保護に関するガイドライン等の指針、その他個人情報保護に関する関係法令を遵守します。'),
              Text('お客様に置かれましては、開発者が運営するサービス（以下あわせて「本サービス」といいます）のご利用のため、下記の「プライバシーポリシー」をご熟読ください。'),
              H2Text(text: '2.個人情報の安全管理'),
              Text('開発者は、個人情報の保護に関して、組織的、物理的、人的、技術的に適切な対策を実施し、当社の取り扱う個人情報の漏えい、滅失又はき損の防止その他の個人情報の安全管理のために必要かつ適切な措置を講ずるものとします。'),
              H2Text(text: '３.個人情報の取得等の遵守事項'),
              Text('開発者による個人情報の取得、利用、提供については、以下の事項を遵守します。'),
              H3Text(text: '(1)個人情報の取得'),
              Text('開発者は、開発者が管理するインターネットによる情報提供アプリ（以下「本アプリ」といいます。）の運営に必要な範囲で、本アプリの一般利用者（以下「ユーザー」といいます。）又は本アプリに広告掲載を行う者（以下「掲載主」といいます。）から、ユーザー又は掲載主に係る個人情報を取得することがあります。'),
              H3Text(text: '(2)個人情報の利用目的'),
              Text('開発者は、開発者が取得した個人情報について、法令に定める場合又は本人の同意を得た場合を除き、以下に定める利用目的の達成に必要な範囲を超えて利用することはありません。'),
              Text('①　本アプリの運営、維持、管理'),
              Text('②　本アプリを通じたサービスの提供及び紹介'),
              H3Text(text: '(3)個人情報の提供等'),
              Text('開発者は、法令で定める場合を除き、本人の同意に基づき取得した個人情報を、本人の事前の同意なく第三者に提供することはありません。なお、本人の求めによる個人情報の開示、訂正、追加若しくは削除又は利用目的の通知については、法令に従いこれを行うとともに、ご意見、ご相談に関して適切に対応します。'),
              H2Text(text: '4 .個人情報の利用目的の変更'),
              Text('開発者は、前項で特定した利用目的は、予め本人の同意を得た場合を除くほかは、原則として変更しません。但し、変更前の利用目的と相当の関連性を有すると合理的に認められる範囲において、予め変更後の利用目的を公表の上で変更を行う場合はこの限りではありません。'),
              H2Text(text: '５.個人情報の第三者提供'),
              Text('開発者は、個人情報の取扱いの全部又は一部を第三者に委託する場合、その適格性を十分に審査し、その取扱いを委託された個人情報の安全管理が図られるよう、委託を受けた者に対する必要かつ適切な監督を行うこととします。'),
              H2Text(text: '６.個人情報の取扱いの改善・見直し'),
              Text('開発者は、個人情報の取扱い、管理体制及び取組みに関する点検を実施し、継続的に改善・見直しを行います。'),
              H2Text(text: '７.個人情報の廃棄'),
              Text('開発者は、個人情報の利用目的に照らしその必要性が失われたときは、個人情報を消去又は廃棄するものとし、当該消去及び廃棄は、外部流失等の危険を防止するために必要かつ適切な方法により、業務の遂行上必要な限りにおいて行います。'),
            ],
          ),
        ),
      ),
    );
  }
}
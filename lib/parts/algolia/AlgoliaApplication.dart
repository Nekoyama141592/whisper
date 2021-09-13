import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:algolia/algolia.dart';

class AlgoliaApplication{
  static final Algolia algolia = Algolia.init(
    applicationId: dotenv.env['ALGOLIA_APP_ID'].toString(), //ApplicationID
    apiKey: dotenv.env['ALGOLIA_ADMIN_API_KEY'].toString(), //search-only api key in flutter code
  );
}
import 'package:injectable/injectable.dart';

class HuntingResult {
  final String shopName;
  final String searchUrl;
  final String? promoQuery;

  HuntingResult({
    required this.shopName,
    required this.searchUrl,
    this.promoQuery,
  });
}

abstract class HuntingRepository {
  List<HuntingResult> getSearchSources(String query);
}

@LazySingleton(as: HuntingRepository)
class HuntingRepositoryImpl implements HuntingRepository {
  @override
  List<HuntingResult> getSearchSources(String query) {
    final encodedQuery = Uri.encodeComponent(query);
    final encodedPromoQuery = Uri.encodeComponent('$query promocja');

    return [
      HuntingResult(
        shopName: 'Allegro',
        searchUrl: 'https://allegro.pl/listing?string=$encodedQuery',
        promoQuery: 'https://allegro.pl/listing?string=$encodedPromoQuery',
      ),
      HuntingResult(
        shopName: 'OLX',
        searchUrl: 'https://www.olx.pl/oferty/q-$encodedQuery/',
      ),
      HuntingResult(
        shopName: 'Vinted',
        searchUrl: 'https://www.vinted.pl/catalog?search_text=$encodedQuery',
      ),
      HuntingResult(
        shopName: 'eBay',
        searchUrl: 'https://www.ebay.com/sch/i.html?_nkw=$encodedQuery',
      ),
      HuntingResult(
        shopName: 'Amazon',
        searchUrl: 'https://www.amazon.com/s?k=$encodedQuery',
      ),
      HuntingResult(
        shopName: 'Hot Wheels Polska',
        searchUrl: 'https://www.google.com/search?q=$encodedQuery+hot+wheels+polska',
      ),
    ];
  }
}

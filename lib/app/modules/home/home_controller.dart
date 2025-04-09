import 'package:apitayari/app/data/api_provider.dart';
import 'package:apitayari/app/models/country_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList<CountryModel> countryList = RxList();

  RxList<String> countryFirstStringList = RxList();

  late ApiProvider _apiProvider;

  @override
  void onInit() {
    // TODO: implement onInit
    _apiProvider = ApiProvider();
    super.onInit();
  }

  Future getData() async {
    var data = await _apiProvider.getData();

    if (data.isNotEmpty) {
      countryList.value = data;

      for (var country in countryList) {
        for (var element in country.tld) {
          countryFirstStringList.add(element);
        }
      }

      countryList.forEach((country) {
        country.tld.forEach((element) {
          countryFirstStringList.add(element);
        });
      });
    }else{
      print("No country data");
    }
  }
}

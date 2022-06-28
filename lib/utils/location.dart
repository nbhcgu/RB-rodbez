import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LOCATION {
  Future<List> getCountryName() async {
    List ret = [];
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('location: ${position.latitude}');
    String? loc = "en";
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    String? address="";
    if(placemarks.length>0){
      address = "${placemarks[0].locality} ${placemarks[0].subAdministrativeArea} ${placemarks[0].administrativeArea}";
      print(placemarks[0].locality);
      print(placemarks[0].name);
      print(placemarks[0].administrativeArea);
      print(placemarks[0].street);
      print(placemarks[0].subAdministrativeArea);
      print(placemarks[0].postalCode);
      print(placemarks[0].subLocality);
    }
    ret.add(position.latitude);
    ret.add(position.longitude);
    ret.add(address);
    print(ret);
    print(address);
    return ret; // this will return country name
  }
}

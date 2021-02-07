import 'package:geolocator/geolocator.dart';
import 'package:sms_maintained/sms.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Services {
  final String sehir;
  final String tarih;
  final String saat;
  final String buyukluk;

  Services({this.sehir,this.tarih,this.saat,this.buyukluk});

  factory Services.fromJson(Map<String,dynamic> json){
    return Services(sehir: json["sehir"],tarih: json["tarih"],saat: json["saat"],buyukluk: json["buyukluk"]);
  }

  Future<List<Services>> api()async{
    var url = "https://turkiyedepremapi.herokuapp.com/api";
    var res = await http.get(url);
    var list= List<Services>();
    if(res.statusCode==200){
      var notjson = json.decode(res.body);
      for(var notjson in notjson){
        list.add(Services.fromJson(notjson));
      }
    }
    return list;
  }

  sendSms(String number, String location) {
    String mes = "Konum: \n\n $location";

    SmsSender sender = SmsSender();
    SmsMessage message = SmsMessage(number, mes);
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);
  }

  Future<String> getCurrentLocation() async {
    String location;
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    location =
        "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
    return location;
  }
}

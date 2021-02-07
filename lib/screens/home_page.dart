import 'package:enkom/constants/colors.dart';
import 'package:enkom/screens/contacts_page.dart';
import 'package:enkom/screens/select_city_page.dart';
import 'package:enkom/services/services.dart';
import 'package:enkom/widgets/background_image.dart';
import 'package:enkom/widgets/page_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Services> service = List<Services>();
  String stringCityValue;
  String stringContactValue;



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Services().api().then((value) {
        service.addAll(value);
        depremVarsaSmsGonder();
      }),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          getCityValueSF();
          getContactValueSF();
          return waitingBody(context);
        }else{
          return buildBody(context);
        }
      },
    );
  }


  depremVarsaSmsGonder() {
    for (int i = 10; i >= 0; i--) {
      if (service[i].sehir == "(${currentCity.toString().toUpperCase()})") {
        Services().getCurrentLocation().then((value) {
          Services().sendSms(contactMessage.phones[0].value.toString(), value);
        });

        print("deprem oldu");
        break;
      }

    }
  }

  buildBody(BuildContext context) {
    return Scaffold(
      body: back(
        SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.person_pin_circle,
                        color: orange,
                        size: 60,
                      ),
                      Text(
                        "ENKON",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: orange,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 25, horizontal: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Seçilen Şehir",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        stringCityValue.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: orange,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 25, horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Seçilen Kişi",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        stringContactValue.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          currentCity = null;
          pageRoute(SelectCityPage(), context, -1.0);
        },
        backgroundColor: orange,
        child: Icon(Icons.autorenew),
      ),
    );
  }

  waitingBody(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          currentCity = null;
          pageRoute(SelectCityPage(), context, -1.0);
        },
        backgroundColor: orange,
        child: Icon(Icons.autorenew),
      ),
      body: back(
        SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.person_pin_circle,
                        color: orange,
                        size: 60,
                      ),
                      Text(
                        "ENKON",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 200.0),
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getCityValueSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    stringCityValue = prefs.getString('Sehir');
    return stringCityValue;
  }

  getContactValueSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    stringContactValue = prefs.getString('Kisi');
    return stringContactValue;
  }
}
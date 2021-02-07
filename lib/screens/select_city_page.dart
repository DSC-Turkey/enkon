import 'package:enkom/constants/cities.dart';
import 'package:enkom/constants/colors.dart';
import 'package:enkom/widgets/background_image.dart';
import 'package:enkom/widgets/page_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'contacts_page.dart';

var currentCity;

class SelectCityPage extends StatefulWidget {
  @override
  _SelectCityPageState createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  var mySharedPreferences;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sf) => {
          mySharedPreferences = sf,
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: back(
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 80),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_pin_circle,
                    color: orange,
                    size: 100,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 50, right: 15, left: 15, bottom: 10),
                    child: Text(
                      "Devam Etmeden Önce Bir Şehir Seç",
                      style: TextStyle(fontSize: 30, color: white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: currentCity,
                            isExpanded: false,
                            hint: Text(
                              "Şehirler",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            items: cityList.map((String cities) {
                              return DropdownMenuItem(
                                value: cities,
                                child: Row(
                                  children: [
                                    Text(
                                      cities,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(
                                () {
                                  currentCity = newValue;
                                },
                              );
                            },
                          ),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 130, bottom: 40),
                    child: ButtonTheme(
                      height: 50,
                      child: RaisedButton(
                        color: orange,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          "Devam Et",
                          style: TextStyle(fontSize: 25, color: white),
                        ),
                        onPressed: () async {
                          await (mySharedPreferences as SharedPreferences)
                              .setString("Sehir", currentCity);
                          await (mySharedPreferences as SharedPreferences)
                              .setBool("isLogin", true);
                          pageRoute(ContactsPage(), context, 1.0);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

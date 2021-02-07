import 'dart:async';
import 'package:enkom/constants/colors.dart';
import 'package:enkom/screens/home_page.dart';
import 'package:enkom/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Contact contactMessage;

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {

  var currentCity;
  var mySharedPreferences;
  List<Contact> listContacts;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sf) => {
      mySharedPreferences = sf,
    });
    listContacts = List();
    readContacts();
  }



  @override
  Widget build(BuildContext context) {
    List<bool> _selected = List.generate(listContacts.length, (index) => true);

    return Scaffold(
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
                Text("Afet durumunda mesaj atılacak kişiyi seçiniz",style: TextStyle(color: Colors.white,fontSize: 15),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: (listContacts.length > 0)
                        ? ListView.builder(
                      itemCount: listContacts.length,
                      itemBuilder: (context, index) {
                        Contact contact = listContacts.get(index);

                        return Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Card(
                            color: _selected[index] == true
                                ? Colors.white
                                : orange,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: orange,
                                child: Center(
                                  child: (contact.avatar != null)
                                      ? Container(
                                      width: 190.0,
                                      height: 190.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new MemoryImage(
                                                contact.avatar),
                                          )))
                                      : Icon(
                                    Icons.face,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onTap: () {
                                return showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text('${contact.displayName} Kişisini seçmek istediğinize emin misiniz ?',style: TextStyle(color: black,fontWeight: FontWeight.w300),),
                                        actions: [
                                          RaisedButton(
                                              color: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text("İptal",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                              onPressed: (){
                                                Navigator.pop(context);
                                              }),
                                          RaisedButton(
                                              color: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text("Devam",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                              onPressed: () async{
                                                await (mySharedPreferences as SharedPreferences)
                                                    .setString("Kisi", contact.displayName.toString());
                                                contactMessage = listContacts.get(index);
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));//selectedContactName: contact.displayName
                                              }),
                                        ],
                                      );
                                    }
                                );
                              },
                              title: Text("${contact.displayName}"),
                            ),
                          ),
                        );
                      },
                    )
                        : Padding(
                      padding:  EdgeInsets.only(top:150.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            backgroundColor: orange,
                          ),
                          Padding(
                            padding:  EdgeInsets.only(top:8.0),
                            child: Text("Rehber Okunuyor...",style: TextStyle(color: Colors.white,fontSize: 20),),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  readContacts() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Contacts.streamContacts().forEach((contact) {
        setState(() {
          listContacts.add(contact);
        });
      });
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }
}

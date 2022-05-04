import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/widget/build_title.dart';
import 'package:co_sport_map/widget/input_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';

import '../../../widget/button.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _hiddenSwitch = true;
  bool _loading = false;
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController bioTextEditingController = TextEditingController();
  TextEditingController phoneNumberTextEditingController =
      TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();
  int age = 0;
  final db = FirebaseFirestore.instance;
  StreamSubscription? sub;
  String? _chosenAgeCategory;
  Map data = <dynamic, dynamic>{};
  @override
  void initState() {
    super.initState();
    sub = db
        .collection('users')
        .doc(Constants.prefs!.getString('userId'))
        .snapshots()
        .listen((snap) {
      setState(() {
        data = snap.data()!;
        nameTextEditingController.text = data['name'];
        bioTextEditingController.text = data['bio'];
        _chosenAgeCategory = data['age'];
        locationTextEditingController.text = data['location'];
        phoneNumberTextEditingController.text = data['phoneNumber']['ph'];
        _hiddenSwitch = data['phoneNumber']['show'];
        _loading = true;
      });
    });
  }

  @override
  void dispose() {
    sub!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ageList = DropdownButton(
      hint: const Text("Age"),
      elevation: 1,
      value: _chosenAgeCategory,
      items: const [
        DropdownMenuItem(
          child: Text(
            "14",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          value: "14",
        ),
        DropdownMenuItem(
          child: Text(
            "16",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          value: "16",
        ),
        DropdownMenuItem(
            child: Text(
              "19",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            value: "19"),
        DropdownMenuItem(
            child: Text(
              "21",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            value: "21"),
        DropdownMenuItem(
            child: Text(
              "Открыть",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            value: "Открыть"),
      ],
      onChanged: (value) {
        setState(
          () {
            _chosenAgeCategory = value as String;
          },
        );
      },
    );

    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: buildTitle(context, "Редактировать профиль"),
          leading: const BackButton(),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height -
              56 -
              MediaQuery.of(context).padding.top,
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: Stack(
                    children: [
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(40)),
                          image: DecorationImage(
                            image: NetworkImage(Constants.prefs!
                                .getString('profileImage') as String),
                            fit: BoxFit.fill,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x3A353580),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                InputBox(
                  controller: nameTextEditingController,
                  textInputType: TextInputType.name,
                  hintText: 'Имя',
                  maxLength: 36,
                ),
                InputBox(
                  maxLength: 100,
                  controller: bioTextEditingController,
                  textInputType: TextInputType.multiline,
                  helpertext: 'Максимум 100 символов',
                  hintText: 'Информация о пользователе',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                      border: Border.all(color: const Color(0x00000000)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: ageList,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: InputBox(
                        controller: phoneNumberTextEditingController,
                        textInputType: TextInputType.phone,
                        hintText: 'Номер телеофона',
                        maxLength: 12,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Показать',
                          style: TextStyle(fontSize: 12),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeColor: Theme.of(context).primaryColor,
                            value: _hiddenSwitch,
                            onChanged: (value) {
                              setState(() {
                                _hiddenSwitch = value;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                InputBox(
                  controller: locationTextEditingController,
                  textInputType: TextInputType.streetAddress,
                  hintText: 'Город',
                  maxLength: 100,
                ),
                Button(
                  myText: 'Сохранить изменения',
                  myColor: Theme.of(context).primaryColor,
                  onPressed: () async {
                    Map<String, dynamic> phoneNumber = {
                      "ph": phoneNumberTextEditingController.text,
                      "show": _hiddenSwitch,
                    };
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(Constants.prefs!.get('userId') as String)
                        .update({
                      'profileImage':
                          Constants.prefs!.getString('profileImage'),
                      'name': nameTextEditingController.text,
                      'bio': bioTextEditingController.text,
                      'age': _chosenAgeCategory,
                      'phoneNumber': phoneNumber,
                      'location': locationTextEditingController.text,
                    });

                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return const Loader();
    }
  }
}

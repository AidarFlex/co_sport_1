import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_sport_map/services/event_service.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/utils/theme_config.dart';
import 'package:co_sport_map/utils/validations.dart';
import 'package:co_sport_map/widget/build_botton_navigation_bar.dart';
import 'package:co_sport_map/widget/build_title.dart';
import 'package:co_sport_map/widget/button.dart';
import 'package:co_sport_map/widget/date_time_picker.dart';
import 'package:co_sport_map/widget/input_box.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

String userId = Constants.prefs!.getString('userId') as String;
String name = Constants.prefs!.getString('name') as String;

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final GlobalKey<FormState> _addpostkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _datetime = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? _chosenSport;
  double _maxMembers = 2;
  int _type = 1;
  String _status = 'team';
  final PageController _addPostPageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    var sportsList = DropdownButton(
      hint: const Text("Спорт"),
      elevation: 1,
      value: _chosenSport = 'Basketball',
      items: const [
        DropdownMenuItem(
          child: Text(
            "Баскетболл",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          value: "Basketball",
        ),
        DropdownMenuItem(
          child: Text(
            "Футбол",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          value: "Football",
        ),
        DropdownMenuItem(
            child: Text(
              "Волейболл",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            value: "Volleyball"),
        DropdownMenuItem(
            child: Text(
              "Крикет",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            value: "Cricket")
      ],
      onChanged: (value) {
        setState(
          () {
            _chosenSport = value as String;
          },
        );
      },
    );

    var slider = Slider(
      value: _maxMembers,
      onChanged: (newLimit) {
        setState(() => _maxMembers = newLimit);
      },
      min: 2,
      max: 50,
      label: _maxMembers.toInt().toString(),
      divisions: 48,
    );
    var publicRadio = RadioListTile(
      groupValue: _type,
      title: const Text('Открытая'),
      value: 1,
      onChanged: (val) {
        setState(() => _type = val as int);
      },
    );
    var privateRadio = RadioListTile(
      groupValue: _type,
      title: const Text('Закрытая'),
      value: 2,
      onChanged: (val) {
        setState(() => _type = val as int);
      },
    );
    var teamRadio = RadioListTile(
      groupValue: _status,
      title: const Text('Команды'),
      value: 'team',
      onChanged: (val) {
        setState(() => _status = val as String);
      },
    );
    var individualRadio = RadioListTile(
      groupValue: _status,
      title: const Text('Индивидуальная'),
      value: 'individual',
      onChanged: (val) {
        setState(() => _status = val as String);
      },
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const BackButton(),
        title: buildTitle(context, "Создать мероприятие"),
      ),
      body: PageView(
        controller: _addPostPageController,
        children: [
          Page1(
            theme: theme,
            addpostkey: _addpostkey,
            nameController: _nameController,
            sportsList: sportsList,
            datetime: _datetime,
            locationController: _locationController,
            descController: _descController,
            slider: slider,
            chosenSport: _chosenSport!,
            maxMembers: _maxMembers,
            status: _status,
            type: _type,
            publicRadio: publicRadio,
            privateRadio: privateRadio,
            teamRadio: teamRadio,
            individualRadio: individualRadio,
          ),
        ],
      ),
    );
  }
}

class Page1 extends StatefulWidget {
  final GlobalKey<FormState> _addpostkey;
  final TextEditingController _nameController;
  final ThemeNotifier theme;
  final DropdownButton<String> sportsList;
  final TextEditingController _datetime;
  final TextEditingController _locationController;
  final TextEditingController _descController;
  final Slider slider;
  final String _chosenSport;
  final double _maxMembers;
  final int _type;
  final String _status;
  final RadioListTile publicRadio;
  final RadioListTile privateRadio;
  final RadioListTile teamRadio;
  final RadioListTile individualRadio;

  const Page1({
    Key? key,
    required GlobalKey<FormState> addpostkey,
    required TextEditingController nameController,
    required this.theme,
    required this.sportsList,
    required TextEditingController datetime,
    required TextEditingController locationController,
    required TextEditingController descController,
    required this.slider,
    required String chosenSport,
    required double maxMembers,
    required int type,
    required String status,
    required this.publicRadio,
    required this.privateRadio,
    required this.teamRadio,
    required this.individualRadio,
  })  : _addpostkey = addpostkey,
        _nameController = nameController,
        _datetime = datetime,
        _locationController = locationController,
        _descController = descController,
        _chosenSport = chosenSport,
        _maxMembers = maxMembers,
        _status = status,
        _type = type,
        super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final db = FirebaseFirestore.instance;
  late StreamSubscription sub;
  Map data = <dynamic, dynamic>{};
  int userTokens = 0;
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
        userTokens = data['eventTokens'];
      });
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.72),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: widget._addpostkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                InputBox(
                  controller: widget._nameController,
                  hintText: "Название эвента",
                  validateFunction: Validations.validateName,
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
                      child: widget.sportsList,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DateTimePicker(
                    controller: widget._datetime,
                  ),
                ),
                InputBox(
                  controller: widget._locationController,
                  hintText: "Мактама",
                  labelText: "Местоположение",
                  validateFunction: Validations.validateName,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextField(
                      controller: widget._descController,
                      // maxLengthEnforced: false,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Описание",
                        hintText: "что то с чем то",
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //max member slider
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Выберите количество участников',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.35),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            widget._maxMembers.toInt().toString(),
                            style: TextStyle(
                              color: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.55),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    widget.slider,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 4.0),
                      child: Row(
                        children: [
                          Text(
                            'Статус',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.35),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    widget.publicRadio,
                    widget.privateRadio,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 4.0),
                      child: Row(
                        children: [
                          Text(
                            'Кто может присоединиться к эвенту?',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.35),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    widget.teamRadio,
                    widget.individualRadio,
                  ],
                ),
                Button(
                  myText: "Создать эвент",
                  myColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (widget._addpostkey.currentState!.validate()) {
                      createNewEvent(
                        widget._nameController.text,
                        userId,
                        name,
                        widget._locationController.text,
                        widget._chosenSport,
                        widget._descController.text,
                        [userId],
                        DateTime.parse(widget._datetime.text),
                        widget._maxMembers.toInt(),
                        widget._status,
                        widget._type,
                        false,
                      );
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AnimatedBottomBar()));
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return inValid(context);
                        },
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

SimpleDialog inValid(BuildContext context) {
  return SimpleDialog(
    title: Column(
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child: Icon(
            FeatherIcons.info,
            size: 64,
          )),
        ),
        Center(child: Text("Неверный ввод")),
      ],
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Text("Пожалуйста, повторите попытку",
                style: Theme.of(context).textTheme.subtitle1)),
      ),
    ],
  );
}

import 'package:co_sport_map/services/event_service.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/widget/build_title.dart';
import 'package:co_sport_map/widget/button.dart';
import 'package:co_sport_map/widget/date_time_picker.dart';
import 'package:co_sport_map/widget/input_box.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatSchedule extends StatefulWidget {
  final String chatRoomId;
  final List<dynamic> usersNames;
  final List<dynamic> users;
  const ChatSchedule(
      {required this.chatRoomId,
      required this.usersNames,
      required this.users,
      Key? key})
      : super(key: key);
  @override
  _ChatScheduleState createState() => _ChatScheduleState();
}

class _ChatScheduleState extends State<ChatSchedule> {
  SimpleDialog successDialog(BuildContext context) {
    return SimpleDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      children: [
        Center(
            child: Text("Добавлено в расписание",
                style: Theme.of(context).textTheme.headline4)),
        Image.asset("assets/confirmation-illustration.png"),
      ],
    );
  }

  final GlobalKey<FormState> _addpostkey = GlobalKey<FormState>();
  String _chosenSport = '';
  TextEditingController _locationController = TextEditingController();
  TextEditingController _datetime = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var sportsList = DropdownButton(
      hint: const Text("Спорт"),
      value: _chosenSport,
      items: const [
        DropdownMenuItem(
          child: Text("Basketball"),
          value: "Basketball",
        ),
        DropdownMenuItem(
          child: Text("Football"),
          value: "Football",
        ),
        DropdownMenuItem(child: Text("Volleyball"), value: "Volleyball"),
        DropdownMenuItem(child: Text("Cricket"), value: "Cricket")
      ],
      onChanged: (value) {
        setState(
          () {
            _chosenSport = value as String;
          },
        );
      },
    );
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: addPostSliverAppBar,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Form(
                    key: _addpostkey,
                    child: Column(
                      children: [
                        InputBox(
                            controller: _nameController,
                            hintText: "Название эвента"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: sportsList,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DateTimePicker(
                            controller: _datetime,
                          ),
                        ),
                        InputBox(
                          controller: _locationController,
                          hintText: "Местоположение",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: TextField(
                              controller: _descriptionController,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                labelText: "Описание",
                                hintText: "Что то с чем то",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Button(
                    myText: "График",
                    myColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      var newDoc =
                          FirebaseDatabase.instance.ref('events').push();
                      String id = newDoc.key.toString();
                      for (int i = 0; i < widget.users.length; i++) {
                        addScheduleToUser(
                          widget.users[i],
                          _nameController.text,
                          _chosenSport,
                          _locationController.text,
                          DateTime.parse(_datetime.text),
                          Constants.prefs.getString('userId') as String,
                          Constants.prefs.getString('name') as String,
                          id,
                          'chatroom',
                          4,
                          widget.users,
                        );
                      }
                      showDialog(
                        context: context,
                        builder: (context) {
                          return successDialog(context);
                        },
                      );
                      setState(() {
                        _locationController = TextEditingController();
                        _datetime = TextEditingController();
                        _nameController = TextEditingController();
                        _descriptionController = TextEditingController();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> addPostSliverAppBar(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        expandedHeight: 250.0,
        leading: const BackButton(),
        elevation: 0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Container(
              child: buildTitle(context, "График"),
              color: Theme.of(context).canvasColor.withOpacity(0.5)),
          background: const Image(
            height: 200,
            image: AssetImage('assets/addpostillustration.png'),
          ),
        ),
      ),
    ];
  }
}

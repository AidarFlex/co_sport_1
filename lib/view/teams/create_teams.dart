import 'package:co_sport_map/models/teams.dart';
import 'package:co_sport_map/services/team_services.dart';
import 'package:co_sport_map/utils/validations.dart';
import 'package:co_sport_map/view/chats/invite_friends.dart';
import 'package:co_sport_map/widget/build_title.dart';
import 'package:co_sport_map/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../widget/input_box.dart';

class CreateTeam extends StatefulWidget {
  const CreateTeam({Key? key}) : super(key: key);

  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  final GlobalKey<FormState> _createNewTeamkey = GlobalKey<FormState>();
  String _chosenSport = '';
  late Teams team;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _teamLocationController = TextEditingController();
  String _type = "public";
  @override
  Widget build(BuildContext context) {
    var sportsList = DropdownButton(
      hint: const Text("Спорт"),
      value: _chosenSport = 'Basketball',
      items: const [
        DropdownMenuItem(
          child: Text("Баскетбол"),
          value: "Basketball",
        ),
        DropdownMenuItem(
          child: Text("Футбол"),
          value: "Football",
        ),
        DropdownMenuItem(child: Text("Волейбол"), value: "Volleyball"),
        DropdownMenuItem(child: Text("Крикет"), value: "Cricket")
      ],
      onChanged: (value) {
        setState(
          () {
            _chosenSport = value as String;
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: buildTitle(context, "Создайте новую команду"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _createNewTeamkey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  InputBox(
                    controller: _nameController,
                    hintText: "Название команды",
                    validateFunction: Validations.validateName,
                    maxLength: 24,
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
                        child: sportsList,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: TextFormField(
                        controller: _descController,
                        maxLength: 200,
                        validator: Validations.validateName,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: "Описание",
                          hintText: "Наша команда...",
                        ),
                      ),
                    ),
                  ),
                  InputBox(
                    controller: _teamLocationController,
                    hintText: "Локация команды",
                    validateFunction: Validations.validateName,
                    maxLength: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 4.0),
                    child: Row(
                      children: [
                        Text(
                          'Тип команды',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36.0),
                    child: Card(
                      child: ListTile(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        title: const Text(
                          'Открытая',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        selected: _type == "public" ? true : false,
                        onTap: () {
                          setState(() {
                            _type = "public";
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36.0),
                    child: Card(
                      child: ListTile(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        title: const Text(
                          'Закрытая',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        selected: _type == "private" ? true : false,
                        onTap: () {
                          setState(() {
                            _type = "private";
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Button(
                myText: "Созать команду",
                myColor: Theme.of(context).primaryColor,
                onPressed: () {
                  if (_createNewTeamkey.currentState!.validate()) {
                    team = TeamService().createNewTeam(_chosenSport,
                        _nameController.text, _descController.text, _type);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InviteFriends(team: team)));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return inValidInput(context);
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 72,
            )
          ],
        ),
      ),
    );
  }
}

SimpleDialog successDialog(BuildContext context) {
  return SimpleDialog(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    children: [
      Center(
          child: Text("Создать команду",
              style: Theme.of(context).textTheme.headline4)),
      Image.asset("assets/confirmation-illustration.png"),
    ],
  );
}

SimpleDialog inValidInput(BuildContext context) {
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
        Center(child: Text("Повторите попытку")),
      ],
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Text("Указанный ввод неверен, пожалуйста, повторите попытку",
                style: Theme.of(context).textTheme.subtitle1)),
      ),
    ],
  );
}

import 'package:flutter/material.dart';

import '../database/my_database.dart';
import '../model/city_model.dart';

class AddUser extends StatefulWidget {
  AddUser(this.map, {super.key});

  Map<String, Object?>? map;

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  var formKey = GlobalKey<FormState>();

  // var idController = TextEditingController();
  var AgeController = TextEditingController();
  var UserNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    UserNameController.text =
    widget.map == null ? '' : widget.map!['UserName'].toString();
    AgeController.text =
    widget.map == null ? '' : widget.map!['Age'].toString();
  }

  CityModel?  _ddSelectedValue;
  bool isCityListGet = true;
  int position = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.map?["UserID"] == null ? "Add User" : "Update User"),
        backgroundColor: Colors.purple,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              FutureBuilder<List<CityModel>>(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if(isCityListGet) {
                      if (widget.map?["UserID"] == null) {
                        _ddSelectedValue = snapshot.data![position];
                      }
                      else {
                        position = getPosition(snapshot.data);
                        _ddSelectedValue = snapshot.data![position];
                      }
                    }
                    isCityListGet = false;
                    // _ddSelectedValue = snapshot.data![0];
                    return DropdownButton(
                      value: _ddSelectedValue,
                      items: snapshot.data!.map((CityModel e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e.Name.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _ddSelectedValue = value;
                        });
                      },
                    );
                  } else {
                    return Container();
                  }
                },
                future: isCityListGet?MyDatabase().getCityList():null,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Enter UserName"),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Enter Valid UserName";
                  }
                },
                controller: UserNameController,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Enter Age"),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Enter Valid Age";
                  }
                },
                controller: AgeController,
              ),
              Container(
                child: ElevatedButton(
                  child: Text(widget.map?["UserID"] == null ? "Add" : "Edit"),
                  onPressed: () async{
                    if (formKey.currentState!.validate()) {
                      if (widget.map == null) {
                        await insertUser()
                            .then((value) => Navigator.of(context).pop(true));
                      }
                      else {
                        await updateUser(widget.map!["UserID"]).then((value) => Navigator.of(context).pop());
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
    return const Placeholder();
  }
  Future<int> insertUser() async {
    Map<String, dynamic> map = {};
    map['Name'] = UserNameController.text.toString();
    map['CityID'] = _ddSelectedValue!.CityID!;
    map['Age'] = AgeController.text;

    int userId = await MyDatabase().insertUserDetail(map);
    return userId;
  }

  int  getPosition(List) {
    for(int i=0; i<List.length; i++) {
      if(List[i].Name == widget.map!['CityName']) {
        return i;
      }
    }
    return 0;
  }

  Future<int> updateUser(id) async {
    Map<String, dynamic> map = {};
    map['Name'] = UserNameController.text.toString();
    map['CityID'] = _ddSelectedValue!.CityID!;
    map['Age'] = AgeController.text;

    int userId = await MyDatabase().updateUserDetail(map,id);
    return userId;
  }
}



import 'package:crud_db/Pages/add_user.dart';
import 'package:crud_db/database/my_database.dart';
import 'package:flutter/material.dart';

class DisplayPage extends StatefulWidget {
  const DisplayPage({Key? key}) : super(key: key);

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  @override
  void initState() {
    super.initState();
  }


  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("User Detail"),
          backgroundColor: Colors.purple,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () async {
                    await Navigator.of(context)
                        .push(MaterialPageRoute(
                      builder: (context) => AddUser(null),
                    ))
                        .then((value) {
                      setState(() {
                        MyDatabase().getUserListFromUserTable();
                      });
                    });
                  },
                  child: Icon(Icons.add)),
            )
          ],
        ),
        body: FutureBuilder<bool>(
          builder: (context, snapshot1) {
            if (snapshot1.hasData) {
              return FutureBuilder<List<Map<String, Object?>>>(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text((snapshot.data![index]["UserName"])
                                          .toString()),
                                      Text((snapshot.data![index]["CityName"])
                                          .toString()),
                                      Text((snapshot.data![index]["Age"])
                                          .toString()),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () async{
                                        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return AddUser(snapshot.data![index]);
                                        },)).then((value) {
                                          setState(() {
                                            MyDatabase().getUserListFromUserTable();
                                          });
                                        });
                                      },
                                      child: Icon(Icons.edit,color: Colors.yellow,)),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () async {
                                        print(snapshot.data![index]['UserID']);
                                        await deleteUser(snapshot.data![index]['UserID']).then((value) {
                                          setState(() {
                                          });
                                        });
                                      },
                                      child: Icon(Icons.delete,color: Colors.red,)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
                future: MyDatabase().getUserListFromUserTable(),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
          future: MyDatabase().copyPasteAssetFileToRoot(),
        ));

  }

  Future<int> deleteUser(id) async {
    int userId = await MyDatabase().deleteUserDetail(id);
    print("Database : $userId");
    return userId;
  }
}



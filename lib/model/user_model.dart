class UserModel {
  late String _UserName;
  late String _CityName;
  late int  _UserID;
  late int _Age;

  int get Age => _Age;

  set Age(int value) {
    _Age = value;
  }

  int get UserID => _UserID;

  set UserID(int UserID) {
    _UserID = UserID;
  }


  String get UserName => _UserName;

  set UserName(String UserName) {
    _UserName = UserName;
  }

  String get CityName => _CityName;

  set CityName(String CityName) {
    _CityName = CityName;
  }}

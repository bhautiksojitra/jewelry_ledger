import 'package:flutter/foundation.dart';

class UsersModel extends ChangeNotifier {
  List<String> _users = [];
  String _selectedUser = "";

  String get SelectedUser => _selectedUser;
  List<String> get Users => _users;

  void updateSelectedUser(String value) {
    if (_selectedUser != value) {
      _selectedUser = value;
      print(_selectedUser);
      notifyListeners();
    }
  }

  void updatedUsersList(List<String> users) {
    _users = users;
    print(users.toString());
    notifyListeners();
  }
}

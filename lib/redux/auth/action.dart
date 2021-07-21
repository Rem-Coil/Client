import 'package:slot_service_app/core/models/user.dart';

class SetUsersAction {
  final List<User> users;

  SetUsersAction(this.users);
}

class SetUserAction {
  final User user;

  SetUserAction(this.user);
}
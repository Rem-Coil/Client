import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:slot_service_app/core/models/user.dart';
import 'package:slot_service_app/redux/state.dart';
import 'package:slot_service_app/redux/user/thunk.dart';
import 'package:slot_service_app/ui/constants.dart';
import 'package:slot_service_app/ui/screens/login_screen/login_network_screen.dart';
import 'package:slot_service_app/ui/screens/login_screen/widgets/login_enter_button.dart';
import 'package:slot_service_app/ui/screens/login_screen/widgets/login_error_title.dart';
import 'package:slot_service_app/ui/screens/login_screen/widgets/login_password_field.dart';
import 'package:slot_service_app/ui/screens/login_screen/widgets/login_select_user_field.dart';
import 'package:slot_service_app/ui/screens/login_screen/widgets/login_title.dart';
import 'package:slot_service_app/ui/view_models/login.dart';
import 'package:slot_service_app/ui/widgets/login_container.dart';

class LoginScreen extends StatefulWidget {
  static const route = "/login";
  static const privacyLevel = EMPLOYEE_PRIVACY_LEVEL;

  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return LoginContainer(
      child: StoreConnector<AppState, LoginViewModel>(
        onInit: (store) => store.dispatch(OnGetUsers()),
        converter: (store) {
          final state = store.state;

          if (state.statusState.isLoad) {
            return LoginViewModel.load();
          }

          if (state.statusState.isError || state.authState.users.isEmpty) {
            return LoginViewModel.error(context: context);
          }

          if (!state.authState.isPasswordCorrect) {
            _errorMessage = 'Неверный пароль';
          }

          return LoginViewModel.success(
            users: state.authState.users,
            currentUser: state.authState.currentUser,
          );
        },
        builder: (context, vm) => vm.when(
          load: _onLoad,
          success: _onSuccess,
          error: _onError,
        ),
      ),
    );
  }

  Widget _onLoad() => Center(child: CircularProgressIndicator());

  Widget _onSuccess(List<User> users, User? currentUser) {
    return Column(
      children: [
        TitleWidget(),
        SizedBox(height: defaultPadding),
        SelectUserField(users: users, currentUser: currentUser),
        SizedBox(height: defaultPadding),
        PasswordField(controller: _controller),
        SizedBox(height: 5),
        ErrorTitle(errorMessage: _errorMessage),
        Spacer(),
        EnterButton(
          onWrongFields: _setErrorMessage,
          passwordController: _controller,
        ),
      ],
    );
  }

  Widget _onError(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    return Center(
      child: SizedBox(
        height: 180,
        child: Column(
          children: [
            Text(
              'Произошла ошибка загрузки данных, поробуйте позже или обратитесь к администратору',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  store.dispatch(NavigateToAction.push(LoginNetworkScreen.route)),
              child: Text('Поменять настроки'),
            ),
            TextButton(
              onPressed: () =>
                  store.dispatch(NavigateToAction.replace(LoginScreen.route)),
              child: Text('Обновить'),
            ),
          ],
        ),
      ),
    );
  }

  void _setErrorMessage(String? message) {
    setState(() {
      _errorMessage = message;
    });
  }
}

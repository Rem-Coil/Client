import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:slot_service_app/constants.dart';
import 'package:slot_service_app/core/repository/auth_repository.dart';
import 'package:slot_service_app/core/repository/base_repository.dart';
import 'package:slot_service_app/core/repository/boxes_repository.dart';
import 'package:slot_service_app/core/repository/employees_repository.dart';
import 'package:slot_service_app/core/repository/tasks_repository.dart';
import 'package:slot_service_app/redux/reducer.dart';
import 'package:slot_service_app/redux/state.dart';
import 'package:slot_service_app/screens/boxes_screen/boxes_screen.dart';
import 'package:slot_service_app/screens/employees_screen/employees_screen.dart';
import 'package:slot_service_app/screens/login_screen/login_screen.dart';
import 'package:slot_service_app/screens/logs_screen/logs_screen.dart';
import 'package:slot_service_app/screens/settings_screen/settings_screen.dart';
import 'package:slot_service_app/screens/tasks_screen/tasks_screen.dart';

void main() {
  runApp(RemCoilDashboardApp());
}

class RemCoilDashboardApp extends StatefulWidget {
  @override
  _RemCoilDashboardAppState createState() => _RemCoilDashboardAppState();
}

class _RemCoilDashboardAppState extends State<RemCoilDashboardApp> {
  Store<AppState>? _appStateHolder;

  Store<AppState> get _appState {
    if (_appStateHolder == null) {
      final taskThunkMiddleware = _getThunkMiddleware(TasksRepository());
      final boxThunkMiddleware = _getThunkMiddleware(BoxesRepository());
      final employeeThunkMiddleware =_getThunkMiddleware(EmployeesRepository());
      final authThunkMiddleware =_getThunkMiddleware(AuthRepository());

      _appStateHolder ??= Store<AppState>(
        appReducer,
        initialState: AppState.initState,
        middleware: [
          thunkMiddleware,
          taskThunkMiddleware,
          boxThunkMiddleware,
          employeeThunkMiddleware,
          authThunkMiddleware,
        ],
      );
    }
    return _appStateHolder!;
  }

  ExtraArgumentThunkMiddleware _getThunkMiddleware<T extends BaseRepository>(
      T repository,) {
    return ExtraArgumentThunkMiddleware<AppState, T>(repository);
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: _appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rem&Coil Slots Admin Panel',
        theme: ThemeData(
          canvasColor: bgColor,
          scaffoldBackgroundColor: bgColor,
          primaryColor: primaryColor,
        ),
        routes: {
          BoxesScreen.route: (context) => BoxesScreen(),
          LoginScreen.route: (context) => LoginScreen(),
          TasksScreen.route: (context) => TasksScreen(),
          EmployeesScreen.route: (context) => EmployeesScreen(),
          LogsScreen.route: (context) => LogsScreen(),
          SettingsScreen.route: (context) => SettingsScreen(),
        },
        initialRoute: LoginScreen.route,
      ),
    );
  }
}

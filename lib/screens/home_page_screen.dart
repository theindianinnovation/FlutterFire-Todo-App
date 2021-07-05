import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_todo_app/screens/documents_screen.dart';
import 'package:flutter_firebase_todo_app/screens/notes_screen.dart';
import 'package:flutter_firebase_todo_app/screens/user_info_screen.dart';


class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key key, User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Firebase Todo App'),
        ),
        body: TabBarView(
          children: [
            MyNotes(),
            UserInfoScreen(user:widget._user),
           DocumentsScreen() , // alternative TaskManager()

         ],
        ),
        bottomNavigationBar: TabBar(
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          tabs: [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.account_circle_outlined)),
            Tab(icon:Icon(Icons.file_present)),
            Tab(icon:Icon(Icons.ad_units_sharp))
          ],
        ),
      ),

    );
  }
}

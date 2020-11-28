import 'package:flutter/material.dart';

import '../Widgets/form.dart';

class ChangePassScreen extends StatelessWidget {
  static const RouteName = '/change-password';

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: AccountForm(
          pincode: data['pincode'],
          state: data['state'],
          addr2: data['addr2'],
          addr1: data['addr1'],
          email: data['email'],
          name: data['username'],
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider.dart';
import '../Widgets/app_drawer.dart';
import '../Widgets/form.dart' as f;

class ManageAccount extends StatelessWidget {
  static const RouteName = "/manage-account";
  var _name;
  var _email;
  var _addr1;
  var _addr2;
  var _state;
  var _pincode;
  void openModal(BuildContext ctx) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      context: ctx,
      builder: (_) {
        return Container(
          height: 400,
          padding: EdgeInsets.all(20),
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 0,
            ),
            child: f.AccountForm(
              name: _name,
              email: _email,
              addr1: _addr1,
              addr2: _addr2,
              state: _state,
              pincode: _pincode,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Account"),
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        // onPressed: () {
        //   Navigator.of(context).pushNamed(ChangePassScreen.RouteName,
        //       arguments: {'name': _name, 'email': _email});
        // },
        onPressed: () => openModal(context),
        child: Icon(Icons.edit),
      ),
      body: FutureBuilder(
        future: Provider.of<ProductProvider>(context).getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          _name = snapshot.data['username'];
          _email = snapshot.data['email'];
          _addr1 = snapshot.data['addr1'];
          _addr2 = snapshot.data['addr2'];
          _state = snapshot.data['state'];
          _pincode = snapshot.data['pincode'];
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green[50],
                    radius: 180,
                    child: CircleAvatar(
                      backgroundColor: Colors.green[100],
                      radius: 160,
                      child: CircleAvatar(
                        backgroundColor: Colors.green[200],
                        radius: 140,
                        child: CircleAvatar(
                          backgroundColor: Colors.green[300],
                          radius: 120,
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage:
                                NetworkImage(snapshot.data['image_url']),
                            child: IconButton(
                              icon: Icon(Icons.camera_enhance),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'UserName',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '$_name',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      '$_email',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'State',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      _state != null ? '$_state' : 'Not set yet !',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Address line 1',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      _addr1 != null ? '$_addr1' : 'Not set yet !',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Address line 2',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      _addr2 != null ? '$_addr2' : 'Not set yet !',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Pincode',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      _pincode != null ? '$_pincode' : 'Not set yet !',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

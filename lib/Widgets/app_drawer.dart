import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider.dart';
import '../Provider/themeProvider.dart';
import '../Screens/OrderScreen.dart';
import '../Screens/homeScreen.dart';
import '../Screens/manage_account.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final themeControl = Provider.of<ThemeProvider>(context, listen: false);
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 350,
            color: Theme.of(context).primaryColor,
            child: FutureBuilder(
              future: Provider.of<ProductProvider>(context).getUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black,
                    ),
                  );
                }

                return Column(
                  // alignment: Alignment.bottomCenter,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      minRadius: 120,
                      backgroundImage: snapshot.data != null
                          ? NetworkImage(snapshot.data['image_url'])
                          : AssetImage("Asset/Images/done.png"),
                    ),
                    Text(
                      snapshot.data != null
                          ? snapshot.data['username']
                          : "Name Loading..",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    snapshot.data['addr1'] == null
                        ? Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Please set you proper address in the Manage Account Section",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w200,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : Text(''),
                  ],
                );
              },
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductOverviewScreen.RouteName);
            },
            leading: Icon(
              Icons.shop_rounded,
              size: 30,
            ),
            title: Text(
              "Shop",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.RouteName);
            },
            leading: Icon(
              Icons.shopping_cart,
              size: 30,
            ),
            title: Text(
              "My Orders",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: Text(''),
          ),
          Divider(),
          ListTile(
            leading: themeControl.getTheme()
                ? Icon(Icons.nights_stay)
                : Icon(Icons.wb_sunny),
            title: themeControl.getTheme()
                ? Text(
                    "Dark Mode",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                : Text(
                    "Light Mode",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
            trailing: Switch(
              activeColor: Colors.blue,
              value: themeControl.getTheme(),
              onChanged: (bool newValue) {
                themeControl.setTheme(newValue);
              },
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ManageAccount.RouteName);
            },
            leading: Icon(
              Icons.account_box,
              size: 30,
            ),
            title: Text(
              "Manage Account",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              // Navigator.of(context).pushReplacementNamed(AuthScreen.RouteName);
              Phoenix.rebirth(context);
            },
            leading: Icon(
              Icons.logout,
              size: 30,
            ),
            title: Text(
              "Logout",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

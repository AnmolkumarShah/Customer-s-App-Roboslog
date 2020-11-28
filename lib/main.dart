import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Provider/ProductProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/services.dart";
import './Provider/cart_item.dart';
import './Provider/orders.dart';
import './Screens/CartScreen.dart';
import './Screens/ProductDetailsScreen.dart';
import './Screens/auth_screen.dart';
import './Screens/homeScreen.dart';
import './Screens/OrderScreen.dart';
import './Helpers/custom_route.dart';
import './SplashScreens/screen2.dart';
import './Screens/manage_account.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import './Screens/changePassScreen.dart';
import './Provider/themeProvider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        ),
      ],
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final _isDark = Provider.of<ThemeProvider>(context).getTheme();
    return MaterialApp(
      title: 'Customers App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: _isDark ? Colors.blueGrey : Colors.lightGreen,
        primaryColor: _isDark ? Colors.blueAccent : Colors.green,
        canvasColor: _isDark ? Colors.black : Colors.grey[50],
        backgroundColor: _isDark ? Colors.black : Colors.blueGrey,
        brightness: _isDark ? Brightness.dark : Brightness.light,
        accentColor: _isDark ? Colors.lightBlue : Colors.lightGreenAccent,
        // accentColorBrightness: Brightness.dark,
        fontFamily: 'Lato',
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.blue[50],
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
          },
        ),
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Scaffold(
                    body: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            Colors.lightGreen,
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                return Screen2();
              } else {
                return AuthScreen();
              }
            },
          );
        },
      ),
      routes: {
        ChangePassScreen.RouteName: (ctx) => ChangePassScreen(),
        AuthScreen.RouteName: (ctx) => AuthScreen(),
        ProductDetail.RouteName: (ctx) => ProductDetail(),
        ProductOverviewScreen.RouteName: (ctx) => ProductOverviewScreen(),
        CartScreen.RouteName: (ctx) => CartScreen(),
        OrderScreen.RouteName: (ctx) => OrderScreen(),
        ManageAccount.RouteName: (ctx) => ManageAccount(),
      },
    );
  }
}

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider.dart';
import '../Provider/cart_item.dart';
import '../Screens/CartScreen.dart';
import '../Widgets/app_drawer.dart';
import '../Widgets/products_grid.dart';

class ProductOverviewScreen extends StatefulWidget {
  static const RouteName = "/home-screen";
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFav = false;

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .getAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(color: Colors.white),
              expandedHeight: 400.0,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Shop",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Image.network(
                  "https://images.pexels.com/photos/919436/pexels-photo-919436.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                  fit: BoxFit.cover,
                ),
              ),
              actions: [
                Consumer<Cart>(
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.RouteName);
                    },
                  ),
                  builder: (context, cart, child) {
                    return Badge(
                      badgeColor: Theme.of(context).accentColor,
                      toAnimate: true,
                      position: BadgePosition.topEnd(top: 0, end: 3),
                      animationDuration: Duration(milliseconds: 400),
                      animationType: BadgeAnimationType.slide,
                      badgeContent: Text(
                        cart.itemCount.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      child: child,
                    );
                  },
                ),
                PopupMenuButton(
                  onSelected: (int value) {
                    setState(() {
                      if (value == 0) {
                        _showFav = true;
                      } else {
                        _showFav = false;
                      }
                    });
                  },
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("Only Favourite"),
                      value: 0,
                    ),
                    PopupMenuItem(
                      child: Text("Show All"),
                      value: 1,
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: FutureBuilder(
              future: Provider.of<ProductProvider>(context, listen: false)
                  .getAndSetProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            // "Something Went Wrong!!",
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed("/");
                            },
                            child: Text("Refresh"),
                          ),
                        ],
                      ),
                    );
                  }
                  return ProductsGrid(_showFav);
                }
              },
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}

//

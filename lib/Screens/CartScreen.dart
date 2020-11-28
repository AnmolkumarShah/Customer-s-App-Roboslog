import 'package:customer_app/Provider/ProductProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/cart_item.dart';
import '../Provider/orders.dart';
import '../Screens/homeScreen.dart';
import '../Screens/manage_account.dart';
import '../Widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const RouteName = "/cart-screen";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      body: SafeArea(
        child: Container(
          // padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                child: Expanded(
                  child: cart.items.isEmpty
                      ? Center(
                          child: Image.asset(
                            "Asset/Images/image1.png",
                            fit: BoxFit.cover,
                          ),
                        )
                      : ListView.builder(
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) => CartItemBuilder(
                            id: cart.items.values.toList()[index].id,
                            productId: cart.items.keys.toList()[index],
                            price: cart.items.values.toList()[index].price,
                            quantity:
                                cart.items.values.toList()[index].quantity,
                            title: cart.items.values.toList()[index].title,
                          ),
                        ),
                ),
              ),
              cart.items.isEmpty
                  ? Text("")
                  : Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.green, Colors.blue],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 70,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          cart.items.isEmpty
                              ? Text("")
                              : FlatButton(
                                  padding: EdgeInsets.all(5),
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    var userData =
                                        await Provider.of<ProductProvider>(
                                                context,
                                                listen: false)
                                            .getUser();
                                    if (userData['addr1'] == null &&
                                        userData['addr2'] == null &&
                                        userData['pincode'] == null &&
                                        userData['state'] == null) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Please Set your Correct Full Address First",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            actions: [
                                              RaisedButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                          ManageAccount
                                                              .RouteName);
                                                },
                                                child: Text(
                                                  "Take me to Manage Account",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      return;
                                    }
                                    await Provider.of<Order>(context,
                                            listen: false)
                                        .addItem(
                                      cart.items.values.toList(),
                                      cart.totalAmount,
                                    );
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.blue[100],
                                          title: Text(
                                            "Your Order Placed Successfully",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          content: Image(
                                            image: AssetImage(
                                                'Asset/Images/done2.png'),
                                          ),
                                          actions: [
                                            RaisedButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        ProductOverviewScreen
                                                            .RouteName);
                                              },
                                              child: Text(
                                                "Back To Products Screen!",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    cart.clear();
                                  },
                                  child: _isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : Text(
                                          "Order Now !",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

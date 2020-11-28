import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider.dart';
import '../Provider/cart_item.dart';
import '../Screens/CartScreen.dart';
import '../Screens/homeScreen.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({Key key}) : super(key: key);
  static const RouteName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final productItem = Provider.of<ProductProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(productItem.name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Hero(
                        tag: productId,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Image.network(productItem.images),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          padding: EdgeInsets.all(10),
                          backgroundColor: Colors.yellow,
                          label: Text(
                            "\$ ${productItem.price.toString()}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          productItem.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(30),
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: productItem.isFavourite
                        ? Icon(
                            Icons.favorite,
                            size: 50,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.favorite_border,
                            size: 50,
                            color: Colors.red,
                          ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: RaisedButton.icon(
              shape: Border.all(
                style: BorderStyle.solid,
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Please Confirm!!",
                      ),
                      content: Text(
                        "Do you want to add ${productItem.name} to Cart?",
                      ),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Provider.of<Cart>(context, listen: false).addItem(
                              productItem.id,
                              productItem.price,
                              productItem.name,
                            );
                            Navigator.of(context).pop(true);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.lightGreen[100],
                                  title: Text(
                                    "Item Added to Cart Successfully",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  content: Image(
                                    image: AssetImage('Asset/Images/done.png'),
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
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                          CartScreen.RouteName,
                                        );
                                      },
                                      child: Text(
                                        "Take me to Cart",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text("Yes"),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text("No"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.add_shopping_cart,
                size: 40,
              ),
              label: Text(
                "Add to Cart",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider.dart';
import '../Provider/cart_item.dart';

class CartItemBuilder extends StatelessWidget {
  final String id;
  final double price;
  final String title;
  final int quantity;
  final String productId;

  CartItemBuilder({
    this.id,
    this.price,
    this.quantity,
    this.title,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Container(
        child: FutureBuilder(
      future: Provider.of<ProductProvider>(context).maxItemCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Dismissible(
          key: ValueKey(id),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            cart.deleteItem(productId);
          },
          confirmDismiss: (direction) {
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Are You Sure!!"),
                  content: Text("Do you want to remove $title from the Cart?"),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
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
          background: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.only(left: 10),
            color: Colors.red,
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
          ),
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '$quantity x $price = ${quantity * price}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // trailing: ,
              trailing: quantity <= snapshot.data['maxItemCount'] - 1
                  ? Container(
                      width: 170,
                      child: Row(
                        children: [
                          FlatButton(
                            onPressed: () {
                              cart.removeSingleItem(productId);
                            },
                            color: Colors.yellow,
                            minWidth: 5,
                            height: 5,
                            child: Text(
                              "-",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(
                            ' $quantity ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              cart.addItem(productId, price, title);
                            },
                            color: Colors.yellow,
                            minWidth: 5,
                            height: 5,
                            child: Text(
                              "+",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              bool res = await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Are You Sure!!"),
                                    content: Text(
                                        "Do you want to remove $title from the Cart?"),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
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
                              if (res) {
                                cart.deleteItem(productId);
                              }
                            },
                          )
                        ],
                      ),
                    )
                  : FittedBox(
                      child: Text(
                          "Can't be more than ${snapshot.data['maxItemCount']} items"),
                    ),
            ),
          ),
        );
      },
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/orders.dart';
import '../Provider/cart_item.dart';

class AddOrderButton extends StatefulWidget {
  AddOrderButton({Key key}) : super(key: key);

  @override
  _AddOrderButtonState createState() => _AddOrderButtonState();
}

class _AddOrderButtonState extends State<AddOrderButton> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return FlatButton(
      padding: EdgeInsets.all(5),
      onPressed: () {
        Provider.of<Order>(context, listen: false).addItem(
          cart.items.values.toList(),
          cart.totalAmount,
        );
        cart.clear();
      },
      child: Text(
        "Order Now !",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.yellow,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Provider/cart_item.dart';

class OrderItem extends StatefulWidget {
  final String title;
  final DateTime dateTime;
  final List<CartItem> productlist;
  final bool accepted;
  final bool rejected;
  final bool dispatched;
  final DateTime expedtedDelivery;

  OrderItem({
    @required this.title,
    @required this.dateTime,
    @required this.productlist,
    @required this.accepted,
    @required this.rejected,
    @required this.dispatched,
    @required this.expedtedDelivery,
  });

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        child: Column(
          children: [
            ListTile(
              dense: true,
              isThreeLine: true,
              contentPadding: EdgeInsets.all(20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(200),
              ),
              title: Text(
                'Total Amount  \$${widget.title}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.rejected != null && widget.rejected
                      ? Text(
                          "Your Order is Rejected",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )
                      : widget.accepted != null && widget.accepted
                          ? Text(
                              "Order is Accepted",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            )
                          : Text(
                              "Order is Pending....",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                  if (widget.dispatched == true)
                    Text(
                      "Order is dispatched",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  if (widget.dateTime != null)
                    Text(
                      "Ordered on ${DateFormat('dd / MM / yyyy').format(widget.dateTime)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  if (widget.rejected != null && widget.accepted != null)
                    Text(
                      widget.expedtedDelivery != null
                          ? "Expected to deliver by ${DateFormat('dd / MM / yyyy').format(widget.expedtedDelivery)}"
                          : "Delivery Date is still calculating...",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                ],
              ),
              trailing: IconButton(
                icon: _expanded
                    ? Icon(Icons.expand_less)
                    : Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded)
              Container(
                height: widget.productlist.length * 90.0,
                child: ListView.builder(
                  itemCount: widget.productlist.length,
                  itemBuilder: (ctx, i) => ListTile(
                    title: Text(widget.productlist[i].title),
                    subtitle: Text('Price ${widget.productlist[i].price}'),
                    trailing:
                        Text(' Quantity ${widget.productlist[i].quantity}'),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

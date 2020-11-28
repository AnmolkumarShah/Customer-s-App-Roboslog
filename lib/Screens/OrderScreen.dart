import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/orders.dart';
import '../Widgets/app_drawer.dart';
import '../Widgets/order_item.dart' as ord;

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key key}) : super(key: key);
  static const RouteName = "/orders";
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: FutureBuilder(
          future: Provider.of<Order>(context, listen: false).getAndSetOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // if (snapshot.error != null) {
              //   return Center(
              //     child: Text(snapshot.error.toString()),
              //   );
              // }
              return orderData.item.length == 0
                  ? SingleChildScrollView(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "Asset/Images/image2.png",
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            Text(
                              "No Orders Yet !!",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: orderData.item.length,
                      itemBuilder: (ctx, index) => ord.OrderItem(
                        title: orderData.item[index].amount.toString(),
                        dateTime: orderData.item[index].dateTime,
                        productlist: orderData.item[index].products,
                        accepted: orderData.item[index].accepted,
                        rejected: orderData.item[index].rejected,
                        dispatched: orderData.item[index].dispatched,
                        expedtedDelivery:
                            orderData.item[index].expectedDelivery,
                      ),
                    );
            }
          },
        ),
      ),
    );
  }
}

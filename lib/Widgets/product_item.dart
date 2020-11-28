import 'package:flutter/material.dart';
import '../Screens/ProductDetailsScreen.dart';
import '../Provider/Product.dart';
import 'package:provider/provider.dart';
import '../Provider/cart_item.dart';

class ProductItem extends StatelessWidget {
  final imageUrl;
  final String title;
  final double price;
  final String id;
  ProductItem({
    this.id,
    this.imageUrl,
    this.price,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetail.RouteName,
            arguments: product.id,
          );
        },
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('Asset/Images/placeholder.png'),
              image: NetworkImage(product.images),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.price, product.name);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "One Item of ${product.name} added to carts",
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
            title: Text(
              product.name,
              textAlign: TextAlign.center,
            ),
            trailing: Consumer<Product>(
              builder: (context, value, child) => IconButton(
                color: Theme.of(context).accentColor,
                icon: product.isFavourite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                onPressed: () {
                  product.toggleFavourite(product.id);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

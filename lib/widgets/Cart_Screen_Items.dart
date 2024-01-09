import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/cart.dart';

class Cart_Screen_Items extends StatelessWidget {
  ////Items on screen without total amount of Widget

  final String id;
  final String ProductId;
  final String title;
  final double price;
  final int quantity;

  const Cart_Screen_Items(
      this.id, this.ProductId, this.title, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: const Color.fromARGB(255, 251, 34, 34),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
        child: const Icon(Icons.delete, size: 40),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Do you want to remove cart item ?'),
                  content: const Text('Are you sure ?'),
                  actions: [
                    FloatingActionButton(
                      child: const Text('Yes'),
                      onPressed: () => Navigator.of(ctx).pop(true),
                    ),
                    FloatingActionButton(
                      child: const Text('No'),
                      onPressed: () => Navigator.of(ctx).pop(false),
                    ),
                  ],
                ));
      },
      onDismissed: (direction) =>
          Provider.of<Cart>(context, listen: false).removeItem(ProductId),
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            leading: ClipOval(
              child: Container(
                color: const Color.fromARGB(255, 198, 131, 195),
                height: 110,
                width: 110,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '₹' + price.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            subtitle: Text(
              'Total: ₹${(price * quantity).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14),
            ),
            trailing: Container(
              width: 40,
              child: Center(
                child: Text(
                  '${quantity}X',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

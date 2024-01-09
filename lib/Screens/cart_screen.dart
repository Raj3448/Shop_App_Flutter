import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/cart.dart';
import '/provider/order.dart';
import '/widgets/Cart_Screen_Items.dart';

class CartScreen extends StatelessWidget {
  // bool _loadingSpinnerForOrderButton = false;
  static const routeName = '/CartScreen';

  Widget PrintText(String text) {
    return Text(text,
        style: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final _cart = Provider.of<Cart>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Cart'),
        ),
        body: Column(children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(7),
                    child: Text(
                      '₹' + _cart.totalAmount.toString(),
                      style: const TextStyle(color: Colors.deepOrangeAccent),
                    ),
                  ),
                  OrderButton(cart: _cart),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _cart.toggle
              ? Expanded(
                  child: ListView.builder(
                  itemCount: _cart.itemCounts,
                  itemBuilder: (ctx, index) => Cart_Screen_Items(
                      _cart.items.values.toList()[index].id,
                      _cart.items.keys.toList()[index],
                      _cart.items.values.toList()[index].title,
                      _cart.items.values.toList()[index].price,
                      _cart.items.values.toList()[index].quantity),
                ))
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Consumer<Order>(
                      builder: (_, order, child) => order.OrderItems.isNotEmpty
                          ? PrintText(
                              '✅ Order accepted! Please check the   ordered list. Thank you!!!')
                          : PrintText('You Have Not Placed Any Order Yet!'),
                    ),
                  ),
                )
        ]));
  }
}

class OrderButton extends StatefulWidget {
  final Cart _cart;
  const OrderButton({
    super.key,
    required Cart cart,
  }) : _cart = cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final scaffoldMesg = ScaffoldMessenger.of(context);
    return TextButton(
        onPressed: (widget._cart.totalAmount <= 0 || isLoading)
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });
                final amount = widget._cart.totalAmount;
                if (amount != 0.0) {
                  final orderedItems = widget._cart.items.values.toList();
                  try {
                    await Provider.of<Order>(context, listen: false)
                        .addOrderItems(orderedItems, amount);
                    widget._cart.OrderPush();
                  } catch (error) {
                    print('error when posting data: $error');
                    scaffoldMesg.hideCurrentSnackBar();
                    scaffoldMesg.showSnackBar(const SnackBar(
                      content: Text('Network Error!'),
                      duration: Duration(seconds: 3),
                      dismissDirection: DismissDirection.startToEnd,
                    ));
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                }
              },
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const Text('ORDER NOW'));
  }
}

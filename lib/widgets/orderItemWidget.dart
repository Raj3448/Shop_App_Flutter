import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../provider/order.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem _Products;
  const OrderItemWidget(this._Products);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _trigger = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: _trigger
          ? max(widget._Products.OrderedProducts.length * 60.0 + 100, 180)
          : 95,
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '₹${widget._Products.totalAmount}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 45, 225, 51),
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                    DateFormat('dd MM yyyy hh:mm')
                        .format(widget._Products.dateTime),
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )),
                trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        _trigger = !_trigger;
                      });
                    },
                    icon:
                        Icon(_trigger ? Icons.expand_less : Icons.expand_more)),
              ),
              if (_trigger)
                AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 4,
                    ),
                    height: _trigger
                        ? max(
                            widget._Products.OrderedProducts.length * 30.0 +
                                100,
                            180)
                        : 0,
                    child: ListView(children: [
                      ...widget._Products.OrderedProducts
                          .map(
                            (elements) => Column(children: [
                              ListTile(
                                title: Text(
                                  elements.title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Manrope',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                                trailing: Text(
                                  '${elements.price} X ${elements.quantity}',
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'Manrope',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              const Divider(),
                            ]),
                          )
                          .toList(),
                    ])),
            ],
          ),
        ),
      ),
    );
  }
}

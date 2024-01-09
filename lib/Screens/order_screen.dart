import 'package:flutter/material.dart';
import '/Screens/AppDrawer.dart';
import '/widgets/orderItemWidget.dart';
import '../provider/order.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // bool isInit = true;
  bool loadingSpinner = false;
  @override
  // void didChangeDependencies() async {
  //   if (isInit) {
  //     setState(() {
  //       loadingSpinner = true;
  //     });
  //     try {
  //       await Provider.of<Order>(context, listen: false).fetchOrderedItems();
  //     } catch (error) {
  //       //...
  //     }
  //     setState(() {
  //       loadingSpinner = false;
  //     });
  //     isInit = false;
  //   }
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    //final order = Provider.of<Order>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body:
            //  loadingSpinner
            //     ? const Center(child: CircularProgressIndicator())
            //     : RefreshIndicator(
            //         onRefresh: () async {
            //           try {
            //             await Provider.of<Order>(context, listen: false)
            //                 .fetchOrderedItems();
            //           } catch (error) {
            //             //...
            //           }
            //         },
            //         child: ListView.builder(
            //           itemBuilder: (ctx, index) =>
            //               OrderItemWidget(order.OrderItems[index]),
            //           itemCount: order.OrderItems.length,
            //         ),
            //       ),
            FutureBuilder(
          future:
              Provider.of<Order>(context, listen: false).fetchOrderedItems(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.error != null) {
              print('Error :${snapshot.error}');
              return Center(
                child: Card(
                  shadowColor: Colors.black,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.purple)),
                    height: 150,
                    width: 250,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          '404 SERVER ERROR',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Unable to feching data from server',
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx)
                                  .pushReplacementNamed(AppDrawer.routeName);
                            },
                            child: const Text('Ok')),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Consumer<Order>(
                builder: (contxt, order, child) => ListView.builder(
                  itemBuilder: (ctx, index) =>
                      OrderItemWidget(order.OrderItems[index]),
                  itemCount: order.OrderItems.length,
                ),
              );
            }
          },
        ));
  }
}

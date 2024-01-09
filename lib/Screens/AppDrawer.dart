import 'package:flutter/material.dart';
import '/PageRouters/custom_route.dart';
import '/Screens/User_product_Screen.dart';
import '/Screens/order_screen.dart';

class AppDrawer extends StatelessWidget {
  static const routeName = '/AppDrawer';
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(title: const Text('Home')),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.shopping_bag,
              color: Color.fromARGB(255, 28, 211, 80),
            ),
            title: const Text(
              'Shopping',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment, color: Colors.cyan),
            title: const Text(
              'Order List',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              //Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
              Navigator.of(context).pushReplacement(CustomRoute(
                builder: (context) => OrderScreen(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.deepOrange),
            title: const Text(
              'Manage Products',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}

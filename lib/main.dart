import 'package:shopii2/PageRouters/custom_route.dart';

import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Screens/product_overview_screen.dart';
import '/Screens/AuthenticationScreen.dart';
import '/Screens/AppDrawer.dart';
import '/Screens/Edit_Screen.dart';
import '/Screens/User_product_Screen.dart';
import '/Screens/cart_screen.dart';
import '/Screens/order_screen.dart';
import '/Screens/product_details_screen.dart';

import '/provider/cart.dart';
import '/provider/order.dart';
import '/provider/Auth.dart';
import 'provider/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const routeName = '/myApp';
  const MyApp({super.key});

  static const TextStyle fonttheme = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProvider(create: (context) => Products()),
          ChangeNotifierProvider(create: (context) => Cart()),
          ChangeNotifierProvider(create: (context) => Order()),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            title: 'Shopii',
            theme: ThemeData(
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomTransitionBuilder(),
                  TargetPlatform.iOS: CustomTransitionBuilder()
                }),
                //primaryColor: Color.fromARGB(255, 248, 139, 184),
                colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color.fromARGB(255, 255, 225, 245))),
            home: auth.isAuth ? Product_overview_screen() : AuthScreen(),
            routes: {
              Product_overview_screen.routeName: (context) =>
                  Product_overview_screen(),
              Product_Details_Screen.routeName: (context) =>
                  Product_Details_Screen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrderScreen.routeName: (context) => OrderScreen(),
              UserProductScreen.routeName: (context) => UserProductScreen(),
              EditScreen.routeName: (context) => EditScreen(),
              AppDrawer.routeName: (context) => AppDrawer(),
              AuthScreen.routeName: (context) => AuthScreen(),
            },
          ),
        ));
  }
}

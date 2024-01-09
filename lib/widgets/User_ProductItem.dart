import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Screens/Edit_Screen.dart';
import '/provider/product.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String imageURL;
  final String title;
  const UserProductItem(this.id, this.imageURL, this.title);

  @override
  Widget build(BuildContext context) {
    final _scaffoldMesg = ScaffoldMessenger.of(context);
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(imageURL),
            ),
            title: Text(title),
            trailing: Container(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(EditScreen.routeName, arguments: id);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Color.fromARGB(255, 1, 196, 176),
                      )),
                  IconButton(
                      onPressed: () async {
                        try {
                          await Provider.of<Products>(context, listen: false)
                              .removeProduct(id);
                        } catch (httpException) {
                          //print(HttpException);
                          _scaffoldMesg.hideCurrentSnackBar();
                          _scaffoldMesg.showSnackBar(const SnackBar(
                            content: Text('Deleting Failed !'),
                            duration: Duration(seconds: 3),
                          ));
                        }
                      },
                      icon: const Icon(Icons.delete,
                          color: Color.fromARGB(255, 251, 51, 37)))
                ],
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

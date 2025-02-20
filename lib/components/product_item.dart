import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/utils/app_routes.dart';

import '../models/product.dart';
import '../models/product_list.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product,
                );
              },
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Excluir Produto'),
                      content: Text('Tem certeza?'),
                      actions: [
                        // TextButton(
                        //     onPressed: () => Navigator.of(context).pop(),
                        //     child: Text('Não')),
                        // TextButton(
                        //   onPressed: () {
                        //     Provider.of<ProductList>(context, listen: false)
                        //         .removeProduct(product);
                        //     Navigator.of(context).pop();
                        //   },
                        //   child: Text('Sim'),
                        // ),
                        TextButton(
                          child: Text('Não'),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: Text('Sim'),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    );
                  },
                ).then((value) async {
                  if (value ?? false) {
                    try {
                      await Provider.of<ProductList>(context, listen: false)
                          .removeProduct(product);
                    } catch (err) {
                      msg.showSnackBar(
                        SnackBar(
                          content: Text(err.toString()),
                        ),
                      );
                      print(err.toString());
                    }
                  }
                });
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';

import '../components/order.dart';
import '../models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  Future<void> _refreshOrders(BuildContext context) async {
    await Provider.of<OrderList>(
      context,
      listen: false,
    ).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    // final OrderList orders = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshOrders(context),
        child: FutureBuilder(
            future: Provider.of<OrderList>(context, listen: false).loadOrders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.error != null) {
                return Center(
                  child: Text('Ocorreu um erro'),
                );
              } else {
                return Consumer<OrderList>(
                  builder: (ctx, orders, child) => ListView.builder(
                      itemCount: orders.itemsCount,
                      itemBuilder: (ctx, i) =>
                          OrderWidget(order: orders.items[i])),
                );
              }
            }),
      ),
      // body: _isLoading
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : RefreshIndicator(
      //       onRefresh: () => _refreshOrders(context),
      //       child: ListView.builder(
      //           itemCount: orders.itemsCount,
      //           itemBuilder: (ctx, i) => OrderWidget(order: orders.items[i]),
      //         ),
      //     ),
    );
  }
}

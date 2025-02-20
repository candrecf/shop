import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
// import 'package:shop/data/dummy_data.dart';

import '../utils/constants.dart';
import 'product.dart';

class ProductList with ChangeNotifier {
  // List<Product> _items = dummyProducts;
  final String _token;
  final String _userId;
  List<Product> _items = [];

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  // final _baseUrl = 'https://shop-appwiser-default-rtdb.firebaseio.com/products';

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  //https://cdn-icons-png.flaticon.com/256/53/53283.png

  // Future<void> addProduct(Product product) {
  //   final future = http.post(
  //     Uri.parse('$_baseUrl/products.json'),
  //     body: jsonEncode({
  //       "name": product.name,
  //       "description": product.description,
  //       "price": product.price,
  //       "imageUrl": product.imageUrl,
  //       "isFavorite": product.isFavorite,
  //     }),
  //   );

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          // "isFavorite": product.isFavorite,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(
      Product(
          id: id,
          name: product.name,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl),
    );
    notifyListeners();

    // return future.then<void>((response) {
    //   // print('Depois que a resposta voltar do firebase');
    //   final id = jsonDecode(response.body)['name'];
    //   _items.add(
    //     Product(
    //         id: id,
    //         name: product.name,
    //         description: product.description,
    //         price: product.price,
    //         imageUrl: product.imageUrl),
    //   );
    //   notifyListeners();
    // });

    // print('na sequencia (sem esperar a resposta)');
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      // _items.removeWhere((p) => p.id == product.id);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpExceptionn(
          msg: 'Não foi possível excluir o produto',
          statusCode: response.statusCode,
        );
      }
    }
  }

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
    );
    // print(jsonDecode(response.body));

    // {
    //    -O34XBlJrSgmNGkE4p4n: {description: asdasddsaasdsdasda,
    //    imageUrl: https://cdn-icons-png.flaticon.com/256/53/53283.png,
    //    isFavorite: false, name: Bola 1, price: 20.0},

    //    -O34XEnGLYp3wxjoxeQL: {description: asfadasdsaadsdas,
    //    imageUrl: https://cdn-icons-png.flaticon.com/256/53/53283.png,
    //    isFavorite: false, name: Bola 2, price: 123.0}
    // }

    if (response.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse(
        '${Constants.USER_FAVORITES_URL}/$_userId.json?auth=$_token',
      ),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      final isFavorite = favData[productId] ?? false;

      _items.add(Product(
        id: productId,
        name: productData['name'],
        description: productData['description'],
        price: productData['price'],
        imageUrl: productData['imageUrl'],
        isFavorite: isFavorite,
      ));
    });
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }
}

// bool _showFavoriteOnly = false;

// List<Product> get items {
//   if (_showFavoriteOnly) {
//     return _items.where((prod) => prod.isFavorite).toList();
//   } else {
//     return [..._items];
//   }
// }

// void showFavoriteOnly() {
//   _showFavoriteOnly = true;
//   notifyListeners();
// }

// void showAll() {
//   _showFavoriteOnly = false;
//   notifyListeners();
// }

import 'package:flutter/material.dart';

import '../Config/customcolors.dart';
import 'add_product_screen.dart';
import '../Widgets/app_bar_title.dart';
import 'list_products.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    //return ListViewProduct();
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        /// 2- to call ui of AppBarTitle class ///
        title: AppBarTitle(),
      ),
      floatingActionButton: FloatingActionButton(
        /// 3- code navigator to AddScreen when click floatingButton to add post ///
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddProductScreen(),
            ),
          );
        },
        backgroundColor: CustomColors.googleBackground,

        /// 4- ui of floatingButton ///
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),

          /// 5- to call ui of ItemList class and show them in DashboardScreen ///
          child: ListProducts(),
        ),
      ),
    );
  }
}

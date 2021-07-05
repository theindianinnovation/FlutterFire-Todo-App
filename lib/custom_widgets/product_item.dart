import 'package:flutter/material.dart';
import 'package:flutter_firebase_todo_app/controllers/product_controller.dart';
import 'package:get/get.dart';

class ProductItem extends StatefulWidget {
  ProductItem({@required this.title, @required this.price});

  final String title;
  final int price;

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  ProductController _productController = Get.put(ProductController());
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).primaryColor,
      title: new Text(widget.title),
      trailing: SizedBox(
          width: 200,
          child: Wrap(alignment: WrapAlignment.spaceBetween, children: [
            Row(
              children: <Widget>[
                counter != 0
                    ? new IconButton(
                        icon: new Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            counter--;
                            _productController.decrement(widget.price);
                          });
                        })
                    : new Container(),
                new Text("Clicks: $counter"),
                new IconButton(
                    icon: new Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        counter++;
                        _productController.increment(widget.price);
                      });
                    })
              ],
            ),
          ])),
    );
  }
}

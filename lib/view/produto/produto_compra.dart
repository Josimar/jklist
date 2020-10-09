import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopHelper {
  static const GRID_COLUMN_VALUE = 4;
}

class ShopModel {
  final String categoryName;
  final List<Product> products;
  double position = 0;

  ShopModel({this.categoryName, this.products});
}

class Product {
  final String name;
  final int price;

  Product(this.name, this.price);
}

class TabBarChange extends ChangeNotifier {
  int index = 0;

  void changeIndex(int val) {
    index = val;
    notifyListeners();
  }
}

TabBarChange tabBarNotifier = TabBarChange();

class ProdutoCompra extends StatefulWidget {
  @override
  ShopView createState() => new ShopView();
}

class ShopView extends ShopViewModel {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compra'),
      ),
      body: buildChangeBody(),
    );
  }

  ChangeNotifierProvider<TabBarChange> buildChangeBody() {
    return ChangeNotifierProvider.value(
      value: tabBarNotifier,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: buildListViewHeader),
          Divider(),
          Expanded(flex: 9, child: buildListViewShop),
        ],
      ),
    );
  }

  ListView get buildListViewShop {
    return ListView.builder(
      controller: scrollController,
      itemCount: shopListAndSpaceAreaLength,
      itemBuilder: (context, index) {
        print(index);
        if (index == shopListLastIndex)
          return emptyWidget;
        else
          return ShopCard(
            model: shopList[index],
            index: index,
            onHeight: (val) {
              fillListPositionValues(val);
            },
          );
      },
    );
  }

  int get shopListAndSpaceAreaLength => shopList.length + 1;

  int get shopListLastIndex => shopList.length;

  Container get emptyWidget => Container(height: oneItemHeight * 2);

  Widget get buildListViewHeader {
    return Consumer<TabBarChange>(
      builder: (context, value, child) => ListView.builder(
        itemCount: shopList.length,
        controller: headerScrollController,
        padding: EdgeInsets.all(10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => buildPaddingHeaderCard(index),
      ),
    );
  }

  Padding buildPaddingHeaderCard(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: RaisedButton(
        color: tabBarNotifier.index == index ? Colors.red : Colors.blue,
        onPressed: () => headerListChangePosition(index),
        child: Text("${shopList[index].categoryName} $index"),
        shape: StadiumBorder(),
      ),
    );
  }

}

abstract class ShopViewModel extends State<ProdutoCompra> {
  ScrollController scrollController = ScrollController();
  int currentCategoryIndex = 0;
  ScrollController headerScrollController = ScrollController();

  List<ShopModel> shopList = [];

  @override
  void initState() {
    super.initState();
    shopList = List.generate(10, (index) => ShopModel(
              categoryName: "Hello",
              products: List.generate(6, (index) => Product("Product $index", index * 100)),
      ),
    );

    scrollController.addListener(() {
      final index = shopList.indexWhere((element) => element.position >= scrollController.offset);
      tabBarNotifier.changeIndex(index);

      headerScrollController.animateTo(
          index * (MediaQuery.of(context).size.width * 0.2),
          duration: Duration(seconds: 1),
          curve: Curves.decelerate);
    });
  }

  void headerListChangePosition(int index) {
    scrollController.animateTo(
        shopList[index].position,
        duration: Duration(seconds: 1), curve: Curves.ease
    );
  }

  double oneItemHeight = 0;

  void fillListPositionValues(double val) {
    if (oneItemHeight == 0) {
      oneItemHeight = val;
      shopList.asMap().forEach((key, value) {
        if (key == 0) {
          shopList[key].position = 0;
        } else {
          shopList[key].position = getShopListPosition(val, key);
        }
      });
    }
  }

  double getShopListPosition(double val, int index) =>
      val * (shopList[index].products.length / ShopHelper.GRID_COLUMN_VALUE) +
          shopList[index - 1].position;
}

class ShopCard extends StatelessWidget {
  final ShopModel model;
  final int index;
  final Function(double val) onHeight;

  const ShopCard({Key key, this.model, this.index, this.onHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onHeight((context.size.height) /
          (model.products.length / ShopHelper.GRID_COLUMN_VALUE));
    });
    return Column(
      children: [
        Divider(),
        Text("${model.categoryName} $index"),
        Card(
          child: buildGridViewProducts(index, model.products),
        ),
      ],
    );
  }

  GridView buildGridViewProducts(int index, List<Product> products) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ShopHelper.GRID_COLUMN_VALUE),
      itemBuilder: (context, index) {
        return Card(
          child: Text(products[index].name),
        );
      },
    );
  }
}
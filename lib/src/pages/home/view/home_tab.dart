import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/pages/common_widgets/custom_shimmer.dart';
import 'package:greengrocer/src/pages/home/view/components/item_tile.dart';
import 'package:greengrocer/src/pages/home/controller/home_controller.dart';
import '../../../config/app_data.dart' as appData;
import '../../common_widgets/app_name_widget.dart';
import 'components/category_tile.dart';

class HomeTab extends StatefulWidget {

  const HomeTab({ Key? key }) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GlobalKey<CartIconKey> globalKeyCartItems = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCardAnimation;

  String selectedCategory = 'Frutas';

  void itemSelectedCartAnimations(GlobalKey gkImage) {
    runAddToCardAnimation(gkImage);
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    
    Get.find<HomeController>().printExample();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const AppNameWidget(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
              right: 15
            ),
            child: GestureDetector(
              onTap: () {},
              child: Badge(
                badgeColor: CustomColors.customConstratColor,
                badgeContent: const Text('2', style: TextStyle(color: Colors.white, fontSize: 12)),
                child: AddToCartIcon(
                  key: globalKeyCartItems,
                  icon: Icon(
                    Icons.shopping_cart,
                    color: CustomColors.customSwatchColor
                  ),
                )
              ),
            ),
          )
        ],
      ),
      body: AddToCartAnimation(
        gkCart: globalKeyCartItems,
        previewDuration: const Duration(milliseconds: 100),
        previewCurve: Curves.ease,
        receiveCreateAddToCardAnimationMethod: (addToCardAnimationMethod) {
          runAddToCardAnimation = addToCardAnimationMethod;
        },
        child: Column(
          children: [
            buildSearch(),
            buildCategories(),
            Expanded(
              child: !isLoading ? GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 9 / 11.5
                ), 
                itemCount: appData.items.length,
                itemBuilder: (_, index) {
                  return ItemTile(
                    item: appData.items[index],
                    cartAnimationMethod: itemSelectedCartAnimations
                  );
                }
              ): GridView.count(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10, 
                  childAspectRatio:  9 / 11.5,
                  children: List.generate(10, (_) => CustomShimmer(
                    height: double.infinity,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(20),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildCategories() {
    return Container(
      padding: const EdgeInsets.only(left: 25),
      height: 40,
      child: !isLoading ? ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return CategoryTile(
            onPressed: () {
              setState(() {
                selectedCategory = appData.categories[index];
              });  
            },
            category: appData.categories[index], 
            isSelected: appData.categories[index] == selectedCategory
          );
        }, 
        separatorBuilder: (_, index) => const SizedBox(width: 10,), 
        itemCount: appData.categories.length
      ) : ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(5, (_) =>  Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 12),
            child: CustomShimmer(
              height: 20,
              width: 80,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        )
      ),
    );
  }

  Padding buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10
      ),
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          hintText: 'Pesquise aqui...',
          prefixIcon: Icon(Icons.search, color: CustomColors.customConstratColor, size: 21,),
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none
            )
          )
        ),
      ),
    );
  }
}

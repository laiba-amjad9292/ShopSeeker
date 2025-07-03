import 'package:flutter/material.dart';
import 'package:shop_seeker/global/widgets/appbar/appbar.widget.dart';
import 'package:shop_seeker/modules/home/models/product.model.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: product.name,
        titleColor: AppColors.white,
        backButton: true,
        appBarColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: Image.asset(
                    product.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                10.hp,
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: stylew700(size: 20, color: AppColors.primary),
                      ),
                      5.hp,
                      Text(
                        "€${product.price.toStringAsFixed(2)}",
                        style: stylew600(color: AppColors.color888888),
                      ),
                      10.hp,
                      Text(
                        "Description",
                        style: stylew700(size: 14, color: AppColors.black),
                      ),
                      4.hp,
                      Text(
                        product.description,
                        style: styleRegular(
                          size: 14,
                          color: AppColors.color888888,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

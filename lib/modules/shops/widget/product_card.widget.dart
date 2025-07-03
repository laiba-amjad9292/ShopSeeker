import "package:flutter/material.dart";
import "package:shop_seeker/modules/shops/models/product.model.dart";
import "package:shop_seeker/utils/constants/app_colors.utils.dart";
import "package:shop_seeker/utils/extensions/size_extension.util.dart";
import "package:shop_seeker/utils/theme/textStyles.utils.dart";

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  product.imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              5.hp,
              Column(
                children: [
                  Text(
                    product.name,
                    style: stylew600(size: 14, color: AppColors.primary),
                  ),
                  2.hp,
                  Text(
                    "€${product.price.toStringAsFixed(2)}",
                    style: stylew500(size: 14, color: AppColors.color888888),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

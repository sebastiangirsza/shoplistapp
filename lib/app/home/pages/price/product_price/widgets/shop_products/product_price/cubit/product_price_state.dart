part of 'product_price_cubit.dart';

@immutable
class ProductPriceState {
  const ProductPriceState({
    required this.productsPrice,
  });

  final List<ProductPriceModel> productsPrice;
}

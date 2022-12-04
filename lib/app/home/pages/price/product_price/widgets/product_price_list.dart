import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';
import 'package:shoplistapp/app/home/pages/price/product_price/cubit/product_price_cubit.dart';
import 'package:shoplistapp/app/injection_container.dart';
import 'package:shoplistapp/app/models/shop_products_model.dart';

@injectable
class ProductsPriceList extends StatelessWidget {
  const ProductsPriceList({
    Key? key,
    required this.shopProductModel,
  }) : super(key: key);

  final ShopProductsModel shopProductModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductPriceCubit>()
        ..getProductPriceStream(shopProductModel.shopProductName),
      child: BlocBuilder<ProductPriceCubit, ProductPriceState>(
        builder: (context, state) {
          final productsPriceModels = state.productsPrice;
          List<String> productsPriceList = [];
          List<String> productsShopDownloadURLList = [];
          for (final productsPriceModel in productsPriceModels) {
            productsPriceList.add(productsPriceModel.productPrice.toString());
            productsShopDownloadURLList.add(productsPriceModel.shopDownloadURL);
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productsPriceModels.length,
            itemBuilder: (context, index) {
              final first = productsPriceList[0];
              final Color color =
                  index == 0 || first == productsPriceList[index]
                      ? Colors.green
                      : const Color.fromARGB(255, 200, 233, 255);
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2,
                      offset: Offset(3, 3),
                    )
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: color,
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 30,
                      width: 45,
                      decoration: BoxDecoration(
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 2,
                            offset: Offset(3, 3),
                          )
                        ],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            productsShopDownloadURLList[index],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cena:',
                          style: GoogleFonts.getFont(
                            'Saira',
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          productsPriceList[index],
                          style: GoogleFonts.getFont(
                            'Saira',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';
import 'package:shoplistapp/app/home/pages/shop_list/cubit/add_product_cubit.dart';
import 'package:shoplistapp/app/home/pages/your_products/cubit/purchased_products_cubit.dart';
import 'package:shoplistapp/app/injection_container.dart';
import 'package:shoplistapp/app/models/product_model.dart';

@injectable
class ElevatedButtonAddToStorageWidget extends StatelessWidget {
  const ElevatedButtonAddToStorageWidget({
    Key? key,
    required this.storageName,
    required this.productModel,
    required this.productQuantity,
    required this.isDated,
    required this.productTypeName,
    required this.productPortion,
  }) : super(key: key);

  final String? storageName;
  final ProductModel productModel;
  final int productQuantity;
  final bool isDated;
  final String productTypeName;
  final int productPortion;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddProductCubit>(),
      child: BlocBuilder<AddProductCubit, AddProductState>(
        builder: (context, state) {
          DateTime? productDate = DateTime(2100);
          return ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: storageName == null || productPortion == 0
                ? null
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(milliseconds: 600),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                style: GoogleFonts.getFont('Saira',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                'Produkt dodany do \'$storageName\''),
                          ],
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    List<String> listaProcura = [];
                    String temp = "";
                    for (var i = 0; i < productModel.productName.length; i++) {
                      if (productModel.productName[i] == " ") {
                        temp = "";
                      } else {
                        temp = temp + productModel.productName[i];
                        listaProcura.add(temp.toLowerCase());
                      }
                    }
                    final int count = productQuantity;
                    final bool frozen =
                        (storageName == 'Zamrażarka' ? true : false);

                    for (var i = 0; i < count; i++) {
                      context.read<YourProductsCubit>().addYourProduct(
                            productModel.productGroup,
                            productModel.productName,
                            productDate,
                            storageName!,
                            isDated,
                            listaProcura,
                            productTypeName,
                            productPortion,
                            frozen,
                          );
                    }
                    context
                        .read<AddProductCubit>()
                        .delete(documentID: productModel.id);

                    Navigator.of(context).pop();
                  },
            child: Text(
                style: GoogleFonts.getFont('Saira', color: Colors.white),
                'Dodaj'),
          );
        },
      ),
    );
  }
}

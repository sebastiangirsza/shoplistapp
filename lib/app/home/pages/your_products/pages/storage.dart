import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoplistappsm/app/home/pages/your_products/cubit/your_products_cubit.dart';
import 'package:shoplistappsm/app/repositories/purchased_products_repository.dart';
import 'package:shoplistappsm/data/remote_data_sources/purchased_product_remote_data_source.dart';
import 'package:shoplistappsm/data/remote_data_sources/user_remote_data_source.dart';

class StoragePage extends StatelessWidget {
  const StoragePage({
    required this.storageName,
    Key? key,
  }) : super(key: key);
  final String storageName;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Color.fromARGB(255, 40, 40, 40),
            Color.fromARGB(255, 60, 60, 60),
            Color.fromARGB(255, 80, 80, 80),
            Color.fromARGB(255, 100, 100, 100),
          ],
        ),
      ),
      child: Scaffold(
          body: CustomScrollView(
        slivers: [
          SliverAppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              expandedHeight: 90,
              snap: false,
              pinned: true,
              floating: false,
              forceElevated: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                          style: GoogleFonts.getFont('Saira',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white),
                          storageName),
                    ),
                  ],
                ),
              ),
              title: Text(
                  style: GoogleFonts.getFont('Saira',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                  'Shop List'),
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ))),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                BlocProvider(
                  create: (context) => YourProductsCubit(
                      PurchasedProductsRepository(
                          PurchasedProductsRemoteDataSource(),
                          UserRemoteDataSource()))
                    ..start(),
                  child: BlocBuilder<YourProductsCubit, YourProductsState>(
                    builder: (context, state) {
                      final purchasedProductModels = state.purchasedProducts;
                      return MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            for (final purchasedProductsModel
                                in purchasedProductModels) ...[
                              if (purchasedProductsModel.storageName ==
                                  storageName) ...[
                                Dismissible(
                                  key: UniqueKey(),
                                  confirmDismiss: (direction) async {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      context
                                          .read<YourProductsCubit>()
                                          .deletePurchasedProduct(
                                              documentID:
                                                  purchasedProductsModel.id);
                                    } else {}
                                  },
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 5),
                                      Container(
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 0, 63, 114),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.black,
                                                blurRadius: 5)
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  style: GoogleFonts.getFont(
                                                      'Saira'),
                                                  purchasedProductsModel
                                                      .purchasedProductName),
                                              Text(
                                                  style: GoogleFonts.getFont(
                                                      'Saira'),
                                                  purchasedProductsModel
                                                      .purchasedProductQuantity
                                                      .toString()),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              ]
                            ]
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

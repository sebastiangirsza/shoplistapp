import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shoplistapp/app/models/product_price_model.dart';
import 'package:shoplistapp/app/repositories/product_price_repository.dart';

part 'product_price_state.dart';

@injectable
class ProductPriceCubit extends Cubit<ProductPriceState> {
  ProductPriceCubit(
    this._productPriceRepository,
  ) : super(const ProductPriceState(
          productsPrice: [],
        ));

  StreamSubscription? _streamSubscription;

  final ProductPriceRepository _productPriceRepository;

  Future<void> getProductPriceStream(String productName) async {
    _streamSubscription =
        _productPriceRepository.getProductPriceStream(productName).listen(
      (productsName) {
        emit(ProductPriceState(
          productsPrice: productsName,
        ));
      },
    )..onError(
            (error) {
              emit(const ProductPriceState(
                productsPrice: [],
              ));
            },
          );
  }

  // Future<void> shopProductName(String productName) async {
  //   _streamSubscription =
  //       _shopProductsRepository.getShopProductName(productName).listen(
  //     (productPrice) {
  //       emit(ProductPriceState(productPrice: productPrice));
  //     },
  //   )..onError(
  //           (error) {
  //             emit(const ProductPriceState(productPrice: []));
  //           },
  //         );
  // }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
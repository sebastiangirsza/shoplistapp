import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shoplistapp/app/home/pages/shop_list/cubit/add_product_cubit.dart';
import 'package:shoplistapp/app/injection_container.dart';

@injectable
class AddButtonWidget extends StatefulWidget {
  const AddButtonWidget({
    required this.productGroup,
    Key? key,
  }) : super(key: key);
  final String productGroup;

  @override
  State<AddButtonWidget> createState() => _AddButtonWidgetState();
}

class _AddButtonWidgetState extends State<AddButtonWidget> {
  String? productName;
  String? productTypeName;
  int productQuantity = 1;
  bool isChecked = false;
  int quantityGram = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 63, 114),
              borderRadius: BorderRadius.all(Radius.circular(100))),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  backgroundColor: const Color.fromARGB(255, 200, 233, 255),
                  content: Container(
                    constraints: const BoxConstraints(
                      maxHeight: double.infinity,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Text(
                          style: GoogleFonts.getFont('Saira',
                              fontWeight: FontWeight.bold, color: Colors.black),
                          'Dodaj produkt do listy',
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          decoration: boxDecoration(),
                          child: TextField(
                            style: GoogleFonts.getFont(
                              'Saira',
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelStyle: GoogleFonts.getFont(
                                'Saira',
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'Nazwa produktu',
                              ),
                            ),
                            onChanged: (newProduct) {
                              setState(() {
                                productName = newProduct;
                              });
                            },
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          decoration: boxDecoration(),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              label: Text(
                                  style: GoogleFonts.getFont('Saira',
                                      fontSize: 12, color: Colors.black),
                                  'Rodzaj opakowania'),
                              border: InputBorder.none,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            iconDisabledColor: Colors.black,
                            iconEnabledColor: Colors.black,
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            value: productTypeName,
                            onChanged: (newProduct) {
                              setState(() {
                                productTypeName = newProduct!;
                                (productTypeName != 'gramy')
                                    ? quantityGram = -1
                                    : quantityGram = 0;
                              });
                            },
                            items: <String>[
                              'sztuka',
                              'karton',
                              'gramy',
                              'paczka',
                              'butelka',
                              'słoik',
                            ].map<DropdownMenuItem<String>>(
                              (productTypeName) {
                                return DropdownMenuItem<String>(
                                  value: productTypeName,
                                  child: Center(
                                    child: Text(
                                      style: GoogleFonts.getFont(
                                        'Saira',
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      productTypeName,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        const SizedBox(height: 2),
                        (productTypeName != null)
                            ? (productTypeName != 'gramy')
                                ? Container(
                                    decoration: boxDecoration(),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                            style: GoogleFonts.getFont('Saira',
                                                fontSize: 12,
                                                color: Colors.black),
                                            'Ilość: '),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: NumberPicker(
                                            textStyle: GoogleFonts.getFont(
                                                'Saira',
                                                fontSize: 16,
                                                color: Colors.black),
                                            selectedTextStyle:
                                                GoogleFonts.getFont('Saira',
                                                    fontSize: 20,
                                                    color: const Color.fromARGB(
                                                        255, 0, 63, 114),
                                                    fontWeight:
                                                        FontWeight.bold),
                                            itemHeight: 24,
                                            itemWidth: 40,
                                            axis: Axis.horizontal,
                                            value: productQuantity,
                                            minValue: 1,
                                            maxValue: 100,
                                            itemCount: 5,
                                            onChanged: (value) => setState(() {
                                              productQuantity = value;
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    decoration: boxDecoration(),
                                    child: TextField(
                                      style: GoogleFonts.getFont(
                                        'Saira',
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelStyle: GoogleFonts.getFont(
                                          'Saira',
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                        label: const Text(
                                          'Ilość gram',
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (newQuantityGram) {
                                        final quantityGrams =
                                            int.tryParse(newQuantityGram);
                                        setState(
                                          () {
                                            quantityGram =
                                                (quantityGrams == null)
                                                    ? 0
                                                    : quantityGrams;
                                          },
                                        );
                                      },
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                            : Container(height: 0),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            productName = null;
                            productQuantity = 1;
                            productTypeName = null;
                            quantityGram = 0;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cofnij',
                          style: GoogleFonts.getFont('Saira',
                              color: const Color.fromARGB(255, 0, 63, 114),
                              fontWeight: FontWeight.bold),
                        )),
                    BlocProvider(
                      create: (context) => getIt<AddProductCubit>(),
                      child: BlocBuilder<AddProductCubit, AddProductState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black),
                            onPressed: productName == null ||
                                    productTypeName == null ||
                                    quantityGram == 0
                                ? null
                                : () {
                                    context.read<AddProductCubit>().add(
                                        widget.productGroup,
                                        productName!,
                                        productQuantity,
                                        isChecked,
                                        productTypeName!,
                                        quantityGram);
                                    setState(() {
                                      productName = null;
                                      productQuantity = 1;
                                      productTypeName = null;
                                      quantityGram = 0;
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration:
                                            const Duration(milliseconds: 600),
                                        content: SizedBox(
                                          height: 30,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  style: GoogleFonts.getFont(
                                                      'Saira',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                  'Produkt dodany do listy'),
                                            ],
                                          ),
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  },
                            child: Text(
                                style: GoogleFonts.getFont('Saira'),
                                'Dodaj do listy'),
                          );
                        },
                      ),
                    )
                  ],
                );
              });
            }),
      ),
    );
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      color: Colors.white.withOpacity(0.5),
    );
  }
}

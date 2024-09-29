import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:hezmaa/helper/constants.dart';
import 'package:hezmaa/models/prodect_of_prodects/prodect_model_forcard.dart';

class CustomCard3 extends StatefulWidget {
  ProdectModel product;
  CustomCard3({
    super.key,
    required this.product,
  });

  @override
  State<CustomCard3> createState() => _ListItemState();
}

class _ListItemState extends State<CustomCard3> {
  double rating = 2;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xffF0F0F0),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.product.name ?? 'اسم المنتج',
                          style: TextStyle(fontFamily: 'STVBold', fontSize: 12),
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PannableRatingBar(
                        rate: rating,
                        textDirection: TextDirection.rtl,
                        items: List.generate(
                            5,
                            (index) => const RatingWidget(
                                  selectedColor: Colors.green,
                                  unSelectedColor: Color(backgroundcolor1),
                                  child: Icon(
                                    Icons.star,
                                    size: 15,
                                  ),
                                )),
                        onChanged: (value) {
                          setState(() {
                            rating = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.product.desc ?? 'وصف المنتج',
                        style: TextStyle(
                            fontSize: 8,
                            fontFamily: 'STVBold',
                            color: Color(backgroundcolor2)),
                      ),
                    ],
                  ),
                ],
              )),
          Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(backgroundcustomgreen)),
                  borderRadius: BorderRadius.circular(18),
                  color: const Color(backgroundcolor1),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.network(widget.product.image!),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

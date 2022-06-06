import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/ui/shared/review_box.dart';

import '../../core/viewmodels/providers_view_model.dart';

class RateBox extends StatefulWidget {
  final String providerId;
  RateBox({required this.providerId});
  RateBoxState createState() => RateBoxState();
}

class RateBoxState extends State<RateBox> {
  var rate = 0.0;
  @override
  Widget build(BuildContext context) {
    final providerViewModel = Provider.of<ProviderViewModel>(context);
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width / 1.5,
      child: Column(
        children: [
          Text(
            "Rate this provider",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
          ),
          Container(
            height: 5,
          ),
          RatingBar.builder(
            initialRating: 1,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 20,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                rate = rating;
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: 40,
            width: MediaQuery.of(context).size.width / 1.8,
            child: MaterialButton(
              onPressed: () {
                providerViewModel
                    .rateProvider(widget.providerId, rate.toInt())
                    .then((value) {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            content: ReviewBox(
                                providerId: widget.providerId, rate: rate));
                      });
                });
              },
              child: Text(
                "Give ${rate.toInt()} stars",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),
          )
        ],
      ),
    );
  }
}

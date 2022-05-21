import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/models/review_model.dart';

import '../../core/services/authentication.dart';
import '../../core/viewmodels/client_view_model.dart';
import '../../core/viewmodels/providers_view_model.dart';
import '../../core/viewmodels/review_view_model.dart';

class ReviewBox extends StatefulWidget {
  final String providerId;
  final double rate;
  ReviewBox({required this.providerId, required this.rate});
  @override
  ReviewBoxState createState() => ReviewBoxState();
}

class ReviewBoxState extends State<ReviewBox> {
  TextEditingController _reviewField = TextEditingController();
  final User? user = auth.currentUser;
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final providerViewModel = Provider.of<ProviderViewModel>(context);
    final reviewViewModel = Provider.of<ReviewViewModel>(context);
    final clientViewModel = Provider.of<ClientViewModel>(context);
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width / 1.5,
      child: Column(
        children: [
          Text(
            "Rate this provider",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
          ),
          Container(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              controller: _reviewField,
              maxLines: 7,
              minLines: 1,
              maxLength: 50,
              decoration: InputDecoration(
                  hintText: "Review goes here...",
                  hintStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: 50,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),
            width: MediaQuery.of(context).size.width / 1.8,
            child: MaterialButton(
              onPressed: () async {
                var result = await clientViewModel.getProviderById(user!.uid);
                String name = result.username!;
                String imageUrl = result.imageurl!;
                reviewViewModel
                    .rateProvider(
                        Reviews(
                            image: imageUrl,
                            name: name,
                            rate: widget.rate.toInt(),
                            review: _reviewField.text),
                        widget.providerId)
                    .then((value) {
                  Navigator.of(context).pop();
                });
              },
              child: Text(
                "post review",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }
}

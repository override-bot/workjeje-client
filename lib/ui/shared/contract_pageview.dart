import 'package:flutter/material.dart';
import 'package:workjeje/ui/shared/contract_details.dart';

class ContractPageView extends StatefulWidget {
  final String contractId;
  ContractPageView({required this.contractId});
  @override
  ContractPageViewState createState() => ContractPageViewState();
}

class ContractPageViewState extends State<ContractPageView> {
  PageController myPage = PageController(initialPage: 0);
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: PageView(
      controller: myPage,
      onPageChanged: (int page) {
        currentPage = page;
      },
      children: [
        ContractDetails(contractId: widget.contractId),
        Container(
          height: 150,
        ),
        Container(
          color: Colors.red,
          height: 300,
        )
      ],
    ));
  }
}

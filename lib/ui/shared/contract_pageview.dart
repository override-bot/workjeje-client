import 'package:flutter/material.dart';
import 'package:workjeje/ui/shared/contract_details.dart';
import 'package:workjeje/ui/shared/contract_terms.dart';
import 'package:workjeje/ui/shared/job_description.dart';

class ContractPageView extends StatefulWidget {
  final String contractId;
  final String contractTerms;
  final String jobDescription;
  ContractPageView(
      {required this.contractId,
      required this.contractTerms,
      required this.jobDescription});
  @override
  ContractPageViewState createState() => ContractPageViewState();
}

class ContractPageViewState extends State<ContractPageView> {
  PageController myPage = PageController(initialPage: 0);
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return PageView(
      
      physics: NeverScrollableScrollPhysics(),
      controller: myPage,
      onPageChanged: (int page) {
        currentPage = page;
      },
      children: [
        ContractDetails(
          contractId: widget.contractId,
          page: myPage,
        ),
        ContractTerms(
          contractTerms: widget.contractTerms,
          page: myPage,
        ),
        JobDescription(
          jobDescription: widget.jobDescription,
          page: myPage,
        )
      ],
    );
  }
}

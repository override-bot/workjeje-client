class Contracts {
  final String? id;
  final String employeeId;
  final String employerId;
  final String employerName;
  final String employeeName;
  final String employerPhoneNumber;
  final String employeePhoneNumber;
  dynamic createdAt;
  final String jobId;
  final String jobDescription;
  final String jobCategory;
  final String status;
  final String contractTerms;

  Contracts(
      {this.id,
      required this.employeeId,
      required this.employerId,
      required this.employerName,
      required this.employeeName,
      required this.employerPhoneNumber,
      required this.employeePhoneNumber,
      required this.createdAt,
      required this.jobId,
      required this.jobDescription,
      required this.jobCategory,
      required this.status,
      required this.contractTerms});

  Contracts.fromMap(Map snapshot, this.id)
      : employeeId = snapshot['employeeId'],
        employerId = snapshot['employerId'],
        employerName = snapshot['EmployerName'],
        employeeName = snapshot['EmployeeName'],
        employeePhoneNumber = snapshot['EmployeePhoneNumber'],
        employerPhoneNumber = snapshot['EmployerPhoneNumber'],
        createdAt = snapshot['createdAt'],
        jobId = snapshot['jobId'],
        jobDescription = snapshot['JobDescription'],
        jobCategory = snapshot['JobCategory'],
        status = snapshot['Status'],
        contractTerms = snapshot['ContractTerms'];

  toJson() {
    return {
      'employeeId': employeeId,
      'employerId': employerId,
      'EmployerName': employerName,
      'EmployeeName': employeeName,
      'EmployeePhoneNumber': employeePhoneNumber,
      'EmployerPhoneNumber': employerPhoneNumber,
      'createdAt': createdAt,
      'jobId': jobId,
      'JobDescription': jobDescription,
      'JobCategory': jobCategory,
      'Status': status,
      'ContractTerms': contractTerms
    };
  }
}

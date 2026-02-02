import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String id;
  final String serviceId;
  final String serviceName; // snapshot copy in case service name changes
  final String customerFullName;
  final String customerPhone;
  final DateTime createdAt;
  final String status; // 'pending', 'completed'

  RequestModel({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.customerFullName,
    required this.customerPhone,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'customerFullName': customerFullName,
      'customerPhone': customerPhone,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map, String id) {
    return RequestModel(
      id: id,
      serviceId: map['serviceId'] ?? '',
      serviceName: map['serviceName'] ?? '',
      customerFullName: map['customerFullName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
    );
  }
}

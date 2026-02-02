import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../models/service_model.dart';
import '../models/request_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Categories ---

  // Get Categories Stream
  Stream<List<CategoryModel>> getCategories() {
    return _firestore
        .collection('categories')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Add Category
  Future<void> addCategory(CategoryModel category) async {
    // If ID is provided (seeding), use it. Otherwise generate.
    final docRef = category.id.isNotEmpty
        ? _firestore.collection('categories').doc(category.id)
        : _firestore.collection('categories').doc();

    Map<String, dynamic> data = category.toMap();
    if (category.id.isEmpty) {
      data['id'] = docRef.id;
    }

    await docRef.set(data);
  }

  // Update Category
  Future<void> updateCategory(CategoryModel category) async {
    await _firestore
        .collection('categories')
        .doc(category.id)
        .update(category.toMap());
  }

  // Delete Category
  Future<void> deleteCategory(String id) async {
    await _firestore.collection('categories').doc(id).delete();
  }

  // --- Services ---

  // Get Services for a specific Category
  Stream<List<ServiceModel>> getServices(String categoryId) {
    return _firestore
        .collection('services')
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ServiceModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get All Services (for search/filtering)
  Stream<List<ServiceModel>> getAllServices() {
    return _firestore
        .collection('services')
        .orderBy('id') // Forcing absolute record stability
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ServiceModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Add Service
  Future<void> addService(ServiceModel service) async {
    final docRef = service.id.isNotEmpty
        ? _firestore.collection('services').doc(service.id)
        : _firestore.collection('services').doc();

    Map<String, dynamic> data = service.toMap();
    if (service.id.isEmpty) {
      data['id'] = docRef.id;
    }
    await docRef.set(data);
  }

  // Update Service
  Future<void> updateService(ServiceModel service) async {
    await _firestore
        .collection('services')
        .doc(service.id)
        .update(service.toMap());
  }

  // Delete Service
  Future<void> deleteService(String id) async {
    await _firestore.collection('services').doc(id).delete();
  }

  // --- Requests ---

  // Create Request (Public)
  Future<void> createRequest(RequestModel request) async {
    DocumentReference docRef = _firestore.collection('requests').doc();
    Map<String, dynamic> data = request.toMap();
    data['id'] = docRef.id;
    await docRef.set(data);
  }

  // Get Requests (Provider View)
  Stream<List<RequestModel>> getRequests() {
    return _firestore
        .collection('requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RequestModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}

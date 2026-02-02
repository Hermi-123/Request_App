import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';

class SeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SeedService();

  Future<void> seedData() async {
    // ---------------------------------------------------------
    // STEP 1: DESTRUCTIVE CLEANUP
    // ---------------------------------------------------------
    final collections = ['categories', 'services', 'requests', 'users'];
    for (var coll in collections) {
      final docs = await _firestore.collection(coll).get();
      for (var doc in docs.docs) {
        await doc.reference.delete();
      }
    }

    await _seedProviders();

    // ---------------------------------------------------------
    // STEP 2: CATEGORIES (ULTRA-STABLE SOURCE LINKS)
    // ---------------------------------------------------------
    const catB =
        'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=600';
    const catM =
        'https://images.unsplash.com/photo-1505751172107-1bc3bd973167?q=80&w=600';
    const catR =
        'https://images.unsplash.com/photo-1581092160607-ee22621dd758?q=80&w=600';
    const catP =
        'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?q=80&w=600';

    await _saveCat('cat_beauty', 'Beauty & Spas', catB);
    await _saveCat('cat_medical', 'Health & Medical', catM);
    await _saveCat('cat_repair', 'Maintenance', catR);
    await _saveCat('cat_pro', 'Professional', catP);

    // ---------------------------------------------------------
    // STEP 3: SERVICES (ORDERED & STABLE)
    // ---------------------------------------------------------

    // PROFESSIONAL
    await _addService(
      's01_legal',
      'cat_pro',
      'Expert Legal Consultation',
      3500.0,
      15,
      0,
      'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?q=80&w=800',
    );
    await _addService(
      's02_tax',
      'cat_pro',
      'Business Tax Filing',
      5500.0,
      15,
      500,
      'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?q=80&w=800',
    );

    // MEDICAL
    await _addService(
      's03_checkup',
      'cat_medical',
      'General Health Checkup',
      600.0,
      0,
      0,
      'https://images.unsplash.com/photo-1629909613654-28e377c37b09?q=80&w=800',
    );
    await _addService(
      's04_dental',
      'cat_medical',
      'Tigist Dental Cleaning',
      2300.0,
      0,
      200,
      'https://images.unsplash.com/photo-1598256989800-fe5f95da9787?q=80&w=800',
    );

    // REPAIR
    await _addService(
      's05_oil',
      'cat_repair',
      'Full Car Oil Change',
      4629.0,
      15,
      0,
      'https://images.unsplash.com/photo-1507702553912-a15641ec5821?q=80&w=800',
    );
    await _addService(
      's06_laptop',
      'cat_repair',
      'Laptop Hardware Repair',
      2300.0,
      15,
      0,
      'https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?q=80&w=800',
    );

    // BEAUTY
    await _addService(
      's07_haircut',
      'cat_beauty',
      'Abebe Men\'s Hair Cut',
      345.0,
      15,
      0,
      'https://images.unsplash.com/photo-1503951914875-befbb7470d03?q=80&w=800',
    );
    await _addService(
      's08_makeup',
      'cat_beauty',
      'Almaz Bridal Makeup',
      5250.0,
      15,
      500,
      'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?q=80&w=800',
    );
    await _addService(
      's09_massage',
      'cat_beauty',
      'Full Body Massage',
      1380.0,
      15,
      0,
      'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?q=80&w=800',
    );
  }

  Future<void> _saveCat(String id, String title, String img) async {
    final c = CategoryModel(
      id: id,
      title: title,
      description: 'Provider services',
      status: 'active',
      imageUrl: img,
    );
    await _firestore.collection('categories').doc(id).set(c.toMap());
  }

  Future<void> _addService(
    String id,
    String catId,
    String name,
    double price,
    double vat,
    double discount,
    String imgUrl,
  ) async {
    final s = ServiceModel(
      id: id,
      categoryId: catId,
      name: name,
      basePrice: price,
      vatPercent: vat,
      discountAmount: discount,
      imageUrl: imgUrl,
      status: 'active',
    );
    await _firestore.collection('services').doc(id).set(s.toMap());
  }

  Future<void> _seedProviders() async {
    final providers = [
      UserModel(
        uid: 'p1',
        fullName: 'Almaz Ayana',
        email: 'almaz@salon.com',
        phone: '0911234567',
        companyName: 'Bole City Salon',
        licenseNumber: 'LIC-2024-ALM',
      ),
      UserModel(
        uid: 'p2',
        fullName: 'Dr. Bekele T.',
        email: 'bekele@clinic.com',
        phone: '0922345678',
        companyName: 'Addis General Hospital',
        licenseNumber: 'MED-555-ET',
      ),
    ];
    for (var p in providers) {
      await _firestore.collection('users').doc(p.uid).set(p.toMap());
    }
  }
}

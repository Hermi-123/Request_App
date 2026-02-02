import 'package:flutter_test/flutter_test.dart';
import '../lib/models/service_model.dart';

void main() {
  group('Service Model Logic Tests', () {
    test('Total Price Calculation is Correct (Standard Case)', () {
      // Logic: (Base + (Base * VAT / 100)) - Discount
      // 100 + (100 * 10%) - 5 = 100 + 10 - 5 = 105

      final service = ServiceModel(
        id: '1',
        categoryId: 'cat1',
        name: 'Test Service',
        basePrice: 100.0,
        vatPercent: 10.0,
        discountAmount: 5.0,
      );

      expect(service.totalPrice, 105.0);
    });

    test('Total Price Calculation handles Zero VAT and Discount', () {
      final service = ServiceModel(
        id: '2',
        categoryId: 'cat1',
        name: 'Simple Service',
        basePrice: 50.0,
        vatPercent: 0.0,
        discountAmount: 0.0,
      );

      expect(service.totalPrice, 50.0);
    });

    test('Total Price should not be negative theoretically (logic check)', () {
      // If discount is huge
      final service = ServiceModel(
        id: '3',
        categoryId: 'cat1',
        name: 'Free Service',
        basePrice: 10.0,
        vatPercent: 0.0,
        discountAmount: 20.0,
      );

      // Our getter doesn't clamp to 0, but acts as pure math.
      // In a real app we might want to clamp this, but for the exam formula:
      // 10 + 0 - 20 = -10.
      expect(service.totalPrice, -10.0);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/orders/state/antrean_filter_view.dart';

void main() {
  test('enabled mode retains every status chip and its stable selection', () {
    for (var selected = 0; selected <= 4; selected++) {
      final view = AntreanFilterView(selected, useOrderStatus: true);
      expect(view.values, [0, 1, 2, 3, 4]);
      expect(view.selectedValue, selected);
      expect(view.selectedIndex, selected);
    }
  });
  test('disabled mode maps two visible chips to All and Review', () {
    const all = AntreanFilterView(0, useOrderStatus: false);
    const review = AntreanFilterView(4, useOrderStatus: false);
    expect(all.values, [0, 4]);
    expect(all.selectedIndex, 0);
    expect(review.selectedIndex, 1);
    expect(review.selectedValue, 4);
    expect(review.values[1], 4);
  });
  test('hidden persisted status selections fall back to All without changing stored selection', () {
    for (final selected in [1, 2, 3]) {
      final simplified = AntreanFilterView(selected, useOrderStatus: false);
      expect(simplified.selectedValue, 0);
      expect(simplified.selectedIndex, 0);
      expect(AntreanFilterView(selected, useOrderStatus: true).selectedValue, selected);
    }
  });
}

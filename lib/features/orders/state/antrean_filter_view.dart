class AntreanFilterView {
  const AntreanFilterView(this._selected, {required this.useOrderStatus});
  final int _selected;
  final bool useOrderStatus;

  List<int> get values => useOrderStatus ? [0, 1, 2, 3, 4] : [0, 4];
  int get selectedValue => !useOrderStatus && _selected != 4 ? 0 : _selected;
  int get selectedIndex => values.indexOf(selectedValue);
}

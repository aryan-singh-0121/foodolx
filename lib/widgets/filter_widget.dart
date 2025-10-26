// filter_widget.dart
import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  final Function(String?, String?, double?, double?) onApplyFilter;
  FilterWidget({required this.onApplyFilter});

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  TextEditingController _searchController = TextEditingController();
  String? _vegFilter;
  double _minPrice = 0;
  double _maxPrice = 1000;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Search & Filters'),
      children: [
        Padding(padding: EdgeInsets.all(8), child: TextField(controller: _searchController, decoration: InputDecoration(hintText: 'Search dish or shop...', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()))),
        Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Row(children: [Text('Diet: '), SizedBox(width: 10), DropdownButton<String>(value: _vegFilter, hint: Text('Any'), items: ['Veg', 'Non-Veg'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (val) => setState(() => _vegFilter = val))])),
        Padding(padding: EdgeInsets.all(8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Price Range: \$${_minPrice.toInt()} - \$${_maxPrice.toInt()}'), RangeSlider(min: 0, max: 1000, divisions: 20, values: RangeValues(_minPrice, _maxPrice), onChanged: (values) => setState(() { _minPrice = values.start; _maxPrice = values.end; }))])),
        Padding(padding: EdgeInsets.all(8), child: ElevatedButton(onPressed: () => widget.onApplyFilter(_searchController.text, _vegFilter, _minPrice, _maxPrice), child: Text('Apply Filters'))),
      ],
    );
  }
}

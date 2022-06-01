
import 'package:flutter/material.dart';

import '../Models/category.dart';

class SearchCategoryDelegate extends SearchDelegate<Category> {
  final List<Category> categories;

  List<Category> _filter = [];

  SearchCategoryDelegate(this.categories);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      onPressed: () {
        close(context, Category());
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: _filter.length,
      itemBuilder: (_, index) {
        return ListTile(
          title: Text(_filter[index].name),
          subtitle: Text(_filter[index].description),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _filter = categories.where((category) {
      return category.name.toLowerCase().contains(query.trim().toLowerCase())
               || category.description.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();
    return ListView.builder(
      itemCount: _filter.length,
      itemBuilder: (_, index) {
        return ListTile(
          title: Text(_filter[index].name),
          subtitle: Text(_filter[index].description),
        );
      },
    );
  }
  
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:algolia/algolia.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'search_model.dart';

class SearchPage extends ConsumerWidget {
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _searchProvider = watch(searchProvider);
    final searchController = TextEditingController.fromValue(
      TextEditingValue(
        text: _searchProvider.searchTerm,
        selection: TextSelection.collapsed(
          offset: _searchProvider.searchTerm.length
        )
      )
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search'),
        ),
        body: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (text) async {
                _searchProvider.searchTerm = text;
                await _searchProvider.operation(text);
              },
              style: TextStyle(
                color: Colors.black
              ),
              decoration: InputDecoration(
                
                border: InputBorder.none,
                 hintText: 'Search ...',
                hintStyle: TextStyle(
                  color: Colors.black
                ),
                prefixIcon: Icon(Icons.search, color: Colors.black,)
              ),
            ),
            StreamBuilder<AlgoliaQuerySnapshot>(
              stream: Stream.fromFuture(
                _searchProvider.operation(_searchProvider.searchTerm)
              ),
              builder: (context, snapshot) {
                if(!snapshot.hasData) return Text("Start Typing", style: TextStyle(color: Colors.black ),);
                else {
                  return Expanded(
                    child: _searchProvider.searchTerm.length > 0 ?
                    ListView(
                      children: snapshot.data!.hits.map((hit){
                        return 
                        ListTile(
                          title: Text(hit.data['title']),
                        );
                      }).toList()
                      
                    )
                    : SizedBox()
                  );
                }
              }
            )
          ]
        ),
      ),
    );
  }
}
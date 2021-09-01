import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/preservations/preservations_model.dart';
import 'package:whisper/preservations/audio_controll/audio_state_design.dart';

class PreservationsPage extends ConsumerWidget {
  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final _preservationsProvider = watch(preservationsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('preservations'),
      ),
      body: _preservationsProvider.isLoading ?
      Container(
        color: Colors.grey.withOpacity(0.7),
        child: Text('Loading'),
      )
      : _preservationsProvider.preservationDocs.isEmpty ?
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Nothing')
          )
        ],
      )
      : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _preservationsProvider.preservationDocs.length,
                itemBuilder: (BuildContext context, int i) =>
                  ListTile(
                    title: Text(_preservationsProvider.preservationDocs[i]['title']),
                    
                    
                  )
              ),
            ),
            AudioStateDesign(_preservationsProvider)
          ],
        )
    );
  }
}
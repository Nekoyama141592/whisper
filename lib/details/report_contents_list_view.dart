// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/lists.dart';
import 'package:whisper/constants/doubles.dart';

class ReportContentsListView extends StatelessWidget {
  const ReportContentsListView({
    Key? key,
    required this.selectedReportContentsNotifier,
  }) : super(key: key);
  final ValueNotifier<List<String>> selectedReportContentsNotifier;
  @override 
  Widget build(BuildContext context) {
    final reportContents = returnReportContents(context: context);
    return Container(
      height: flashDialogueHeight(context: context),
      child: ValueListenableBuilder<List<String>>(
        valueListenable: selectedReportContentsNotifier,
        builder: (_,selectedReportContents,__) {
          return ListView.builder(
            itemCount: reportContents.length,
            itemBuilder: (BuildContext context, int i) {
              final String reportContent = reportContents[i];
              return ListTile(
                leading: selectedReportContents.contains(reportContent) ? Icon(Icons.check) : SizedBox.shrink(),
                title: Text(reportContent),
                onTap: () {
                  if (selectedReportContentsNotifier.value.contains(reportContent) == false) {
                    List<String> x = selectedReportContentsNotifier.value;
                    x.add(reportContent);
                    selectedReportContentsNotifier.value = x.map((e) => e).toList();
                  }
                },
              );
            }
          );
        }
      ),
    );
  }
}
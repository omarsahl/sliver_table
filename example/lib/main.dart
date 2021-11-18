import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliver_table/sliver_table.dart';

void main() async {
  runApp(
    MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Scaffold(
        body: DefaultTextStyle(
          child: ColorsTable(),
          style: const TextStyle(fontSize: 15.0, color: Colors.white),
        ),
      ),
    ),
  );
}

class ColorsTable extends StatelessWidget {
  ColorsTable({Key? key}) : super(key: key);

  static const colorShades = [500, 600, 700, 800, 900];

  final SliverTableController _tableController = SliverTableController(
    colsCount: colorShades.length,
    rowsCount: 100,
    cellWidth: 100.0,
    cellHeight: 50.0,
    topHeaderHeight: 60.0,
    leftHeaderCellWidth: 120.0,
    topLeftCorner: Container(
      color: Colors.yellow.shade800,
      alignment: Alignment.center,
      child: const Text('Corner'),
    ),
    topHeaderBuilder: (context, i) {
      return _buildText('Col #$i', Colors.yellow.shade800);
    },
    leftHeaderBuilder: (context, i) {
      return _buildText('Row Header #$i', Colors.primaries[i % Colors.primaries.length].shade400);
    },
    cellBuilder: (context, row, col) {
      return _buildText(
          'Cell ($row, $col)', Colors.primaries[row % Colors.primaries.length][colorShades[col]]);
    },
  );

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          primary: true,
          expandedHeight: 150.0,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text('Sliver Table Demo'),
          ),
        ),
        SliverTableHeader(tableController: _tableController),
        SliverTableBody(tableController: _tableController),
      ],
    );
  }

  static Widget _buildText(String text, [Color? bgColor]) {
    return Container(
      child: Text(text),
      alignment: Alignment.center,
      color: bgColor ?? Colors.black,
    );
  }
}

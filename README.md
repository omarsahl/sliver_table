#Sliver Table
[![Pub](https://img.shields.io/pub/v/dio.svg?style=flat-square)](https://pub.dartlang.org/packages/sliver_table)

This flutter package provides a table widget that can be used 
inside of a [CustomScrollView](https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html).
 
## Getting started

```yaml
dependencies:
  sliver_table: ^0.0.1
```

## Preview
![Preview](https://raw.githubusercontent.com/omarsahl/sliver_table/master/preview/preview.gif)

## Usage

```dart
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
```


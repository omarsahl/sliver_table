# Sliver Table

[![Pub](https://img.shields.io/pub/v/sliver_table.svg?style=flat-square)](https://pub.dartlang.org/packages/sliver_table)

This flutter package provides a table widget that can be used inside of
a [CustomScrollView](https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html).

## Getting started

```yaml
dependencies:
  sliver_table: ^0.0.2
```

## Preview

![Preview](https://raw.githubusercontent.com/omarsahl/sliver_table/master/preview/preview.gif)

## Usage

```dart
class ColorsTable extends StatelessWidget {
  const ColorsTable({Key? key}) : super(key: key);

  static const colorShades = [500, 600, 700, 800, 900];

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
        SliverTable(
          cellWidth: 100.0,
          cellHeight: 50.0,
          rowsCount: 100,
          colsCount: colorShades.length,
          topHeaderHeight: 60.0,
          leftHeaderCellWidth: 120.0,
          topLeftCorner: Container(
            color: Colors.yellowAccent.shade700,
            alignment: Alignment.center,
            child: const Text('Corner'),
          ),
          topHeaderBuilder: (context, i) {
            return TableCell(text: 'Col #$i');
          },
          leftHeaderBuilder: (context, i) {
            return TableCell(
              text: 'Row Header #$i',
              color: Colors.primaries[i % Colors.primaries.length].shade400,
            );
          },
          cellBuilder: (context, row, col) {
            return TableCell(
              text: 'Cell ($row, $col)',
              color: Colors.primaries[row % Colors.primaries.length][colorShades[col]],
            );
          },
          topHeaderContainerBuilder: (context, header) {
            return Material(
              color: Colors.yellowAccent,
              elevation: 5,
              child: header,
            );
          },
        ),
      ],
    );
  }
}

class TableCell extends StatelessWidget {
  const TableCell({required this.text, this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: color,
      child: Text(text),
    );
  }
}
```


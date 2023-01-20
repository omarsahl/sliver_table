library sliver_table;

import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

const double _kDefaultCellWidth = 60.0;
const double _kDefaultCellHeight = 60.0;
const double _kDefaultTopHeaderHeight = 50.0;
const double _kDefaultLeftHeaderCellWidget = 100.0;

/// A builder function that creates a widget for a given position in a 2D grid of widgets.
typedef TableCellBuilder = Widget Function(BuildContext context, int row, int col);

typedef WidgetContainerBuilder = Widget Function(BuildContext context, Widget child);

typedef IndexedBackgroundBuilder = Widget Function(BuildContext context, Widget child, int index, int length);

class _SliverTableConfig {
  final int rowsCount;
  final int colsCount;
  final double cellWidth;
  final double cellHeight;
  final Widget topLeftCorner;
  final double topHeaderHeight;
  final double leftHeaderCellWidth;
  final TableCellBuilder cellBuilder;
  final IndexedWidgetBuilder leftHeaderBuilder;
  final IndexedWidgetBuilder topHeaderBuilder;
  final IndexedBackgroundBuilder? rowContainerBuilder;
  final WidgetContainerBuilder? topHeaderContainerBuilder;
  final LinkedScrollControllerGroup _hScrollControllers = LinkedScrollControllerGroup();

  _SliverTableConfig({
    required this.rowsCount,
    required this.colsCount,
    required this.cellWidth,
    required this.cellHeight,
    required this.topLeftCorner,
    required this.topHeaderHeight,
    required this.leftHeaderCellWidth,
    required this.cellBuilder,
    required this.leftHeaderBuilder,
    required this.topHeaderBuilder,
    required this.rowContainerBuilder,
    required this.topHeaderContainerBuilder,
  });

  ScrollController _newScrollController() => _hScrollControllers.addAndGet();
}

/// A sliver that displays a two dimensional scrollable (in both directions) grid of box children.
/// The table consists of a horizontal top header, a vertical left header, and a [rowsCount] x [colsCount]
/// grid of cells.
/// The vertical header is pinned at the top edge of the table and displays [colsCount] cells that are
/// horizontally scrollable.
/// The horizontal header is pinned at the left side of the table and displays [rowsCount] cells that are
/// vertically scrollable.
/// The grid of cells can scroll both vertically and horizontally under the top and left headers respectively.
///
/// The [topHeaderBuilder] builder callback is used to build the top header's cells, where each cell will be
/// given a height of [topHeaderHeight] and a width of [cellWidth].
///
/// To wrap the whole top header in another widget, you can use the [topHeaderContainerBuilder] callback,
/// which can be used, for example, to add a background color.
///
/// The [leftHeaderBuilder] builder callback is used to build the left header's cells, where each cell will be
/// given a height of [cellHeight] and a width of [leftHeaderCellWidth].
///
/// The [cellBuilder] builder callback is used build the grid's cells, where each cell will be given a height
/// of [cellHeight] and a width of [cellWidth].
///
/// The [topLeftCorner] is used to add any type of widget to the top left corner of the table.
class SliverTable extends StatefulWidget {
  /// The number of rows in this [SliverTable].
  final int rowsCount;

  /// The number of columns in this [SliverTable].
  final int colsCount;

  /// The width of each cell in the table.
  /// Defaults to 60.0 when no value is set.
  final double cellWidth;

  /// The height of each cell in the table.
  /// Defaults to 60.0 when no value is set.
  final double cellHeight;

  /// The height of each cell in the top horizontal table header.
  /// Defaults to 50.0 when no value is set.
  final double topHeaderHeight;

  /// The width of each cell in the vertical left-side header.
  /// Defaults to 100.0 when no value is set.
  final double leftHeaderCellWidth;

  /// The builder callback used to build each cell in table.
  final TableCellBuilder cellBuilder;

  /// The builder callback used to build each cell in the vertical table header.
  final IndexedWidgetBuilder leftHeaderBuilder;

  /// The builder callback used to build each cell in the horizontal table header.
  final IndexedWidgetBuilder topHeaderBuilder;

  /// The builder callback used to build the container of the top vertical table header.
  /// Can be used, for example, to add a background color for the top header.
  final WidgetContainerBuilder? topHeaderContainerBuilder;

  /// The builder callback used to build the container of each row in the table.
  /// Can be used, for example, to add a background color for each row in the table.
  final IndexedBackgroundBuilder? rowContainerBuilder;

  /// The widget shown at the top left corner of the table.
  final Widget? topLeftCorner;

  final _SliverTableConfig _config;

  SliverTable({
    Key? key,
    required this.rowsCount,
    required this.colsCount,
    required this.cellBuilder,
    required this.topHeaderBuilder,
    required this.leftHeaderBuilder,
    this.topLeftCorner,
    this.rowContainerBuilder,
    this.topHeaderContainerBuilder,
    this.cellWidth = _kDefaultCellWidth,
    this.cellHeight = _kDefaultCellHeight,
    this.topHeaderHeight = _kDefaultTopHeaderHeight,
    this.leftHeaderCellWidth = _kDefaultLeftHeaderCellWidget,
  })  : _config = _SliverTableConfig(
          rowsCount: rowsCount,
          colsCount: colsCount,
          cellWidth: cellWidth,
          cellHeight: cellHeight,
          topLeftCorner: topLeftCorner ?? Container(),
          topHeaderHeight: topHeaderHeight,
          leftHeaderCellWidth: leftHeaderCellWidth,
          cellBuilder: cellBuilder,
          leftHeaderBuilder: leftHeaderBuilder,
          topHeaderBuilder: topHeaderBuilder,
          rowContainerBuilder: rowContainerBuilder,
          topHeaderContainerBuilder: topHeaderContainerBuilder,
        ),
        super(key: key);

  @override
  State<SliverTable> createState() => _SliverTableState();
}

class _SliverTableState extends State<SliverTable> {
  late ScrollController _headerScrollController;

  @override
  void initState() {
    super.initState();
    _headerScrollController = widget._config._newScrollController();
  }

  @override
  void dispose() {
    _headerScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = widget._config;
    return SliverStickyHeader(
      header: _SliverTableHeader(config, _headerScrollController),
      sliver: SliverFixedExtentList(
        itemExtent: config.cellHeight,
        delegate: SliverChildBuilderDelegate(
          childCount: config.rowsCount,
          (context, row) {
            final child = _SliverTableRow(row, config);
            return config.rowContainerBuilder == null
                ? child
                : config.rowContainerBuilder!.call(context, child, row, config.rowsCount);
          },
        ),
      ),
    );
  }
}

class _SliverTableHeader extends StatelessWidget {
  final _SliverTableConfig _config;
  final ScrollController _scrollController;

  const _SliverTableHeader(this._config, this._scrollController);

  @override
  Widget build(BuildContext context) {
    Widget header = Row(
      children: [
        SizedBox(
          height: _config.topHeaderHeight,
          width: _config.leftHeaderCellWidth,
          child: _config.topLeftCorner,
        ),
        Flexible(
          child: SizedBox(
            height: _config.topHeaderHeight,
            child: ListView.builder(
              key: const ValueKey('_sliverTableTopHeader'),
              itemCount: _config.colsCount,
              itemExtent: _config.cellWidth,
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: _config.topHeaderBuilder,
            ),
          ),
        ),
      ],
    );
    return _config.topHeaderContainerBuilder == null
        ? header
        : _config.topHeaderContainerBuilder!.call(context, header);
  }
}

class _SliverTableRow extends StatefulWidget {
  final int row;
  final _SliverTableConfig config;

  const _SliverTableRow(this.row, this.config, {Key? key}) : super(key: key);

  @override
  State<_SliverTableRow> createState() => _SliverTableRowState();
}

class _SliverTableRowState extends State<_SliverTableRow> {
  late ScrollController _scrollController;

  int get _row => widget.row;

  _SliverTableConfig get _config => widget.config;

  @override
  void initState() {
    super.initState();
    _scrollController = _config._newScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
      child: Row(
        children: [
          SizedBox(
            height: _config.cellHeight,
            width: _config.leftHeaderCellWidth,
            child: _config.leftHeaderBuilder(context, _row),
          ),
          Flexible(
            child: SizedBox(
              height: _config.cellHeight,
              child: ListView.builder(
                key: ValueKey('_sliverTableRow#$_row'),
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: _config.colsCount,
                itemExtent: _config.cellWidth,
                itemBuilder: (context, col) => _config.cellBuilder(context, _row, col),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

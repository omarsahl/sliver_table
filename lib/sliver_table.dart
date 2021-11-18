library sliver_table;

import 'package:flutter/widgets.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:sliver_tools/sliver_tools.dart';

const double _kDefaultCellWidth = 60.0;
const double _kDefaultCellHeight = 60.0;
const double _kDefaultTopHeaderHeight = 50.0;
const double _kDefaultLeftHeaderCellWidget = 120.0;

typedef TableCellBuilder = Widget Function(BuildContext context, int row, int col);

class SliverTableController {
  final LinkedScrollControllerGroup _hScrollControllers = LinkedScrollControllerGroup();

  final int rowsCount;
  final int colsCount;
  final double cellWidth;
  final double cellHeight;
  final double topHeaderHeight;
  final double leftHeaderCellWidth;
  final TableCellBuilder cellBuilder;
  final IndexedWidgetBuilder leftHeaderBuilder;
  final IndexedWidgetBuilder topHeaderBuilder;
  final Widget? topLeftCorner;

  SliverTableController({
    required this.rowsCount,
    required this.colsCount,
    required this.cellBuilder,
    required this.topHeaderBuilder,
    required this.leftHeaderBuilder,
    this.topLeftCorner,
    this.cellWidth = _kDefaultCellWidth,
    this.cellHeight = _kDefaultCellHeight,
    this.topHeaderHeight = _kDefaultTopHeaderHeight,
    this.leftHeaderCellWidth = _kDefaultLeftHeaderCellWidget,
  });

  ScrollController _newScrollController() => _hScrollControllers.addAndGet();
}

class SliverTableHeader extends StatefulWidget {
  final SliverTableController tableController;

  const SliverTableHeader({required this.tableController, Key? key}) : super(key: key);

  @override
  State<SliverTableHeader> createState() => _SliverTableHeaderState();
}

class _SliverTableHeaderState extends State<SliverTableHeader> {
  late ScrollController _scrollController;

  SliverTableController get _tableController => widget.tableController;

  @override
  void initState() {
    super.initState();
    _scrollController = _tableController._newScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPinnedHeader(
      child: Row(
        children: [
          SizedBox(
            child: _tableController.topLeftCorner ?? Container(),
            height: _tableController.topHeaderHeight,
            width: _tableController.leftHeaderCellWidth,
          ),
          Flexible(
            child: SizedBox(
              height: _tableController.topHeaderHeight,
              child: ListView.builder(
                key: const ValueKey('_sliverTableTopHeader'),
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: _tableController.colsCount,
                itemExtent: _tableController.cellWidth,
                itemBuilder: _tableController.topHeaderBuilder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SliverTableBody extends StatefulWidget {
  final SliverTableController tableController;

  const SliverTableBody({required this.tableController, Key? key}) : super(key: key);

  @override
  _SliverTableBodyState createState() => _SliverTableBodyState();
}

class _SliverTableBodyState extends State<SliverTableBody> {
  SliverTableController get _tableController => widget.tableController;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, row) => SliverTableRow(row: row, tableController: _tableController),
        childCount: _tableController.rowsCount,
      ),
    );
  }
}

class SliverTableRow extends StatefulWidget {
  final int row;
  final SliverTableController tableController;

  const SliverTableRow({required this.row, required this.tableController, Key? key}) : super(key: key);

  @override
  _SliverTableRowState createState() => _SliverTableRowState();
}

class _SliverTableRowState extends State<SliverTableRow> {
  late ScrollController _scrollController;

  SliverTableController get _tableController => widget.tableController;

  @override
  void initState() {
    super.initState();
    _scrollController = _tableController._newScrollController();
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
            height: _tableController.cellHeight,
            width: _tableController.leftHeaderCellWidth,
            child: _tableController.leftHeaderBuilder(context, widget.row),
          ),
          Flexible(
            child: SizedBox(
              height: _tableController.cellHeight,
              child: ListView.builder(
                key: ValueKey('_sliverTableRow#${widget.row}'),
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: _tableController.colsCount,
                itemExtent: _tableController.cellWidth,
                itemBuilder: (context, col) => _tableController.cellBuilder(context, widget.row, col),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

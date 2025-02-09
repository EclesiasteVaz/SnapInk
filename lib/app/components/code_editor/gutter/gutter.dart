import 'package:flutter/material.dart';

import '../code_field/code_controller.dart';
import '../line_numbers/gutter_style.dart';

const _issueColumnWidth = 16.0;
const _foldingColumnWidth = 16.0;

const _lineNumberColumn = 0;
const _issueColumn = 1;
const _foldingColumn = 2;

class GutterWidget extends StatelessWidget {
  const GutterWidget({
    required this.codeController,
    required this.style,
  });

  final CodeController codeController;
  final GutterStyle style;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: codeController,
      builder: _buildOnChange,
    );
  }

  Widget _buildOnChange(BuildContext context, Widget? child) {
    final code = codeController.code;

    final gutterWidth = style.width -
        (style.showErrors ? 0 : _issueColumnWidth) -
        (style.showFoldingHandles ? 0 : _foldingColumnWidth);

    final issueColumnWidth = style.showErrors ? _issueColumnWidth : 0.0;
    final foldingColumnWidth =
        style.showFoldingHandles ? _foldingColumnWidth : 0.0;

    final tableRows = List.generate(
      code.hiddenLineRanges.visibleLineNumbers.length,
      (i) => TableRow(
        children: [
          const SizedBox(),
          const SizedBox(),
          const SizedBox(),
        ],
      ),
    );

    _fillLineNumbers(tableRows);

    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 12, right: style.margin),
      width: style.showLineNumbers ? gutterWidth : null,
      child: Table(
        columnWidths: {
          _lineNumberColumn: const FlexColumnWidth(),
          _issueColumn: FixedColumnWidth(issueColumnWidth),
          _foldingColumn: FixedColumnWidth(foldingColumnWidth),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: tableRows,
      ),
    );
  }

  void _fillLineNumbers(List<TableRow> tableRows) {
    final code = codeController.code;

    for (final i in code.hiddenLineRanges.visibleLineNumbers) {
      final lineIndex = _lineIndexToTableRowIndex(i);

      if (lineIndex == null) {
        continue;
      }

      tableRows[lineIndex].children[_lineNumberColumn] = Text(
        style.showLineNumbers ? '${i + 1}' : ' ',
        style: style.textStyle,
        textAlign: style.textAlign,
      );
    }
  }

  int? _lineIndexToTableRowIndex(int line) {
    return codeController.code.hiddenLineRanges.cutLineIndexIfVisible(line);
  }
}

import '../models/exports.dart';

class FirstPath {
  List<String> rows;
  int deleteRowCount = 0;

  FirstPath(this.rows);

  List<String> execute() {
    final cleaned = _cleanFromCommentSpacesNewlines(rows);
    return _initAllLabelsAndVars(cleaned);
  }

  List<String> _cleanFromCommentSpacesNewlines(List<String> rows) {
    return rows
        .where((row) {
          final trimmedRow = row.trim();
          return !row.trim().startsWith('//') && trimmedRow.isNotEmpty;
        })
        .map((row) => row.trim().replaceAll(RegExp(r'\n'), ''))
        .toList();
  }

  List<String> _initAllLabelsAndVars(List<String> rows) {
    List<String> withoutLabels = [];
    for (var r = 0; r < rows.length; r++) {
      final i = rows[r];
      if (i.startsWith('(') && i.endsWith(')')) {
        print('ROW: ${rows[r]}, index: $r');
        final label = i.substring(1, i.length - 1);
        print('MARK: $label');
        final key = symbolTable[label];
        if (key == null) {
          symbolTable[label] = r - deleteRowCount;
          deleteRowCount++;
        }
        continue;
      } else {
        withoutLabels.add(i);
      }
    }
    print(withoutLabels);
    return withoutLabels;
  }
}

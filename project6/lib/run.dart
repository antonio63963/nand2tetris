import 'dart:io';
import 'package:nand_assembler/models/comp.dart';
import 'package:nand_assembler/models/destination.dart';
import 'package:nand_assembler/models/jump.dart';
import 'package:nand_assembler/models/symbol_table.dart';
import 'package:path/path.dart' as p;

class Instruction {
  final String _saveDirName;
  final String _dirAsmName;

  const Instruction({
    required String saveDirName,
    required String dirAsmName,
  })  : _saveDirName = saveDirName,
        _dirAsmName = dirAsmName;

  Future<void> create(String pathFile) async {
    final libDir = getLibDirPath();
    final fileName = p.basename(pathFile);
    //save file
    final saveFilePath = p.join(
      libDir,
      _saveDirName,
      '${p.basenameWithoutExtension(pathFile)}.hack',
    );
    final fileInstructions = File(saveFilePath);

    final listRowsContent = await _getContentFile(libDir, fileName);
    final withoutCommentsAndSpace =
        _cleanFromCommentSpacesNewlines(listRowsContent);
    final compiled = [];

    for (final i in withoutCommentsAndSpace) {
      final instruction = _toDigitInstruction(i);
      await fileInstructions.writeAsString(
        instruction + '\n',
        mode: FileMode.append,
      );
      compiled.add(instruction);
    }

    print('ListROWS: $withoutCommentsAndSpace');
    print('ListINSTRUCTIONS: $compiled');
  }

  getLibDirPath() {
    String projectRoot = p.dirname(Platform.script.toFilePath());
    return p.join(projectRoot, '..', 'lib');
  }

  Future<List<String>> _getContentFile(
    String libDir,
    String fileName,
  ) async {
    final addFilePath = p.join(libDir, _dirAsmName, fileName);
    final content = await File(addFilePath).readAsString();
    final listRowsContent = content.split('\n');
    return listRowsContent;
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

  _toDigitInstruction(String row) {
    final isAinstruction = row.startsWith(RegExp(r'@'));
    if (isAinstruction) {
      return _getAddressInstruction(row);
    } else {
      return _getComputedInstruction(row);
    }
  }

  String _getAddressInstruction(String row) {
    final address = row.split('@')[1];
    final twoDigitValue = int.parse(address).toRadixString(2).padLeft(15, '0');
    print('DIGIT: $twoDigitValue');
    return '0$twoDigitValue';
  }

  String _getComputedInstruction(String row) {
    final splitted = row.split('=');
    if (splitted.length > 1) {
      final compPart = splitted[1];
      final dest = destinationMap[splitted[0]];
      final comp =
          compPart.contains('M') ? compMmap[compPart] : compAmap[compPart];
      return '111$comp${dest}000';
    } else {
      final splittedJump = row.split(';');
      late String instruction;
      if (splittedJump.length > 1) {
        final compPart = splittedJump[0];
        final comp =
            compPart.contains('M') ? compMmap[compPart] : compAmap[compPart];
        final jump = jumpMap[splittedJump[1]];
        instruction = '111${comp}000$jump';
      }
      return instruction;
    }
  }
}

import 'dart:io';
import 'package:nand_assembler/services/first_path.dart';
import 'package:nand_assembler/services/second_path.dart';
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
    final libDir = _getLibDirPath();
    final fileName = p.basename(pathFile);
    //save file
    final saveFilePath = p.join(
      libDir,
      _saveDirName,
      '${p.basenameWithoutExtension(pathFile)}.hack',
    );

    final listRowsContent = await _getContentFile(libDir, fileName);
    final firstPathResult = FirstPath(listRowsContent).execute();
    await SecondPath(firstPathResult, saveFilePath).execute();
  }

  _getLibDirPath() {
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
}

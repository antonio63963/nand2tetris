import 'dart:io';

import '../models/exports.dart';

class SecondPath {
  final List<String> rows;
  File fileInstructions;
  int varRegister = 16;

  SecondPath(this.rows, String saveFilePath)
      : fileInstructions = File(saveFilePath);

  Future<void> execute() async {
    if (await fileInstructions.exists()) {
      await fileInstructions.delete();
    }

    final compiled = [];
    for (final i in rows) {
      final instruction = _toDigitInstruction(i);
      await fileInstructions.writeAsString(
        instruction + '\n',
        mode: FileMode.append,
      );
      compiled.add(instruction);
    }
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
    final addressString = row.split('@')[1];

    final address = int.tryParse(addressString);
    if (address != null) {
      return _convertAddressToTwoDigitAndGetInstruction(address);
    } else {
      final valueTableSymbols = symbolTable[addressString];
      if (valueTableSymbols != null) {
        return _convertAddressToTwoDigitAndGetInstruction(valueTableSymbols);
      } else {
        // print('Wrong value. Not found in symbol table. Symbol: $addressString');
        symbolTable[addressString] = varRegister;
        final instruction =
            _convertAddressToTwoDigitAndGetInstruction(varRegister);
        varRegister++;
        return instruction;
      }
    }
  }

  String _convertAddressToTwoDigitAndGetInstruction(int address) {
    final twoDigitValue = address.toRadixString(2).padLeft(15, '0');
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
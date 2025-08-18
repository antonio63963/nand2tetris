import 'package:nand_assembler/run.dart';

void main(List<String> arguments) async {
  final instruction = Instruction(
    dirAsmName: 'asm_files',
    saveDirName: 'instructions',
  );
  instruction.create('Add.asm');
}

import 'dart:convert';
import 'dart:io';

Future<List<String>> readFileLines(String path) async {
  try {
    final file = File(path);
    return await file.readAsLines();
  } catch (e) {
    print('파일을 읽는 중 오류 발생: $e');
    return [];
  }
}

Future<List<int>?> loadCharacterStats() async {
  List<String> lines = await readFileLines('data/character.txt');
  if (lines.isEmpty) return null;

  var stats = lines[0].split(',');
  if (stats.length != 3) return null;

  try {
    return stats.map((e) => int.parse(e.trim())).toList();
  } catch (e) {
    print('캐릭터 데이터 파싱 오류 $e');
    return null;
  }
}

Future<List<List<String>>?> loadMonsterStats() async {
  List<String> lines = await readFileLines('data/monster.txt');
  if (lines.isEmpty) return null;

  List<List<String>> monsters = [];
  for (var line in lines) {
    var parts = line.split(',');
    if (parts.length != 4) {
      print('잘못된 몬스터 데이터 라인: $line');
      continue;
    }
    monsters.add(parts.map((e) => e.trim()).toList());
  }
  return monsters;
}

String? inputCharacterName() {
  final nameRegex = RegExp(r'^[a-zA-Z가-힣]+$');

  while (true) {
    stdout.write('\n캐릭터 이름을 입력하세요 (한글, 영문):');
    String? input = stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

    if (input == null || input.trim().isEmpty) {
      print('이름을 입력해야합니다.');
      continue;
    }

    if (!nameRegex.hasMatch(input.trim())) {
      print("\n이름에는 한글 또는 영문 대소문자만 사용할 수 있습니다.");
      continue;
    }
    return input.trim();
  }
}

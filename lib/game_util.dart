import 'dart:convert'; // UTF-8 인코딩/디코딩 지원
import 'dart:io'; // 파일 입출력 및 사용자 입력 지원

Future<List<String>> readFileLines(String path) async {
  // 파일 경로를 받아 비동기로 파일을 읽고 라인별 문자열 리스트 반환
  try {
    final file = File(path); // 파일 객체 생성
    return await file.readAsLines(); // 파일 전체를 라인 단위로 읽기 (비동기)
  } catch (e) {
    print('파일을 읽는 중 오류 발생: $e'); // 오류 메시지 출력
    return []; // 빈 리스트 반환
  }
}

Future<List<int>?> loadCharacterStats() async {
  // character.txt 파일에서 캐릭터 스탯(체력, 공격력, 방어력)을 불러옴
  List<String> lines = await readFileLines('data/character.txt'); // 파일 읽기
  if (lines.isEmpty) return null; // 파일이 비었으면 null 반환

  var stats = lines[0].split(','); // 첫 줄을 ',' 기준 분리
  if (stats.length != 3) return null; // 3개 항목 아니면 null 반환

  try {
    return stats
        .map((e) => int.parse(e.trim()))
        .toList(); // 각 항목 공백 제거 후 int 변환
  } catch (e) {
    print('캐릭터 데이터 파싱 오류 $e'); // 숫자 변환 실패 시 메시지 출력
    return null;
  }
}

Future<List<List<String>>?> loadMonsterStats() async {
  // monster.txt 파일에서 몬스터 정보 (이름, 체력, 최대 공격력, 인트로 메시지)를 불러옴
  List<String> lines = await readFileLines('data/monster.txt'); // 파일 읽기
  if (lines.isEmpty) return null;

  List<List<String>> monsters = [];
  for (var line in lines) {
    var parts = line.split(','); // ',' 기준 분리
    if (parts.length != 4) {
      // 4개 항목 아니면 경고 출력 후 무시
      print('잘못된 몬스터 데이터 라인: $line');
      continue;
    }
    monsters.add(parts.map((e) => e.trim()).toList()); // 공백 제거 후 리스트에 추가
  }
  return monsters;
}

String? inputCharacterName() {
  // 사용자에게 캐릭터 이름을 입력받음 (한글/영문만 허용)
  final nameRegex = RegExp(r'^[a-zA-Z가-힣]+$'); // 허용할 문자 정규식

  while (true) {
    stdout.write('\n캐릭터 이름을 입력하세요 (한글, 영문):');
    String? input = stdin.readLineSync(
        encoding: Encoding.getByName('utf-8')!); // 입력 받기 (UTF-8)

    if (input == null || input.trim().isEmpty) {
      // 입력이 없으면 재입력 요청
      print('이름을 입력해야합니다.');
      continue;
    }

    if (!nameRegex.hasMatch(input.trim())) {
      // 정규식에 맞지 않으면 재입력 요청
      print("\n이름에는 한글 또는 영문 대소문자만 사용할 수 있습니다.");
      continue;
    }
    return input.trim(); // 정상 입력이면 반환
  }
}

import 'dart:async'; // 비동기 처리를 위해 사용
import 'dart:io'; // 파일 입출력을 위해 사용
import '../lib/character.dart'; // 캐릭터 클래스 import
import '../lib/game.dart'; // 게임 실행용 클래스 import
import '../lib/monster.dart'; // 몬스터 클래스 import
import '../lib/game_util.dart'; // 유틸 함수들 (입력, 파일 로딩 등)

Future<void> main() async {
  // 비동기 메인 함수: await 사용 가능하게 함
  print('\n================================================================'
      '\n=========================NBC RPG ONLINE========================='
      '\n================================================================'); // 게임 타이틀 출력
  String name = inputCharacterName()!; // 캐릭터 이름 입력 받기

  List<int>? charStats = await loadCharacterStats(); // 캐릭터 능력치 불러오기
  if (charStats == null) {
    print('캐릭터 데이터를 불러오지 못해 게임을 시작할 수 없습니다.');
    exit(1); // 프로그램 종료
  }

  Character character = Character(name, charStats[0], charStats[1],
      charStats[2]); // 캐릭터 객체 생성 (name, hp, atk, def)

  List<List<String>>? monsterData = await loadMonsterStats(); // 몬스터 리스트 불러오기

  if (monsterData == null || monsterData.isEmpty) {
    print('몬스터 데이터를 불러오지 못해 게임을 시작할 수 없습니다.');
    exit(1);
  }

  List<Monster> monsters = monsterData.map((data) {
    // 문자열 리스트를 몬스터 객체 리스트로 변환
    String mName = data[0];
    int health = int.tryParse(data[1]) ?? 10;
    int maxAttack = int.tryParse(data[2]) ?? 5;
    String introMessage = data.length >= 4 ? data[3] : '...';
    return Monster(mName, health, maxAttack, introMessage);
  }).toList();

  Game game = Game(character, monsters); // 게임 객체 생성 및 실행
  game.startGame();
}

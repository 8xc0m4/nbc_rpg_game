import 'dart:io'; // 터미널 입출력 및 파일 입출력
import 'dart:math'; // 난수 생성용
import 'character.dart'; // 캐릭터 클래스
import 'monster.dart'; // 몬스터 클래스

abstract class Entity {
  // 게임 내 모든 개체 기본 클래스
  String name;
  int health;
  int attackPower;
  int defense;

  Entity(this.name, this.health, this.attackPower, this.defense);

  void showStatus(); // 상태 출력 추상 메서드

  void attack(Entity target); // 공격 추상 메서드
}

class Game {
  Character character; // 플레이어 캐릭터
  List<Monster> monsters; // 몬스터 리스트
  int defeatedMonsters = 0; // 처치한 몬스터 수

  Game(this.character, this.monsters);

  Monster getRandomMonster() {
    // 몬스터 랜덤 선택
    final rand = Random();
    int idx = rand.nextInt(monsters.length);
    return monsters[idx];
  }

  void applyHealthBonus() {
    // 30% 확률로 캐릭터 체력 10 회복
    final rand = Random();
    if (rand.nextInt(100) < 30) {
      character.health += 10;
      print('보너스 체력을 얻었습니다! 현재 체력: ${character.health}');
    }
  }

  List<String> defeatedMonsterNames = []; // 처치 몬스터 이름 기록

  void startGame() {
    // 게임 시작 및 메인 루프
    print('===================\n'
        '⚔️===게임 시작===⚔️\n'
        '===================\n');

    applyHealthBonus();

    while (character.health > 0 && defeatedMonsters < monsters.length) {
      Monster monster = getRandomMonster();
      monster.assignAttackPower(character.defense); // 몬스터 공격력 설정
      print('======================\n'
          '[새로운 몬스터 등장‼️]\n'
          '======================\n');
      monster.sayIntro();
      monster.showStatus();

      bool continueBattle = battle(monster); // 전투 진행

      if (!continueBattle) {
        print('\n게임을 종료합니다.[게임 오버]');
        saveResult();
        break;
      }
//else if로 다른거 누르면 잘못된 입력이라고 하기
      if (monster.health <= 0) {
        // 몬스터 처치 시
        monsters.remove(monster);
        defeatedMonsters++;
        defeatedMonsterNames.add(monster.name);
        print(
            '================================================================='
            '\n몬스터를 물리쳤습니다!🎉🎉🎉 총 처치한 몬스터 수: $defeatedMonsters');
        if (defeatedMonsters >= monsters.length) {
          print('\n✅✅✅게임 승리!✅✅✅');
          print('\n🎉 처치한 몬스터 목록:');
          for (var name in defeatedMonsterNames) {
            print('- $name');
          }

          saveResult();
          break;
        }
        while (true) {
          // 다음 몬스터와 대결할지 물어봄, y/n 외 잘못된 입력은 재요청
          stdout.write('\n[경고!]다음 몬스터와 대결하시겠습니까? (y/n): ');
          String? answer = stdin.readLineSync()?.toLowerCase();
          if (answer == 'y') {
            break;
          } else if (answer == 'n') {
            print('\n게임을 종료합니다.');
            return;
          } else {
            print('\n잘못된 입력입니다. [y] 또는 [n]을 입력해주세요.');
          }
        }

        saveResult();
      }
    }
  }

  bool battle(Monster monster) {
    // 몬스터와 전투 루프
    while (character.health > 0 && monster.health > 0) {
      monster.showAsciiArt(); // 도트 아트 출력
      character.showStatus(); // 캐릭터 상태 출력
      monster.showStatus(); // 몬스터 상태 출력
      monster.assignAttackPower(character.defense); // 매 턴 몬스터 공격력 재설정

      print('------------------------------------------------------');
      print('\n행동을 선택하세요: 공격하기(1), 방어하기(2), 아이템 사용(3)');
      stdout.write('입력: ');
      String? input = stdin.readLineSync();

      if (input == '1') {
        character.attack(monster);
      } else if (input == '2') {
        character.defend();
      } else if (input == '3') {
        character.useItem();
      } else {
        print('\n잘못된 입력입니다. 다시 선택해주세요.');
        continue;
      }
      if (monster.health <= 0) break; // 몬스터 사망 시 전투 종료

      monster.attack(character); // 몬스터 공격

      monster.increaseDefenseIfNeeded(); // 매 3턴마다 방어력 증가

      if (character.health <= 0) {
        print('\n캐릭터의 체력이 0이 되어 게임에서 패배했습니다.');
        break;
      }
    }
    return character.health > 0; // 캐릭터 생존 여부 반환
  }

  void saveResult() {
    // 게임 결과 저장 함수 (y/n)
    while (true) {
      stdout.write('\n결과를 저장하시겠습니까? (y/n): ');
      String? input = stdin.readLineSync()?.toLowerCase();

      if (input == 'y') {
        String result = '''
==============================
🎮 게임 결과 저장
==============================
[캐릭터명]: ${character.name}
남은 HP: ${character.health}
공격력 ATK: ${character.attackPower}
방어력 DEF: ${character.defense}
처치한 몬스터 수: $defeatedMonsters
최종 결과: ${character.health > 0 ? "✅ 승리" : "❌ 패배"}
==============================
''';
        try {
          File('data/result.txt').writeAsStringSync(result);
          print('\n결과가 result.txt 파일에 저장되었습니다.');
        } catch (e) {
          print('결과 저장 중 오류가 발생했습니다: $e');
        }
        break;
      } else if (input == 'n') {
        print('결과를 저장하지 않습니다.');
        break;
      } else {
        print('\n잘못된 입력입니다. [y] 또는 [n]을 입력해주세요.');
      }
    }
  }
}

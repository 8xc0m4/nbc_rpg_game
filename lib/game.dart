import 'dart:io';
import 'dart:math';
import 'character.dart';
import 'monster.dart';

abstract class Entity {
  String name;
  int health;
  int attackPower;
  int defense;

  Entity(this.name, this.health, this.attackPower, this.defense);

  void showStatus();

  void attack(Entity target);
}

class Game {
  Character character;
  List<Monster> monsters;
  int defeatedMonsters = 0;

  Game(this.character, this.monsters);

  Monster getRandomMonster() {
    final rand = Random();
    int idx = rand.nextInt(monsters.length);
    return monsters[idx];
  }

  void startGame() {
    print('===================\n'
        '⚔️===게임 시작===⚔️\n'
        '===================\n');

    while (character.health > 0 && defeatedMonsters < monsters.length) {
      Monster monster = getRandomMonster();
      monster.assignAttackPower(character.defense);
      print('======================\n'
          '[새로운 몬스터 등장‼️]\n'
          '======================\n');
      monster.sayIntro();
      monster.showStatus();

      bool continueBattle = battle(monster);

      if (!continueBattle) {
        print('\n게임을 종료합니다.[게임 오버]');
        break;
      }
//else if로 다른거 누르면 잘못된 입력이라고 하기
      if (monster.health <= 0) {
        monsters.remove(monster);
        defeatedMonsters++;
        print(
            '================================================================='
            '\n몬스터를 물리쳤습니다!🎉🎉🎉 총 처치한 몬스터 수: $defeatedMonsters');
        if (defeatedMonsters >= monsters.length) {
          print('\n✅✅✅게임 승리!✅✅✅');
          ('');
          break;
        }
        while (true) {
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
    while (character.health > 0 && monster.health > 0) {
      character.showStatus();
      monster.showStatus();

      print('\n행동을 선택하세요: 공격하기(1), 방어하기(2)');
      stdout.write('입력: ');
      String? input = stdin.readLineSync();

      if (input == '1') {
        character.attack(monster);
      } else if (input == '2') {
        character.defend(monster.attackPower);
      } else {
        print('\n잘못된 입력입니다. 다시 선택해주세요.');
        continue;
      }
      if (monster.health <= 0) break;

      monster.attack(character);

      if (character.health <= 0) {
        print('\n캐릭터의 체력이 0이 되어 게임에서 패배했습니다.');
        break;
      }
    }
    return character.health > 0;
  }

  void saveResult() {
    while (true) {
      stdout.write('\n결과를 저장하시겠습니까? (y/n): ');
      String? input = stdin.readLineSync()?.toLowerCase();

      if (input == 'y') {
        String result = '\n [${character.name}]'
            '\n남은 체력: ${character.health}'
            '\n게임 결과: ${character.health > 0 ? "승리" : "패배"}';

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

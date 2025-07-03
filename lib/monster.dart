import 'dart:math';
import 'character.dart';
import 'dart:io';

class Monster extends Entity {
  int maxAttackPower;
  String introMessage;
  int turnCounter = 0;

  String? asciiArt;

  Monster(String name, int health, this.maxAttackPower, this.introMessage)
      : super(name, health, 0, 0) {
    attackPower = maxAttackPower;
    defense = 0;
    loadAsciiArt();
  }

  void loadAsciiArt() {
    try {
      final path = 'data/monster_art/$name.txt'; // 파일 경로는 이름 기준
      asciiArt = File(path).readAsStringSync(); // 도트 텍스트 파일 읽기
    } catch (e) {
      asciiArt = '[도트 이미지 없음]'; // 에러 발생 시 기본 메시지
    }
  }

  void showAsciiArt() {
    if (asciiArt != null) {
      print(asciiArt);
    }
  }

  void increaseDefenseIfNeeded() {
    turnCounter++;
    if (turnCounter >= 3) {
      defense += 2;
      turnCounter = 0;
      print('$name의 DEP이 증가했습니다! 현재 DEP: $defense');
    }
  }

  void assignAttackPower(int characterDefense) {
    int minAttack = characterDefense;
    int maxAttack = maxAttackPower;
    var rand = Random();
    attackPower = (maxAttack <= minAttack)
        ? minAttack
        : minAttack + rand.nextInt(maxAttack - minAttack + 1);
  }

  void attackCharacter(Character character) {
    if (character.isDefending) {
      print('\n${character.name}이(가) 절대 방어로 공격을 무효화했습니다!');
      character.isDefending = false;
      return;
    }
    int damage = attackPower - character.defense;
    if (damage < 0) damage = 0;
    character.health -= damage;
    if (character.health < 0) character.health = 0;
    print('\n[$name]이(가) ${character.name}을(를) 공격했습니다. DMG: $damage'
        '\n남은 HP: ${character.health}');
  }

  @override
  void attack(Entity target) {
    if (target is Character) {
      attackCharacter(target);
    }
  }

  @override
  void showStatus() {
    print('\n[$name] HP: $health, ATK: $attackPower, DEF: $defense\n');
  }

  void sayIntro() {
    print('$name: "$introMessage"');
  }
}

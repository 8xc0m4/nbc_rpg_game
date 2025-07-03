import 'dart:math';
import 'character.dart';

class Monster extends Entity {
  int maxAttackPower;
  String introMessage;
  int turnCounter = 0;
  String? asciiArt;

  void showAsciiArt() {
    if (asciiArt != null) {
      print(asciiArt);
    }
  }

  Monster(String name, int health, this.maxAttackPower, this.introMessage)
      : super(name, health, 0, 0) {
    attackPower = maxAttackPower;
    defense = 0;
  }

  void increaseDefenseIfNeeded() {
    turnCounter++;
    if (turnCounter >= 3) {
      defense += 2;
      turnCounter = 0;
      print('$name의 방어력이 증가했습니다! 현재 방어력: $defense');
    }
  }

  void assignAttackPower(int characterDefense) {
    int minAttack = characterDefense;
    int maxAttack = maxAttackPower;
    var rand = Random();
    attackPower = maxAttack < minAttack
        ? minAttack
        : minAttack + rand.nextInt(maxAttack - minAttack + 1);
  }

  void attackCharacter(Character character) {
    int damage = attackPower - character.defense;
    if (damage < 0) damage = 0;
    character.health -= damage;
    if (character.health < 0) character.health = 0;
    print('\n[$name]이(가) ${character.name}을(를) 공격했습니다. 데미지: $damage'
        '\n남은 체력: ${character.health}');
  }

  @override
  void attack(Entity target) {
    if (target is Character) {
      attackCharacter(target);
    }
  }

  @override
  void showStatus() {
    print('\n[$name] 체력: $health, 공격력: $attackPower, 방어력: $defense\n');
  }

  void sayIntro() {
    print('$name: "$introMessage"');
  }
}

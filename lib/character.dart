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

class Character extends Entity {
  bool usedItem = false;
  bool itemActive = false;

  Character(String name, int health, int attack, int defense)
      : super(name, health, attack, defense);

  void useItem() {
    if (usedItem) {
      print('\n아이템은 이미 사용하였습니다.');
      return;
    }
    usedItem = true;
    itemActive = true;
    print('\n아이템을 사용했습니다! 이번 턴 공격력이 2배가 됩니다.');
  }

  @override
  void attack(Entity target) {
    int effectiveAttack = attackPower;
    if (itemActive) {
      effectiveAttack *= 2;
      itemActive = false; // 한 턴만 효과 지속
    }

    if (target is Monster) {
      target.health -= effectiveAttack;
      if (target.health < 0) target.health = 0;
      print('[$name]이(가) [${target.name}]을 공격했습니다. 공격력: $effectiveAttack');
      print('[${target.name}]의 남은 체력: ${target.health}');
    }
  }

  void attackMonster(Monster monster) {
    monster.health -= attackPower;
    if (monster.health < 0) monster.health = 0;
    print('[$name]이(가) \n [${monster.name}]을 공격했습니다.'
        '\n[${monster.name}]의 남은 체력: ${monster.health}');
  }

  @override
  void showStatus() {
    print('\n [$name] 체력: $health, 공격력: $attackPower, 방어력: $defense');
  }

  void defend(int attackPower) {}
}

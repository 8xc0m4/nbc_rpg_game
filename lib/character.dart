import 'monster.dart'; // 몬스터 관련 기능을 사용하기 위해 monster.dart 파일을 불러옴

abstract class Entity {
  // 모든 캐릭터(Entity)의 공통 특성을 정의하는 추상 클래스
  String name;
  int health;
  int attackPower;
  int defense;

  Entity(this.name, this.health, this.attackPower,
      this.defense); // 생성자: Entity를 만들 때 위 4가지 값을 반드시 설정하도록 강제함

  void showStatus(); // 캐릭터의 상태(HP, ATK 등)를 출력하는 메서드. 반드시 하위 클래스에서 구현해야 함.

  void attack(Entity target); // 공격을 수행하는 메서드. 하위 클래스에서 정의 필요
}

class Character extends Entity {
  // Entity를 상속받은 플레이어 캐릭터 클래스
  bool usedItem = false; // 아이템을 사용했는지 여부 (한 번만 사용 가능)
  bool itemActive = false; // 아이템 효과가 이번 턴에 활성화됐는지
  int maxHealth; // 최대 체력 저장용 (회복 시 기준)

  Character(String name, int health, int attack,
      int defense) // 생성자: 캐릭터가 생성될 때 체력은 maxHealth에도 저장됨
      : maxHealth = health,
        super(name, health, attack, defense); // Entity의 생성자 호출

  void useItem() {
    // 아이템을 사용할 때 호출되는 함수
    if (usedItem) {
      print('\n아이템은 이미 사용하였습니다.');
      return; // 이미 썼으면 종료
    }
    usedItem = true; // 아이템 사용 처리
    itemActive = true; // 다음 공격에 효과 적용됨
    print('\n아이템을 사용했습니다! 이번 턴 ATK이 2배가 됩니다.');
  }

  @override // Entity에서 정의한 공격 메서드를 오버라이드
  void attack(Entity target) {
    int effectiveAttack = attackPower;
    if (itemActive) {
      effectiveAttack *= 5; // 아이템 사용 중이면 5배 공격
      itemActive = false; // 한 턴만 효과 지속
    }

    if (target is Monster) {
      // 공격 대상이 Monster일 경우 체력 감소 처리
      target.health -= effectiveAttack;
      if (target.health < 0) target.health = 0;
      print('[$name]이(가) [${target.name}]을 공격했습니다. ATK: $effectiveAttack');
      print('[${target.name}]의 남은 HP: ${target.health}');
    }
  }

  void attackMonster(Monster monster) {
    //몬스터 공격 함수
    monster.health -= attackPower;
    if (monster.health < 0) monster.health = 0;
    print('[$name]이(가) \n [${monster.name}]을 공격했습니다.'
        '\n[${monster.name}]의 남은 HP: ${monster.health}');
  }

  @override // 현재 캐릭터 상태를 출력 (HP, ATK, DEP 표시)
  void showStatus() {
    print('\n [$name] HP: $health, ATK: $attackPower, DEP: $defense');
  }

  bool isDefending = false; // 방어 중인지 여부. 한 턴만 방어함.

  void defend() {
    // 방어 기능: 공격을 무효화하고 HP 회복
    isDefending = true;
    int healAmount = 10;
    health += healAmount;

    if (health > maxHealth) {
      health = maxHealth; // 회복 후 체력이 최대치 넘지 않도록 제한
    }

    print('$name이(가) 절대 방어 자세를 취했습니다! 이번 턴은 피해를 받지 않습니다.');
    print('💚 방어하면서 체력을 $healAmount 회복했습니다. 현재 체력: $health');
  }
}

pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "Interface.sol";

contract GameObject is InterfaceGameObject {

    struct militaryBS {
        string name;
        address addrMillitary;
    }

    uint myProtectionPower;
    uint myAttackPower;
    uint128 award = 1 Ton;
    address enemyAddr;
    military unit;
    militaryBS unitToBaseStation;
    militaryBS[] unitArr;
    address bs;

    /// Contract constructor.
    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }
    
    // Modifier that allows to accept some external messages
	modifier checkOwnerAndAccept {
	    // Check that message was signed with contracts key
		require(msg.pubkey() == tvm.pubkey(), 102, "You are not owner of token");
		tvm.accept();
		_;
	} 

    // Получить силу защиты
    function getProtectionPower(uint protectPower) public checkOwnerAndAccept {
        myProtectionPower = protectPower;
    }

    // Принять атаку
    function acceptAttack(uint attPower) external override {
        tvm.accept();
        enemyAddr = msg.sender;
        if (attPower > myProtectionPower) {
            unit.numberLives -= int(attPower - unit.protectionPower);
        }
        isKilled(unit.numberLives);
    }

    
    // Проверить, убит ли объект
    function isKilled(int numberLives) private {
        tvm.accept();
        if (unit.numberLives < 1) {
            processingDeath(unit, enemyAddr);
        }
    }

    // Обработка гибели (вызов метода самоуничтожения)
    function processingDeath(military, address enemyAddr) virtual public {
        tvm.accept();
        sendingMoneyAndDestroying(unit, enemyAddr, award);
    }

    // Самоуничтожение (отправка награды на адрес победителя и уничтожение своей единицы)
    function sendingMoneyAndDestroying(military, address enemyAddr, uint128 award) public {
        tvm.accept();
        if (unit.status == "Alive") {
            enemyAddr.transfer(award, true, 0);
            unit = military ("", 0, 0, 0, unit.addrMillitary, "Dead");
        }
    }

}

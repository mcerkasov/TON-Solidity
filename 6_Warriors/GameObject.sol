pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "Interface.sol";

contract GameObject is InterfaceGameObject {

    uint myProtectionPower;
    address enemyAddr;
    military unit;
    military[] unitArr;

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

    // получить силу защиты
    function getProtectionPower(uint protectPower) public checkOwnerAndAccept {
        myProtectionPower = protectPower;
    }

    // принять атаку [адрес того, кто атаковал можно получить из msg] external
    function acceptAttack(uint attPower) virtual external override {
        tvm.accept();
        enemyAddr = msg.sender;
        if (attPower > myProtectionPower) {
            unit.numberLives -= int(attPower - unit.protectionPower);
        }
        isKilled(unit.numberLives);
    }

    
    // проверить, убит ли объект (private)
    function isKilled(int numberLives) private {
        tvm.accept();
        if (unit.numberLives < 1) {
            processingDeath(unit, enemyAddr);
        }
    }

    // отправка всех денег по адресу и уничтожение
    function sendingMoneyAndDestroying(military, address enemyAddr) public {
        tvm.accept();
        enemyAddr.transfer(1 Ton, true, 0);
        unit = military ("", 0, 0, 0, unit.addrMillitary, "Dead");
    }

    // обработка гибели [вызов метода самоуничтожения]
    function processingDeath(military, address enemyAddr) virtual public {
        tvm.accept();
        sendingMoneyAndDestroying(unit, enemyAddr);
    }

}

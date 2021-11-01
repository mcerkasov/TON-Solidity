pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "Interface.sol";
import "GameObject.sol";


contract BaseStation is GameObject {

    /// Contract constructor.
    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    // Создание базы
    function createBaseStation() public checkOwnerAndAccept {
        uint myAttackPower = 0;   // cила атаки
        getProtectionPower(3);   // получить силу защиты
        int myNumberLives = 10;   // количество жизни
        unit = military ("BaseStation", myAttackPower, myProtectionPower, myNumberLives, address(this), "Alive"); 
    }

    //Добавить военный юнит (добавляет адрес военного юнита в массив)
    function addMilitaryToBaseStation(military unit) virtual public {
        tvm.accept();
        require (unitArr.length < 2, 110, "Can be only 2 units on base");
        unitArr.push(unit);
    }

    //Убрать военный юнит
    function removeMilitary(address addrMillitary) virtual public {
        tvm.accept();
        require (!unitArr.empty(), 111, "No units on base");
        if (unitArr.length > 1) {
            if (unitArr[0].addrMillitary == addrMillitary) {
                unitArr[0] = unitArr[1];
                unitArr.pop();
            }
            else if (unitArr[1].addrMillitary == addrMillitary) {
                unitArr.pop();
            }
        }
        else if (unitArr[0].addrMillitary == addrMillitary) {
            unitArr.pop();
        }
    }

    // обработка гибели [вызов метода смерти для каждого из военных юнитов базы + 
    // удаление уничтоженных юнитов из базы + уничтожение базовой станции]
    function processingDeath(military, address enemyAddr) public override {
        tvm.accept();
        for (uint i = 0;  i < unitArr.length; i++) {
            uint attPower = 100;
            address enemyAddr1 = unitArr[i].addrMillitary;
            InterfaceGameObject(enemyAddr1).acceptAttack(attPower);
        }
        delete unitArr;
        sendingMoneyAndDestroying(unit, enemyAddr);
    }

   function _unitArr() public view returns (military[]) {
        tvm.accept();
        return unitArr;
    }  

    function _characteristicBaseStation() public view returns(military){
        tvm.accept();
        return unit;
    }
}

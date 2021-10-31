
/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

// This is class that describes you smart contract.
import "Interface.sol";
import "GameObject.sol";

contract Military is GameObject {

    address addrMillitary;
    uint myAttackPower;
    int myNumberLives = 5;


    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    // Вызов метода "Базовой Станции" 
    // "Добавить военный юнит" и сохранить адрес "Базовой станции"
    function addMilitaryToBaseStation(InterfaceBaseStation BaseStation) public checkOwnerAndAccept {
        BaseStation.addMilitaryToBaseStation(unit);
    }

    // Атаковать (принимает ИИО [его адрес])
    function attack(InterfaceGameObject enemyAddr) public {
        tvm.accept();
        uint attPower = unit.attackPower;
        enemyAddr.acceptAttack(attPower);
    }

    // Получить силу атаки
    function getAttackPower(uint attPower) public checkOwnerAndAccept{
        myAttackPower = attPower;
    }

    // Обработка гибели [вызов метода самоуничтожения + убрать военный юнит из базовой станции]
    function destroyAndRemoveMilitary(InterfaceBaseStation BaseStation) public checkOwnerAndAccept {
        processingDeath(unit, BaseStation);
        BaseStation.removeMilitary(address(this));
    }
}
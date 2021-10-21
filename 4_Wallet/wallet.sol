pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

/// @title Simple wallet
/// @author Tonlabs
contract Wallet {
    /*
     Exception codes:
      100 - message sender is not a wallet owner.
      101 - invalid transfer value.
     */

    /// @dev Contract constructor.
    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    // Modifier that allows function to accept external call only if it was signed
    // with contract owner's public key.
    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
	}

    // Send without commission payment at own expense
    function sendWithOUTCommission(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, true, 0);
    }

    // Send with commission payment at own expense
    function sendWithCommission(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, true, 1);
    }

    // Send all money and destroy wallet
    function sendAllMoneyAndDestroyWallet(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, true, 160);
    }
}
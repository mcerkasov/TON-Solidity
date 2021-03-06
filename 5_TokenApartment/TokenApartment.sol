
/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

// This is class that describes you smart contract.
contract TokenApartment {
    // Contract can have an instance variables.

    struct Token {
        string nameApartment;
        string addr;
        uint numberFloors;
        uint quantityRooms;
    }

    struct Sale {
        uint tokenToOwner;
        bool forSale;
        uint price;
    }

    Token[] public TokensArr;
    mapping (uint => Sale) public saleApartment;


	// Creating token with unique name
	function creatToken(string nameApartment, string addr, uint numberFloors, uint quantityRooms) public {
		tvm.accept();
        if (!TokensArr.empty()) {
            for (Token tkn: TokensArr) {
                require(tkn.nameApartment != nameApartment, 123, "Apartment with that name already exists");
            }
        }
        TokensArr.push(Token(nameApartment, addr, numberFloors, quantityRooms));
        uint KeyAsLastNum = TokensArr.length;
        saleApartment[KeyAsLastNum] = Sale (msg.pubkey(), false, 0);
	}

    // Modifier that allows to accept some external messages
	modifier checkOwnerAndAccept(uint tokenId) {
		// Check that message was signed with contracts key
		require(msg.pubkey() == saleApartment[tokenId].tokenToOwner, 102, "You are not owner of token");
		tvm.accept();
		_;
	}

    // Putting token up for sale. Available only to token owner
	function putUpForSaleToken(uint tokenId, uint value) public checkOwnerAndAccept(tokenId) {
		saleApartment[tokenId].forSale = true;
        saleApartment[tokenId].price = value;
	}

    // Token owner change (for test)
	function changeOwner(uint tokenId) public checkOwnerAndAccept(tokenId) {
		saleApartment[tokenId].tokenToOwner = 1;
	}

}

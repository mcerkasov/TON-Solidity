pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

struct Purchase {
    uint32 id;
    string text;
    uint quantity;
    uint64 creationTime;
    bool paid;
    uint price;
}

struct Stat {
    uint numberNotPurchasedItems;
    uint numberPurchasedItems;
    uint totalPrice;
}

interface IMsig {
   function sendTransaction(address dest, uint128 value, bool bounce, uint8 flags, TvmCell payload  ) external;
}


abstract contract AShopping {
   constructor(uint256 pubkey) public {}
}

interface IShopping {
   function createPurchase(string text, uint quantity) external;
   function makePurchase(uint32 id, bool done, uint price) external;
   function deletePurchase(uint32 id) external;
   function getPurchases() external returns (Purchase[] purchases);
   function getStat() external returns (Stat);
}
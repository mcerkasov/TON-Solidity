pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "IShopping.sol";

contract ShoppingList {

    uint32 m_count;

    mapping(uint32 => Purchase) m_purchases;

    uint256 ownerPubkey;

    modifier onlyOwner() {
        require(msg.pubkey() == ownerPubkey, 101);
        _;
    }    

    constructor(uint256 pubkey) public {
        require(pubkey != 0, 123);
        tvm.accept();
        ownerPubkey = pubkey;
    }

    function createPurchase(string text, uint _quantity) public onlyOwner {
        tvm.accept();
        m_count++;
        m_purchases[m_count] = Purchase(m_count, text, _quantity, now, false, 0);
    }

    function makePurchase(uint32 id, bool done, uint _price) public onlyOwner {
        optional(Purchase) purchase = m_purchases.fetch(id);
        require(purchase.hasValue(), 102);
        tvm.accept();
        Purchase thisPurchase = purchase.get();
        thisPurchase.paid = done;
        thisPurchase.price = _price;
        m_purchases[id] = thisPurchase;
    }

    function deletePurchase(uint32 id) public onlyOwner {
        require(m_purchases.exists(id), 102);
        tvm.accept();
        delete m_purchases[id];
    }

    function getPurchases() public view returns (Purchase[] purchases) {
        string text;
        uint quantity;
        uint64 creationTime;
        bool paid;
        uint price;

        for((uint32 id, Purchase purchase) : m_purchases) {
            text = purchase.text;
            quantity = purchase.quantity;
            paid = purchase.paid;
            creationTime = purchase.creationTime;
            price = purchase.price;
            purchases.push(Purchase(id, text, quantity, creationTime, paid, price));
       }
    }

    function getStat() public view returns (Stat stat) {
        uint numberNotPurchasedItems;
        uint numberPurchasedItems;
        uint totalPrice;

        for((, Purchase purchase) : m_purchases) {
            if (purchase.paid) {
                    numberPurchasedItems += purchase.quantity;
                    totalPrice += purchase.price;
                } else {
                    numberNotPurchasedItems += purchase.quantity;
                }
        }
        stat = Stat(numberNotPurchasedItems, numberPurchasedItems, totalPrice);
    }
}


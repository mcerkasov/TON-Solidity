pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "IShopping.sol";
import "ShoppingDebot.sol";

contract ShoppingInStore is ShoppingDebot{

    function _menu() public override {
        string separator = '/n';
        Menu.select(
            format(
                "You have bought {} goods for the total amount of {}, it remains to buy {} goods",
                    m_stat.numberPurchasedItems,
                    m_stat.totalPrice,
                    m_stat.numberNotPurchasedItems
            ),
            separator,
            [
                MenuItem("Make purchase","",tvm.functionId(makePurchase)),
                MenuItem("Show shopping list","",tvm.functionId(showPurchases)),
                MenuItem("Remove purchase from list","",tvm.functionId(deletePurchase))
            ]
        );
    }

    function makePurchase(uint32 index) public {
        index = index;
        if (m_stat.numberNotPurchasedItems > 0) {
            Terminal.input(tvm.functionId(makePurchase_), "Enter the purchase number:", false);
        } else {
            if (m_stat.numberPurchasedItems > 0) {
                Terminal.print(0, "You bought everything from the list");
            } else {
                Terminal.print(0, "Sorry, your list is empty");
            }
            _menu();
        }
    }

    function makePurchase_(string value) public {
        (uint256 num, bool status) = stoi(value);
        if (status) {
            m_purchaseId = uint32(num);
            ConfirmInput.get(tvm.functionId(makePurchase__),"Are you ready to buy?");
        } else {          
            Terminal.input(tvm.functionId(makePurchase_), "Enter integer purchase number:", false);                      
        }    

    }

    function makePurchase__(bool value) public {
        buy = value;
        if (buy) {
            Terminal.input(tvm.functionId(makePurchase___), "Purchase price:", false);
        } else {
            _menu();
        }
    }

    function makePurchase___(string value) public {
        (uint256 _price, bool status) = stoi(value);
        if (status) {
            optional(uint256) pubkey = 0;
            IShopping(m_address).makePurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(m_purchaseId, buy, _price);
        } else {          
            Terminal.input(tvm.functionId(makePurchase___), "Please enter an integer purchase price:", false);                   
        }
    }

    function showPurchases(uint32 index) public view {
        index = index;
        optional(uint256) none;
        IShopping(m_address).getPurchases{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showPurchases_),
            onErrorId: 0
        }();
    }

    function showPurchases_(Purchase[] purchases) public {
        uint32 i;
        if (purchases.length > 0 ) {
            Terminal.print(0, "Your purchases list:");
            for (i = 0; i < purchases.length; i++) {
                Purchase purchase = purchases[i];
                string completed;
                if (purchase.paid) {
                    completed = '✓';
                    Terminal.print(0, format("{} {}  \"{}\"  quantity: {}, price: {}, at {}", purchase.id, completed, purchase.text, purchase.quantity, purchase.price, purchase.creationTime));
                } else {
                    completed = ' ';
                    Terminal.print(0, format("{} {}  \"{}\"  quantity: {}, at {}", purchase.id, completed, purchase.text, purchase.quantity, purchase.creationTime));
                }
            }
        } else {
            Terminal.print(0, "Your shopping list is empty");
        }
        _menu();
    }

    function deletePurchase(uint32 index) public {
        index = index;
        if (m_stat.numberPurchasedItems + m_stat.numberNotPurchasedItems > 0) {
            Terminal.input(tvm.functionId(deletePurchase_), "Enter purchase number:", false);
        } else {
            Terminal.print(0, "Sorry, your list is empty");
            _menu();
        }
    }

    function deletePurchase_(string value) public {
        (uint256 num, bool status) = stoi(value);
        if (status) {
            optional(uint256) pubkey = 0;
            IShopping(m_address).deletePurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
                }(uint32(num));
        } else {          
            Terminal.input(tvm.functionId(deletePurchase_), "Enter integer purchase number:", false);                     
        }
    }

}

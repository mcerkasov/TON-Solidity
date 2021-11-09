pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "../_base/Debot.sol";
import "../_base/Terminal.sol";
import "../_base/Menu.sol";
import "../_base/AddressInput.sol";
import "../_base/ConfirmInput.sol";
import "../_base/Upgradable.sol";
import "../_base/Sdk.sol";
import "IShopping.sol";

abstract contract ShoppingDebot is Debot {
    bytes m_icon;

    TvmCell m_shoppingCode; // contract code
    TvmCell m_shoppingData; // contract data
    TvmCell m_shoppingStateInit; // contract StateInit
    address m_address;      // contract address
    Stat m_stat;            // Statistics of incompleted and completed purchases
    uint32 m_purchaseId;    // Purchase id for update. I didn't find a way to make this var local
    string productName;     // Product Name
    bool buy;               // Product Purchase Key
    uint256 m_masterPubKey; // User pubkey
    address m_msigAddress;  // User wallet address

    uint32 INITIAL_BALANCE =  200000000;  // Initial contract balance

    function setShopingCode(TvmCell code,TvmCell data) public {
	require(msg.pubkey() == tvm.pubkey(), 101);
        tvm.accept();
        m_shoppingCode = code;
        m_shoppingData = data;
        m_shoppingStateInit = tvm.buildStateInit(m_shoppingCode, m_shoppingData);
    }

    function start() public override {
        Terminal.input(tvm.functionId(receivePublicKey),"Please enter your public key",false);
    }

    /// @notice Returns Metadata about DeBot.
    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "Shoping DeBot";
        version = "0.1.0";
        publisher = "Michael Cherkasov";
        key = "SHOP list manager";
        author = "TON Labs";
        support = address.makeAddrStd(0, 0x66e01d6df5a8d7677d9ab2daf7f258f1e2a7fe73da5320300395f99e01dc3b5f);
        hello = "Hi, i'm a Shoping DeBot.";
        language = "en";
        dabi = m_debotAbi.get();
        icon = m_icon;
    }

    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID, Menu.ID, AddressInput.ID, ConfirmInput.ID ];
    }

    function receivePublicKey(string value) public {
        (uint res, bool status) = stoi("0x"+value);
        if (status) {
            m_masterPubKey = res;

            Terminal.print(0, "Checking if you already have a shopping list ...");
            TvmCell deployState = tvm.insertPubkey(m_shoppingStateInit, m_masterPubKey);
            m_address = address.makeAddrStd(0, tvm.hash(deployState));
            Terminal.print(0, format( "Info: your contract address is {}", m_address));
            Sdk.getAccountType(tvm.functionId(checkStatus), m_address);

        } else {
            Terminal.input(tvm.functionId(receivePublicKey),"Wrong public key. Try again!\nPlease enter your public key",false);
        }
    }

    function checkStatus(int8 acc_type) public {
        if (acc_type == 1) { // acc is active and  contract is already deployed
            _getStat(tvm.functionId(setStat));

        } else if (acc_type == -1)  { // acc is inactive
            Terminal.print(0, "You don't have a shopping list yet, so a new contract with an initial balance of 0.2 tokens will be deployed");
            AddressInput.get(tvm.functionId(creditAccount),"Select a wallet for payment. You will need to sign two transactions");

        } else  if (acc_type == 0) { // acc is uninitialized
            Terminal.print(0, format(
                "Deployment of a new contract. If an error occurs, check whether there are enough tokens on the balance of your contract for execution"
            ));
            deploy();

        } else if (acc_type == 2) {  // acc is frozen
            Terminal.print(0, format("There is no way to continue: account {} is frozen", m_address));
        }
    }

    function _menu() virtual public  { 
        
    }

    function creditAccount(address value) public {
        m_msigAddress = value;
        optional(uint256) pubkey = 0;
        TvmCell empty;
        IMsig(m_msigAddress).sendTransaction{
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(waitingDeploy),
            onErrorId: tvm.functionId(onErrorRepeatCredit)  // Repeat if something went wrong
        }(m_address, INITIAL_BALANCE, false, 3, empty);
    }

    function deploy() private view {
        TvmCell image = tvm.insertPubkey(m_shoppingStateInit, m_masterPubKey);
        optional(uint256) none;
        TvmCell deployMsg = tvm.buildExtMsg({
            abiVer: 2,
            dest: m_address,
            callbackId: tvm.functionId(onSuccess),
            onErrorId:  tvm.functionId(onErrorRepeatDeploy),    // Repeat if something went wrong
            time: 0,
            expire: 0,
            sign: true,
            pubkey: none,
            stateInit: image,
            call: {AShopping, m_masterPubKey}
        });
        tvm.sendrawmsg(deployMsg, 1);
    }

    function onError(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
        _menu();
    }

    function onErrorRepeatDeploy(uint32 sdkError, uint32 exitCode) public view {
        sdkError;
        exitCode;
        deploy();
    }

    function onErrorRepeatCredit(uint32 sdkError, uint32 exitCode) public {
        sdkError;
        exitCode;
        creditAccount(m_msigAddress);
    }

    function onSuccess() public view {
        _getStat(tvm.functionId(setStat));
    }

    function waitingDeploy() public  {
        Sdk.getAccountType(tvm.functionId(checkStatusUnInit), m_address);
    }

    function checkStatusUnInit(int8 acc_type) public {
        if (acc_type ==  0) {
            deploy();
        } else {
            waitingDeploy();
        }
    }

    function setStat(Stat stat) public {
        m_stat = stat;
        uint32 i;
        _menu();
    }

    function _getStat(uint32 answerId) private view {
        optional(uint256) none;
        IShopping(m_address).getStat{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: answerId,
            onErrorId: 0
        }();
    }
}
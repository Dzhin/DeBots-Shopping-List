pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

//import "../Debot.sol";
import "../Terminal.sol";
//import "../Menu.sol";
//import "../AddressInput.sol";
//import "../ConfirmInput.sol";
//import "../Upgradable.sol";
import "../Sdk.sol";
import "PurchaseDeBotResourses.sol";

abstract contract InstalizeListDebot {
    
    TvmCell m_shoppingList;// ShopppingList contract code
    address m_address;  // ShopppingList contract address
    uint256 m_masterPubKey; // User pubkey


    function setShoppingListCode(TvmCell code) public {
        require(msg.pubkey() == tvm.pubkey(), 101);
        tvm.accept();
        m_shoppingList = code;
    }
    function savePublicKey(string value) public {
        (uint res, bool status) = stoi("0x"+value);
        if (status) {
            m_masterPubKey = res;

            Terminal.print(0, "Checking if you already have a Shopping List ...");
            TvmCell deployState = tvm.insertPubkey(m_shoppingList, m_masterPubKey);
            m_address = address.makeAddrStd(0, tvm.hash(deployState));
            Terminal.print(0, format( "Info: your ShoppingList contract address is {}", m_address));
            Sdk.getAccountType(tvm.functionId(checkStatus), m_address);

        } else {
            Terminal.input(tvm.functionId(savePublicKey),"Wrong public key. Try again!\nPlease enter your public key",false);
        }
    }
    function checkStatus(int8 acc_type) public {
        if (acc_type == 1) { // acc is active and  contract is already deployed
            _getStat(tvm.functionId(setStat));

        } else if (acc_type == -1)  { // acc is inactive
            Terminal.print(0, "You don't have a TODO list yet, so a new contract with an initial balance of 0.2 tokens will be deployed");
            AddressInput.get(tvm.functionId(creditAccount),"Select a wallet for payment. We will ask you to sign two transactions");

        } else  if (acc_type == 0) { // acc is uninitialized
            Terminal.print(0, format(
                "Deploying new contract. If an error occurs, check if your TODO contract has enough tokens on its balance"
            ));
            deploy();

        } else if (acc_type == 2) {  // acc is frozen
            Terminal.print(0, format("Can not continue: account {} is frozen", m_address));
        }
    }
    function setStat(SummaryPurchases summaryPurchases) public {
        m_stat = stat;
        _menu();
    }
}
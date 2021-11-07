pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;
import "PurchaseDeBotResourses.sol";
contract ShoppingList is ShoppingListInt {

    
    mapping(uint32 => Purchase) m_purchase;
    uint256 m_ownerPubkey;
    uint32 m_count;

    constructor( uint256 pubkey) public {
        require(pubkey != 0, 120);
        tvm.accept();
        m_ownerPubkey = pubkey;
    }

    modifier onlyOwner() {
        require(msg.pubkey() == m_ownerPubkey, 101);
        _;
    }

    struct Stat {//поменять
        uint32 completeCount;
        uint32 incompleteCount;
    }



    function addPurchase(string namePurchase, uint64 quantity) public onlyOwner {
        tvm.accept();
        m_count++;
        m_purchase[m_count] = Purchase(m_count, namePurchase, quantity, now, false, 0);
    }
    
    function deletePurchase(uint32 id) public onlyOwner {
        require(m_purchase.exists(id), 102);
        tvm.accept();
        delete m_purchase[id];
    }

    function buyPurchase(uint32 id, uint256 price ) public onlyOwner {
        optional(Purchase) purchase = m_purchase.fetch(id);
        require(purchase.hasValue(), 102);
        tvm.accept();
        Purchase thisPurchase = purchase.get();
        thisPurchase.bought = true;
        thisPurchase.price = price;
        m_purchase[id] = thisPurchase;
    }


    //
    // Get methods
    //

    function getPurchaseList() public view returns (Purchase[] purchases) {
        string name;
        uint64 quantity;
        uint32 timeAdd;
        bool bought;
        uint price;

        for((uint32 id, Purchase purchase) : m_purchase) {
            name = purchase.name;
            quantity = purchase.quantity;
            timeAdd = purchase.timeAdd;
            bought = purchase.bought;
            price = purchase.price;
            purchases.push(Purchase(id, name, quantity, timeAdd, bought, price));
       }
    }

    function getSummaryPurchases() public view returns (SummaryPurchases summaryPurchases) {
        uint64 paidPur;
        uint64 notPaidPur;
        uint totalAmountPaid; 

 
        for((, Purchase purchase) : m_purchase) {
            if  (purchase.bought) {
                paidPur ++;
                totalAmountPaid+=purchase.price;
            } else {
                notPaidPur ++;
            }
        }
        summaryPurchases = SummaryPurchases( paidPur, notPaidPur, totalAmountPaid );
    }
}


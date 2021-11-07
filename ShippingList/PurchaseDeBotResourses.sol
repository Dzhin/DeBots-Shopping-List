pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


struct Purchase{
    uint32 id;
    string name;
    uint64 quantity;
    uint32 timeAdd;
    bool bought;
    uint price;
}

struct SummaryPurchases{
    uint64 paidPur;//оплачено
    uint64 notPaidPur;//не оплачено
    uint totalAmountPaid;// на сколько оплачено 
}
interface ShoppingListInt{

}

interface Transactable{
    function sendTransaction() external;
}
abstract contract HasConstructorWithPubKey{
    
}
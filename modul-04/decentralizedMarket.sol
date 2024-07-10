// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract DecentralizedMarketplace {
    struct Item {
        uint id;
        string name;
        uint price;
        address payable seller;
        bool isSold;
    }

    uint private itemCount = 0;
    mapping(uint => Item) public items;
    mapping(address => uint[]) public ownership;
    mapping(string => bool) private nameUsed;
    mapping(uint => bool) private priceUsed;
    mapping(address => uint) public balances; 

    event ItemListed(uint indexed itemId, string name, uint price, address indexed seller);
    event ItemPurchased(uint indexed itemId, address indexed buyer);
    event WithdrawalMade(address indexed seller, uint amount);

    function listItem(string memory name, uint price) public {
        require(price > 0, "Price must be greater than zero");
        require(!nameUsed[name], "Item name already exists");
        require(!priceUsed[price], "Item price already exists");

        itemCount++;
        items[itemCount] = Item(itemCount, name, price, payable(msg.sender), false);
        nameUsed[name] = true;
        priceUsed[price] = true;

        emit ItemListed(itemCount, name, price, msg.sender);
    }

    function purchaseItem(uint itemId) public payable {
        Item storage item = items[itemId];
        require(msg.value == item.price, "Incorrect amount of Ether sent");
        require(!item.isSold, "Item already sold");

        item.isSold = true;
        ownership[msg.sender].push(itemId);
        balances[item.seller] += msg.value;

        emit ItemPurchased(itemId, msg.sender);
    }

    function withdraw() public {
        uint amount = balances[msg.sender];
        require(amount > 0, "No funds to withdraw");

        balances[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Failed to withdraw funds");

        emit WithdrawalMade(msg.sender, amount);
    }

    function getOwnedItems(address user) public view returns (uint[] memory) {
        return ownership[user];
    }
}

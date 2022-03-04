// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract NFTMarketplace is ReentrancyGuard {

    using Counters for Counters.Counter;

    Counters.Counter itemID;
    Counters.Counter soldItems;

    address payable owner;
    uint256 public listingPrice = 0.1 ether;

    struct NFTItem{
        uint256 itemID;
        uint256 tokenNFTID;
        uint256 price;
        address NFTContract;
        address payable owner;
        address payable seller;
        bool sold;
    }

    mapping(uint256 => NFTItem) public idToNFT;
    mapping(uint256 => bool) public isListed;

    constructor(){
        owner = payable(msg.sender);
    }

    function createItem(uint256 _tokenId, uint256 _price, address _NFTContract) public payable nonReentrant returns(uint256) {
        require(msg.value == listingPrice);
        require(isListed[_tokenId] == false);
        require(_price > 0);

        itemID.increment();
        uint256 newItemID = itemID.current();

        NFTItem storage newNFT = idToNFT[newItemID];

        newNFT.itemID = newItemID;
        newNFT.tokenNFTID = _tokenId;
        newNFT.NFTContract = _NFTContract;
        newNFT.owner = payable(address(0));
        newNFT.seller = payable(msg.sender);
        newNFT.price = _price;
        newNFT.sold = false;

        ERC721(_NFTContract).transferFrom(msg.sender, address(this), _tokenId);

        return _tokenId;
    }

    function BuyItem(uint256 _itemID, address _NFTContract) public payable nonReentrant returns(uint256){
        uint256 NFTprice = idToNFT[_itemID].price;
        uint256 NFTtokenID = idToNFT[_itemID].tokenNFTID;

        require(msg.value == NFTprice);

        idToNFT[_itemID].seller.transfer(msg.value);
        ERC721(_NFTContract).transferFrom(address(this), msg.sender, NFTtokenID);
        idToNFT[_itemID].owner = payable(msg.sender);
        idToNFT[_itemID].sold = true;

        payable(owner).transfer(listingPrice);
        soldItems.increment();

        return NFTtokenID;
    }

    function getMarketItems() external view returns(NFTItem[] memory){
        uint256 totalItems = itemID.current();
        uint256 unSoldItems = totalItems - soldItems.current();

        uint256 currentIndex = 0;

        NFTItem[] memory marketItems = new NFTItem[](unSoldItems);

        for (uint256 i = 0; i < totalItems; i++){
            if(idToNFT[i+1].owner == address(0)){
                uint256 currentItemId = idToNFT[i+1].itemID;
                NFTItem storage currentItem = idToNFT[currentItemId];
                marketItems[currentIndex] = currentItem;
                currentIndex+=1;
            }
        }

        return marketItems;
    }

    function getMyNFTItems() external view returns(NFTItem[] memory){
        uint256 totalItems = itemID.current();
        uint256 itemCount = 0;

        for(uint256 i = 0; i < totalItems; i++){
            if(idToNFT[i+1].owner == msg.sender){
                itemCount+=1;
            }
        }

        uint256 currentIndex = 0;
        NFTItem[] memory marketItems = new NFTItem[](itemCount);

        for (uint256 i = 0; i < totalItems; i++){
            if(idToNFT[i+1].owner == msg.sender){
                uint256 currentItemId = idToNFT[i+1].itemID;
                NFTItem storage currentItem = idToNFT[currentItemId];
                marketItems[currentIndex] = currentItem;
                currentIndex+=1;
            }
        }

        return marketItems;
    }

    function getMyNFTForSale() external view returns(NFTItem[] memory){
        uint256 totalItems = itemID.current();
        uint256 itemCount = 0;

        for(uint256 i = 0; i < totalItems; i++){
            if(idToNFT[i+1].seller == msg.sender){
                itemCount+=1;
            }
        }

        uint256 currentIndex = 0;
        NFTItem[] memory marketItems = new NFTItem[](itemCount);

        for (uint256 i = 0; i < totalItems; i++){
            if(idToNFT[i+1].seller == msg.sender){
                uint256 currentItemId = idToNFT[i+1].itemID;
                NFTItem storage currentItem = idToNFT[currentItemId];
                marketItems[currentIndex] = currentItem;
                currentIndex+=1;
            }
        }
        
        return marketItems;
    }
}

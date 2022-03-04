// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract NFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private tokenID;

    address marketAddress;

    constructor(string memory name_, string memory symbol_, address _marketAddress) ERC721(name_, symbol_) {
        _marketAddress = marketAddress;
    }

    function createNFTItem(string memory _TokenURI) public returns(uint256){
        tokenID.increment();
        uint256 newTokenID = tokenID.current();

        _safeMint(msg.sender, newTokenID);
        _setTokenURI(newTokenID, _TokenURI);
        setApprovalForAll(marketAddress, true);

        return newTokenID;
    }

}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";

contract GobFatherNFT is ERC721A
{
    // contract address is 0xd9145CCE52D386f254917e481eB44e9943F39138

    uint256 constant public TotalNFT = 10000;
    uint256 constant public MaxMintForEachPerson = 10;
    uint256 constant public CostOfEachNFT = 0.5 ether; // this is ether is not only for ethereum but it is compatible for all evm chains
    string constant public BaseURI = "ipfs://QmbSLY2hzrpS1vckpXDwUKGfDJyWpGz6AN7Wo16Gr8xZnV/";
    address immutable public owner ; // not constant because it can be changed in constructor so thats why it is immutable
    
    constructor () ERC721A("GobFather","GFT")
    {
          owner  = payable(msg.sender) ; // person who deploys is the msg.sender ie the owner of the contract 
    }

    function mint(uint256 amount) public payable
    {
        require(totalSupply() + amount <= TotalNFT , "Limit exceeded") ;
        require(balanceOf(msg.sender) + amount <= MaxMintForEachPerson,"Individual Limit exceeded");
        uint256 total_amount = CostOfEachNFT * amount;
        require(msg.value >= total_amount, "Insufficent Amount");
        _safeMint(msg.sender , amount);
    }

    function _baseURI() internal pure override returns(string memory)
    {
        return BaseURI;
    }

    function withdraw() public
    {
        uint256 amount = address(this).balance;
        (bool sent,) = payable(owner).call{value:amount}("");
        require(sent,"ether transfer failed");
    }


}

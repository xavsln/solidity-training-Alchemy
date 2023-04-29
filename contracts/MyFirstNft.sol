// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// This simple smart contract can be used for creating an NFT (non-fungible token) on the Ethereum blockchain. 
// It is based on code provided by the OpenZeppelin library, which provides a set of reusable, secure smart contracts for building decentralized applications.
// It inherits from two other contracts in the OpenZeppelin library: ERC721, which is an Ethereum token standard for non-fungible tokens, and Ownable, which provides a set of functions for managing ownership of the contract.

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyFirstNft is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("MyFirstNft", "MFNFT") {}

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }
}
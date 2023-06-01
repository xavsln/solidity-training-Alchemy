// The below Smart Contract shall make use of OpenZepplin to create a voting system based on NFT

// The admin of the Smart Contract can add some vote proposals

// NFT owners can vote for a proposal based on the number of NFT they own

// The admin can display anytime the winning proposal

// The user can see all the available proposals along with the associated index / number to enter in order to vote for it


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
// Extension of ERC721 to support voting and delegation as implemented by Votes, where each individual NFT counts as 1 vote unit.
import "@openzeppelin/contracts/token/ERC721/extensions/draft-ERC721Votes.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/utils/Strings.sol";


contract MyVotingToken is ERC721, Ownable, EIP712, ERC721Votes {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    struct Proposal {
        string description;
        uint voteCount;
    }

    // An array filled with Proposal type proposals
    Proposal[] public proposals;

    // Mapping that track whether an address already voted or not
    mapping (address => bool) public hasVoted;

    constructor() ERC721("MyVotingToken", "MVT") EIP712("MyVotingToken", "1") {}

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.
    function _afterTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Votes)
    {
        super._afterTokenTransfer(from, to, tokenId, batchSize);
    }


    // The admin of the Smart Contract can add some vote proposals
    // Only the admin can add some vote proposals
    function addProposal(string memory _description) public onlyOwner {
        // Create a new proposal based on the proposal description entered by admin
        Proposal memory newProposal = Proposal(_description, 0);

        proposals.push(newProposal);
    }


    // A function that lists the available proposals and associated index so that the voters know the index associated with the proposal they want to vote for
    function getProposals() public view returns (string[] memory) {
        string[] memory proposalDescriptions = new string[](proposals.length);

        for (uint256 i = 0; i < proposals.length; i++) {
            // Comnvert the uint to string in order to concatenate
            string memory indexString = Strings.toString(i);
            proposalDescriptions[i] = string(abi.encodePacked("(",indexString,")", " - ", proposals[i].description));
        } 
        return proposalDescriptions;
    }

    // NFT owners can vote for a proposal based on the number of NFT they own
    function voteForProposal(uint256 _proposalIndex) public {
        // Make sure the address did not vote already otherwise the transaction will revert
        require(!hasVoted[msg.sender], "Already voted, can vote only once");
        require(_proposalIndex < proposals.length, "Invalid proposal number, try again");

        // count the number of NFT owned by the user
        uint256 tokenCount = balanceOf(msg.sender);

        proposals[_proposalIndex].voteCount += tokenCount;
        hasVoted[msg.sender] = true;
    }

    // The admin can display anytime the winning proposal
    function winningProposal() public view returns (string memory) {
        uint256 maxVoteCount = 0;
        uint256 winningProposalIndex;

        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > maxVoteCount) {
                maxVoteCount = proposals[i].voteCount;
                winningProposalIndex = i;
            }          
        }
        return proposals[winningProposalIndex].description;
    }

}
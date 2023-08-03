// DAO.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DAO {
    address public owner;
    IERC20 public votingToken;

    struct Proposal {
        string description;
        uint256 votes;
        bool executed;
    }

    Proposal[] public proposals;

    constructor(address _votingToken) {
        owner = msg.sender;
        votingToken = IERC20(_votingToken);
    }

    function submitProposal(string memory _description) external {
        proposals.push(Proposal(_description, 0, false));
    }

    function vote(uint256 _proposalId) external {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(proposal.votes == 0, "You already voted for this proposal");
        
        uint256 votes = votingToken.balanceOf(msg.sender);
        proposal.votes = votes;
    }

    function executeProposal(uint256 _proposalId) external {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(proposal.votes > (votingToken.totalSupply() / 2), "Not enough votes");
        
        // Execute the proposal here (e.g., transfer funds or execute a specific action)
        proposal.executed = true;
    }
}

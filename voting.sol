//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

contract ProposalContract {
    struct Proposal {
        string description;
        uint256 approve;
        uint256 reject;
        uint256 pass;
        uint256 total_vote_to_end;
        bool current_state;
        bool is_active;
    }

    mapping(uint256 => Proposal) proposal_history;

    uint256 private counter;

    address owner;
    address[] private voted_addresses;

    constructor() {
        owner = msg.sender;
        voted_addresses.push(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier active() {
        require(proposal_history[counter].is_active == true, "The proposal is not active");
        _;
    }

    function create(string calldata _description, uint256 _total_vote_to_end) external onlyOwner {
        counter += 1;
        proposal_history[counter] = Proposal(_description, 0, 0, 0, _total_vote_to_end, false, true);
    }

    function setOwner(address new_owner) external onlyOwner {
        owner = new_owner;
    }

    function vote(uint8 choice) external {
        Proposal storage proposal = proposal_history[counter];
        uint256 total_vote = proposal.approve + proposal.reject + proposal.pass;

        if (choice == 1) {
            proposal.approve += 1;
            proposal.current_state = calculateCurrentState();
        } else if (choice == 2) {
            proposal.reject += 1;
            proposal.current_state = calculateCurrentState();
        } else if (choice == 0) {
            proposal.pass += 1;
            proposal.current_state = calculateCurrentState();
        }

        // Third part
        if ((proposal.total_vote_to_end - total_vote == 1) && (choice == 1 || choice == 2 || choice == 0)) {
            proposal.is_active = false;
        }
    }

    function calculateCurrentState() private view returns (bool) {
        Proposal storage proposal = proposal_history[counter];

        uint256 approve = proposal.approve;
        uint256 reject = proposal.reject;
        uint256 pass = proposal.pass;

        if (proposal.pass % 2 == 1) {
            pass += 1;
        }

        pass = pass / 2;

        if (approve > reject + pass) {
            return true;
        } else {
            return false;
        }
    }
}

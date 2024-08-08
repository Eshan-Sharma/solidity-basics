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

    function create(string calldata _description, uint256 _total_vote_to_end) external {
        counter += 1;
        proposal_history[counter] = Proposal(_description, 0, 0, 0, _total_vote_to_end, false, true);
    }
}

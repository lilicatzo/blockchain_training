// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract DecentralizedVotingSystem {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }
    
    mapping(uint => Candidate) public candidates;
    uint[] private candidateIds;
    mapping(address => bool) public hasVoted;

    uint public winningCandidateId;
    event NewCandidate(uint candidateId);
    event VoteCast(uint candidateId);
    event WinnerDeclared(uint winnerCandidateId);

    function addCandidate(string memory name) public {
        uint candidateId = candidateIds.length + 1;
        candidates[candidateId] = Candidate(candidateId, name, 0);
        candidateIds.push(candidateId);
        emit NewCandidate(candidateId);
    }

    function castVote(uint candidateId) public {
        require(!hasVoted[msg.sender], "Sender has already voted.");
        require(candidateId > 0 && candidateId <= candidateIds.length, "Invalid candidate ID.");

        candidates[candidateId].voteCount += 1;
        hasVoted[msg.sender] = true;
        emit VoteCast(candidateId);

        checkForWinner();
    }

    function checkForWinner() private {
        uint highestVoteCount = 0;
        for (uint i = 0; i < candidateIds.length; i++) {
            uint currentId = candidateIds[i];
            if (candidates[currentId].voteCount > highestVoteCount) {
                highestVoteCount = candidates[currentId].voteCount;
                winningCandidateId = currentId;
            }
        }
        emit WinnerDeclared(winningCandidateId);
    }

    function getTotalVotes(uint candidateId) public view returns (uint) {
        require(candidateId > 0 && candidateId <= candidateIds.length, "Invalid candidate ID.");
        return candidates[candidateId].voteCount;
    }
}

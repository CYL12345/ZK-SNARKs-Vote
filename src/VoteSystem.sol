// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./VoteVerifier.sol"; // snarkjs导出的verifier

contract VoteSystem is Groth16Verifier {
    mapping(bytes32 => bool) public voted;
    event VoteSubmitted(address voter, bytes32 commitment);

    function submitVote(
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint256[1] calldata _pubSignals
    ) public {
        require(verifyProof(_pA,_pB,_pC,_pubSignals), "Invalid proof");

        bytes32 commitment = bytes32(_pubSignals[0]);
        require(!voted[commitment], "Already voted");

        voted[commitment] = true;
        emit VoteSubmitted(msg.sender, commitment);
    }
}

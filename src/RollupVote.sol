// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./RollupsVoteVerifier.sol";

/// @title RollupVote - 承诺+批量 的投票计票合约
/// @notice 存储 coommitment MerKle Root + 链上只验证聚合 proof
contract RollupVote {
    RollupGrothGroth16Verifier public rollupsVerifier;
    //最新投票结果ROOT
    uint256 public currentRoot;

    event NewRoot(uint256 indexed newRoot);

    constructor(address _verifier){
        rollupsVerifier = RollupGrothGroth16Verifier(_verifier);
        currentRoot = 0;
    }

    /// @notice 提交聚合 proof 来更新投票结果
    function submitBatch(
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint256[2] calldata _pubSignals
    ) external {
        //验证证明
        require(
            rollupsVerifier.verifyProof(_pA, _pB, _pC, _pubSignals),
            "Invalid proof"
        );
        //检查 oldRoot是否匹配
        require(_pubSignals[0] == currentRoot,"Root mismatch");

        //更新新的投票root
        uint256 newRoot = _pubSignals[1];
        currentRoot = newRoot;
        emit NewRoot(newRoot);
    }
}
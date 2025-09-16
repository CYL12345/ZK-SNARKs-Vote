// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/VoteSystem.sol";
import "../src/VoteVerifier.sol";
import "../src/RollupVote.sol";
import "../src/RollupsVoteVerifier.sol";

contract VoteContractsTest is Test {
    // 单独验证
    Groth16Verifier voteVerifier;
    VoteSystem voteSystem;

    // 聚合验证
    RollupGrothGroth16Verifier rollupVerifier;
    RollupVote rollupVote;

    function setUp() public {
        // 部署单独验证合约
        voteVerifier = new Groth16Verifier();
        voteSystem = new VoteSystem();

        // 部署聚合验证合约
        rollupVerifier = new RollupGrothGroth16Verifier();
        rollupVote = new RollupVote(address(rollupVerifier));
    }

    // -------------------------------
    // 单个投票测试
    // -------------------------------
    function testSingleVote() public {
        uint[2] memory pA = [uint(0), uint(0)];
        uint[2][2] memory pB = [[uint(0), uint(0)], [uint(0), uint(0)]];
        uint[2] memory pC = [uint(0), uint(0)];
        uint[1] memory pubSignals = [uint(0x1234)]; // 示例 commitment, 第二个值可为 0

        voteSystem.submitVote(pA, pB, pC, pubSignals);

        // 检查 commitment 是否记录
        assertTrue(voteSystem.voted(bytes32(pubSignals[0])));
    }

    // -------------------------------
    // 聚合批量投票测试
    // -------------------------------
    function testRollupBatchVote() public {
        for (uint batch = 0; batch < 2; batch++) {
            uint256 oldRoot = rollupVote.currentRoot();
            uint256 newRoot = uint256(keccak256(abi.encodePacked(batch)));

            uint[2] memory pA = [uint(0), uint(0)];
            uint[2][2] memory pB = [[uint(0), uint(0)], [uint(0), uint(0)]];
            uint[2] memory pC = [uint(0), uint(0)];

            uint256[2] memory pubSignals = [oldRoot, newRoot];

            rollupVote.submitBatch(pA, pB, pC, pubSignals);

            // 检查 root 是否正确更新
            assertEq(rollupVote.currentRoot(), newRoot);
        }
    }
}

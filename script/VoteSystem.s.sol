// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;
// 引入 Foundry 标准库
import "forge-std/Script.sol";
import "../src/VoteSystem.sol";

contract VoteSystemScripts is Script{
    VoteSystem public voteSystem;
    function setup() public{}
    function run() public{
        //启动广播（后续操作后发送真实交易）
        vm.startBroadcast();
        voteSystem = new VoteSystem();
        vm.stopBroadcast();
    }
}
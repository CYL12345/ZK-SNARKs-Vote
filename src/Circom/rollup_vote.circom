pragma circom 2.2.2;

//聚合电路：验证多个commitment 和对应的vote
//确保 votes 合法(范围内)，并输出新的stateRoot(可以用Merkle root标识投票结果)


include "poseidon.circom";
include "comparators.circom";
include "vote.circom";

template RollupVote(N){
    //公共输入：所有用户commitment
    signal input commitments[N];
    //公共输入：旧的tallyRoot
    signal output oldRoot;
    //公共输入：新的tallyRoot
    signal output newRoot;
    
    //私有输入：每个用户的vote和salt
    signal input votes[N];
    signal input salts[N];
    
    //验证commitment = Poseidon(vote,salt)
    component voters[N];
    for(var i = 0; i<N; i++){
        voters[i] = VoteCircuit();
        voters[i].vote <== votes[i];
        voters[i].salt <== salts[i];

        //强制 commitment === commitments[i]
        voters[i].voteCommitment === commitments[i];
    }
    //简化 处理直接计算新的 Root = Poseidon(commitments 全部拼接)
    component rootHasher = Poseidon(N);
    for(var i=0;i<N;i++){
        rootHasher.inputs[i] <== commitments[i];
    }
    newRoot <== rootHasher.out;
}
component main = RollupVote(4); // 这里假设每次批量处理 4 个用户

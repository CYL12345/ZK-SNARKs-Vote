pragma circom 2.2.2;

include "poseidon.circom";
include "comparators.circom";

template VoteCircuit() {
    // 私密输入
    signal input vote;
    signal input salt;

    // 公共输入
    signal output voteCommitment;

    // 验证 vote 在范围内 (0,1,2)
    component less = LessThan(32);   // Circom2 写法：参数是 bit 长度
    less.in[0] <== vote;
    less.in[1] <== 3;
    less.out === 1;

    // 生成承诺
    component hasher = Poseidon(2);
    hasher.inputs[0] <== vote;
    hasher.inputs[1] <== salt;

     // 输出承诺
    voteCommitment <== hasher.out;
}

//component main = VoteCircuit();

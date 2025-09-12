const circomlibjs = require("circomlibjs");

async function main() {
    const poseidon = await circomlibjs.buildPoseidon();
    const vote = 1;
    const salt = 123456;

    const commitment = poseidon.F.toString(poseidon([vote, salt]));
    console.log("voteCommitment:", commitment);
}

main();

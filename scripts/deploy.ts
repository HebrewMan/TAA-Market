import { ethers } from "ethers";

async function main() {
  const str1 = '0x838B7E4cCdC39E635A9D2d542Ea4d466d3E1eA7f'.toLowerCase();
  // const str2 = '100';
  // const str3 = '100000000000000000000';
  // const str4 = '12580hisky';
  // const concatenatedString = str1 + str2 + str3 + str4;//10000000000000000000012580hiyy
  // const hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes('0xd9145CCE52D386f254917e481eB44e9943F3913810010000'));
  const hash = ethers.utils.solidityKeccak256(
    [ 'address', 'uint', 'uint','string' ], [ '0x9dcfd16150776eb7737d5bcc42bad7de48a4ff3a', '602', '219000000000000000000','12580hisky' ])
  console.log("Keccak256 hash of the concatenated string:", hash);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

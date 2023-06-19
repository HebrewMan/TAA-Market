
import { expect } from "chai";
import { ethers } from "ethers";

describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function keccak256Example() {
    const concatenatedString = "10000000000000000000012580hiyy";
    const hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(concatenatedString));
  
    console.log("Keccak256 hash of the concatenated string:", hash);
  }
  

 


});



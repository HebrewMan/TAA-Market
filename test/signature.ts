const main = async () => {
    require("dotenv").config();
    const { API_URL, PRIVATE_KEY } = process.env;
    const { ethers } = require("ethers");
    const { hashMessage } = require("@ethersproject/hash");
    const provider = new ethers.providers.AlchemyProvider("ropsten", API_URL);
  
    const message = "Let's verify the signature of this message!";
    const walletInst = new ethers.Wallet(PRIVATE_KEY, provider);
    const signMessage = walletInst.signMessage(message);
  
    const messageSigner = signMessage.then((value:any) => {
      const verifySigner = ethers.utils.recoverAddress(hashMessage(message),value);
      return verifySigner;
    });

    const messageSigner2 = signMessage.then((value:any) => {
        const verifySigner = ethers.utils.verifyMessage(message,value);
        return verifySigner;
    });
  
    try {
      console.log("Success! The message: " +message+" was signed with the signature: " +await signMessage);
      console.log("The signer was: " +await messageSigner);
      console.log('==========================')
      console.log("Success! The message: " +message+" was signed with the signature: " +await signMessage);
      console.log("The signer was: " +await messageSigner2);
    } catch (err) {
      console.log("Something went wrong while verifying your message signature: " + err);
    }
  };
  
  main();
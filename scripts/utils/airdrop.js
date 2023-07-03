const fs = require('fs');
function createArray(strings, amount) {
    const result = [];
  
    if (strings.length === 0 || amount === 0) {
      return result;
    }
  
    const repetitions = Math.floor(amount / strings.length);
    const remainder = amount % strings.length;
  
    for (let i = 0; i < repetitions; i++) {
      result.push(...strings);
    }
  
    if (remainder > 0) {
      result.push(...strings.slice(0, remainder));
    }
  
    return result.map(str => str.replace(/'/g, '"'));
  }
  

const addrs = [
    "0x502eb745df54e47eef433e5e28da21a47ade7b20",
    "0x4408c492c042e2b7f1ee54f54272b45317f31b3f",
    "0xbb1cde4ae95bbb3190804dc2143501c044243e34",
    "0xb9445bd3d626ac9df701af1e92e315544b88d275",
    "0x381d885aadeb9ef2a2fd2be408d3c5f441a360cc"
]
const result = createArray(addrs,200);
console.log(result);

const outputFilePath = __dirname+'/whiteList.txt';

// 将结果转换为字符串
const outputString = JSON.stringify(result);

// 将结果写入文件
fs.writeFile(outputFilePath, outputString, (err) => {
  if (err) {
    console.error('写入文件时发生错误:', err);
    return;
  }
  console.log('结果已成功保存到文件:', outputFilePath);
});
  
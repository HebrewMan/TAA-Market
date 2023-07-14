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
  "0x3Ed832cA26842564B6d8906f142eD3B58BFFc744",
  "0xf97eBEf97563C6971cBBAC64a75af5F85Fd0A0cb",
  "0x9f62168c20425aDB44F3dF1e51dc8c64ef1937dD",
  "0xFb82E513707399d7DBa8909702d99913D5ba022A",
  "0x612522a4325aDa8a06507C30a8b836A24C72d75f"
]
const result = createArray(addrs,100);
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
  
const fs = require('fs');

const file = __dirname + '\\' + 'data.txt'
const fileBody = fs.readFileSync(file, { encoding: 'utf8' });
console.log(fileBody.split('\n'));
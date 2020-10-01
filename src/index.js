const mainFs = require('fs');
const dir = __dirname;

// const files = [
//   "./lua/config/config.lua",
// ]

const walkSync = function(dir, filelist) {
  const files = mainFs.readdirSync(dir);
  filelist = filelist || [];
  files.forEach(file => {
    if (mainFs.statSync(dir + file).isDirectory()) {
      filelist = walkSync(dir + file + '/', filelist);
    } else {
      filelist.push(dir + file);
    }
  });
  return filelist;
};

// const write2 = () => {
//   //const namespaceFolder = dir + '/lua/';
//   //const files = walkSync(namespaceFolder);
//   let data = ''
//   for(file of files) {
//     const path = dir + file.slice(1)
//     const fileBody = mainFs.readFileSync(path, { encoding: 'utf8' });
//     data = fileBody.concat("\n" + data)
//   }
//   mainFs.writeFileSync(dir + '/bundle.lua', data)
// }



const write = () => {
  const namespaceFolder = dir + '/lua/';
  const files = walkSync(namespaceFolder);
  let data = ''
  for(file of files) {
    const fileBody = mainFs.readFileSync(file, { encoding: 'utf8' });
    data = data.concat("\n" + fileBody)
  }
  mainFs.writeFileSync(dir + '/bundle.lua', data)
}
write()
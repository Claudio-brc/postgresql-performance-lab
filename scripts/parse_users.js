const fs = require('fs');
const readline = require('readline');

const inputFile = './datasets/stackexchange/Users.xml';
const outputFile = './datasets/stackexchange/users.csv';

const output = fs.createWriteStream(outputFile);

output.write(
  'id,display_name,reputation,creation_date,views,up_votes,down_votes\n'
);

const rl = readline.createInterface({
  input: fs.createReadStream(inputFile),
  crlfDelay: Infinity
});

rl.on('line', (line) => {
  if (!line.includes('<row')) return;

  const getAttr = (attr) => {
    const match = line.match(new RegExp(`${attr}="(.*?)"`));
    return match ? match[1].replace(/"/g, '""') : '';
  };

  const row = [
    getAttr('Id'),
    `"${getAttr('DisplayName')}"`,
    getAttr('Reputation'),
    getAttr('CreationDate'),
    getAttr('Views'),
    getAttr('UpVotes'),
    getAttr('DownVotes')
  ];

  output.write(row.join(',') + '\n');
});

rl.on('close', () => {
  output.end();
  console.log('users.csv generado correctamente');
});
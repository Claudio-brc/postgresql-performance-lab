const fs = require('fs');
const readline = require('readline');

const inputFile = './datasets/stackexchange/Posts.xml';
const outputFile = './datasets/stackexchange/posts.csv';

const output = fs.createWriteStream(outputFile);

output.write(
  'id,post_type_id,creation_date,score,view_count,owner_user_id,title,tags,answer_count,comment_count,favorite_count\n'
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
    getAttr('PostTypeId'),
    getAttr('CreationDate'),
    getAttr('Score'),
    getAttr('ViewCount'),
    getAttr('OwnerUserId'),
    `"${getAttr('Title')}"`,
    `"${getAttr('Tags')}"`,
    getAttr('AnswerCount'),
    getAttr('CommentCount'),
    getAttr('FavoriteCount')
  ];

  output.write(row.join(',') + '\n');
});

rl.on('close', () => {
  output.end();
  console.log('posts.csv generado correctamente');
});
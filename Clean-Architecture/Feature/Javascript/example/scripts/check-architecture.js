import { readdir, readFile } from 'node:fs/promises';
import { join } from 'node:path';

async function walk(directory) {
  const entries = await readdir(directory, { withFileTypes: true });
  const nested = await Promise.all(entries.map(async (entry) => {
    const path = join(directory, entry.name);
    return entry.isDirectory() ? walk(path) : [path];
  }));
  return nested.flat();
}

const domainFiles = (await walk('src/features'))
  .filter((file) => file.includes('/domain/') && file.endsWith('.js'));
const forbidden = ['/data/', '/presentation/', 'express'];
const violations = [];

for (const file of domainFiles) {
  const source = await readFile(file, 'utf8');
  for (const token of forbidden) {
    if (source.includes(token)) violations.push(`${file} imports or references ${token}`);
  }
}

if (violations.length > 0) {
  console.error('Architecture boundary violations:');
  violations.forEach((v) => console.error(`- ${v}`));
  process.exit(1);
}

console.log(`Architecture check passed for ${domainFiles.length} domain files.`);

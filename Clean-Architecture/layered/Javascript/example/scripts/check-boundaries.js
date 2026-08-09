import { readdir, readFile } from "node:fs/promises";
import { join, relative } from "node:path";

const root = new URL("../src/", import.meta.url);
const forbidden = {
  domain: ["/application/", "/presentation/", "/infrastructure/", "/composition/"],
  application: ["/presentation/", "/infrastructure/", "/composition/"],
  infrastructure: ["/presentation/"],
  presentation: ["/infrastructure/"]
};

async function files(directoryUrl) {
  const entries = await readdir(directoryUrl, { withFileTypes: true });
  const result = [];
  for (const entry of entries) {
    const child = new URL(`${entry.name}${entry.isDirectory() ? "/" : ""}`, directoryUrl);
    if (entry.isDirectory()) result.push(...(await files(child)));
    if (entry.isFile() && entry.name.endsWith(".js")) result.push(child);
  }
  return result;
}

let violations = 0;
for (const fileUrl of await files(root)) {
  const path = fileUrl.pathname;
  const layer = Object.keys(forbidden).find((name) => path.includes(`/src/${name}/`));
  if (!layer) continue;
  const content = await readFile(fileUrl, "utf8");
  for (const marker of forbidden[layer]) {
    if (content.includes(marker)) {
      violations += 1;
      console.error(`Boundary violation in ${fileUrl.pathname}: imports ${marker}`);
    }
  }
}

if (violations > 0) {
  process.exitCode = 1;
} else {
  console.log("No dependency-boundary violations found.");
}

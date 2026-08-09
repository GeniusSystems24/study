import { createServer } from "node:http";
import { createContainer } from "./composition/createContainer.js";
import { createHttpHandler } from "./composition/createHttpHandler.js";

const port = Number(process.env.PORT ?? 3000);
const container = await createContainer();
const server = createServer(createHttpHandler(container));

server.listen(port, () => {
  console.log(`Layered Clean Architecture example listening on http://localhost:${port}`);
});

import { ApplicationError } from "../../application/errors/ApplicationError.js";

export async function readJsonBody(request, { maxBytes = 1_000_000 } = {}) {
  const chunks = [];
  let size = 0;

  for await (const chunk of request) {
    size += chunk.length;
    if (size > maxBytes) {
      throw new ApplicationError("PAYLOAD_TOO_LARGE", "Request body is too large.", 413);
    }
    chunks.push(chunk);
  }

  if (chunks.length === 0) {
    return {};
  }

  try {
    return JSON.parse(Buffer.concat(chunks).toString("utf8"));
  } catch {
    throw new ApplicationError("INVALID_JSON", "Request body must contain valid JSON.", 400);
  }
}

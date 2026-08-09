import { ApplicationError } from "../../application/errors/ApplicationError.js";
import { DomainError } from "../../domain/errors/DomainError.js";
import { sendJson } from "../http/sendJson.js";

export function handleError(error, response) {
  if (error instanceof ApplicationError) {
    sendJson(response, error.status, {
      error: { code: error.code, message: error.message, details: error.details }
    });
    return;
  }

  if (error instanceof DomainError) {
    sendJson(response, 422, {
      error: { code: error.code, message: error.message, details: error.details }
    });
    return;
  }

  console.error(error);
  sendJson(response, 500, {
    error: { code: "INTERNAL_ERROR", message: "An unexpected error occurred." }
  });
}

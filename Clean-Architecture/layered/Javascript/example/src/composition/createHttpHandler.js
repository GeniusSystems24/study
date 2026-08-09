import { Router } from "../presentation/http/Router.js";
import { sendJson } from "../presentation/http/sendJson.js";
import { handleError } from "../presentation/middleware/errorHandler.js";

export function createHttpHandler(container) {
  const router = new Router();
  router.register("POST", "/api/auth/login", container.controllers.authController.login);
  router.register("POST", "/api/orders", container.controllers.orderController.create);
  router.register("GET", "/api/orders/:id", container.controllers.orderController.getById);

  return async function httpHandler(request, response) {
    try {
      const url = new URL(request.url, "http://localhost");
      const match = router.match(request.method, url.pathname);
      if (!match) {
        sendJson(response, 404, {
          error: { code: "ROUTE_NOT_FOUND", message: "Route was not found." }
        });
        return;
      }
      await match.handler(request, response, match.params);
    } catch (error) {
      handleError(error, response);
    }
  };
}

import { LoginRequest } from "../../application/dto/LoginRequest.js";
import { readJsonBody } from "../http/readJsonBody.js";
import { sendJson } from "../http/sendJson.js";

export class AuthController {
  constructor({ loginUseCase }) {
    this.loginUseCase = loginUseCase;
  }

  login = async (request, response) => {
    const body = await readJsonBody(request);
    const result = await this.loginUseCase.execute(new LoginRequest(body));
    sendJson(response, 200, result.toJSON());
  };
}

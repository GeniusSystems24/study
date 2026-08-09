import { CreateOrderRequest } from "../../application/dto/CreateOrderRequest.js";
import { readJsonBody } from "../http/readJsonBody.js";
import { sendJson } from "../http/sendJson.js";

export class OrderController {
  constructor({ createOrderUseCase, getOrderUseCase }) {
    this.createOrderUseCase = createOrderUseCase;
    this.getOrderUseCase = getOrderUseCase;
  }

  create = async (request, response) => {
    const body = await readJsonBody(request);
    const result = await this.createOrderUseCase.execute(new CreateOrderRequest(body));
    sendJson(response, 201, result);
  };

  getById = async (_request, response, params) => {
    const result = await this.getOrderUseCase.execute({ id: params.id });
    sendJson(response, 200, result);
  };
}

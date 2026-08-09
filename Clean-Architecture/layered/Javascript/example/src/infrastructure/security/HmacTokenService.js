import { createHmac } from "node:crypto";
import { TokenService } from "../../application/ports/TokenService.js";

function base64Url(value) {
  return Buffer.from(JSON.stringify(value)).toString("base64url");
}

export class HmacTokenService extends TokenService {
  constructor({ secret, clock = () => Math.floor(Date.now() / 1000) }) {
    super();
    this.secret = secret;
    this.clock = clock;
  }

  async issue(claims) {
    const header = base64Url({ alg: "HS256", typ: "JWT" });
    const payload = base64Url({
      ...claims,
      iat: this.clock(),
      exp: this.clock() + 3600
    });
    const signature = createHmac("sha256", this.secret)
      .update(`${header}.${payload}`)
      .digest("base64url");
    return `${header}.${payload}.${signature}`;
  }
}

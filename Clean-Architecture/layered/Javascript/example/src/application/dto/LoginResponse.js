export class LoginResponse {
  constructor({ token, user }) {
    this.token = token;
    this.user = user;
    Object.freeze(this);
  }

  toJSON() {
    return { token: this.token, user: this.user };
  }
}

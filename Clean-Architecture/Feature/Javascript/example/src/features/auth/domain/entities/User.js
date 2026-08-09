export class User {
  constructor({ id, name, email }) {
    if (!id || !name || !email) {
      throw new TypeError('User requires id, name, and email');
    }
    this.id = id;
    this.name = name;
    this.email = email;
    Object.freeze(this);
  }
}

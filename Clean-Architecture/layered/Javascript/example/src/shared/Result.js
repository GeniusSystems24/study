export class Result {
  constructor(ok, value, error) {
    this.ok = ok;
    this.value = value;
    this.error = error;
    Object.freeze(this);
  }

  static success(value) {
    return new Result(true, value, null);
  }

  static failure(error) {
    return new Result(false, null, error);
  }

  map(mapper) {
    return this.ok ? Result.success(mapper(this.value)) : this;
  }
}

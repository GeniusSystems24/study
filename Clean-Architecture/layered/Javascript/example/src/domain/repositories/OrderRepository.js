export class OrderRepository {
  async nextIdentity() {
    throw new Error("OrderRepository.nextIdentity must be implemented.");
  }

  async save(_order) {
    throw new Error("OrderRepository.save must be implemented.");
  }

  async findById(_id) {
    throw new Error("OrderRepository.findById must be implemented.");
  }
}

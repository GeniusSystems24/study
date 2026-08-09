import { validateRequired } from '../../../../core/validation/validateRequired.js';

export class AuthController {
  constructor({ loginUser }) {
    this.loginUser = loginUser;
  }

  login = async (req, res) => {
    validateRequired(req.body, ['email', 'password']);
    const result = await this.loginUser.execute(req.body);
    res.status(200).json({ data: result });
  };
}

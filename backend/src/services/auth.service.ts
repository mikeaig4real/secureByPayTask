import jwt from 'jsonwebtoken';
import { User, IUser } from '../models/user.model';
import { Wallet } from '../models/wallet.model';
import { Shipment } from '../models/shipment.model';
import { createSeedShipments } from '../mock-data/seedShipments.data';
import { BadRequestError } from '../errors/badRequestError';
import { AuthError } from '../errors/authError';
import { NotFoundError } from '../errors/notFoundError';
import { RegisterInput, LoginInput } from '../schemas/auth.schema';
import { config } from '../config';
import { runInTransaction } from '../db/transaction';

export interface AuthResponseData {
  user: {
    id: string;
    firstName: string;
    lastName: string;
    email: string;
    phone: string;
  };
  token: string;
}

export class AuthService {
  private generateToken(user: IUser): string {
    return jwt.sign(
      {
        userId: user._id.toString(),
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
      },
      config.jwtSecret,
      { expiresIn: config.jwtExpiresIn as any }
    );
  }

  /**
   * Generates a unique tracking ID
   * Example: MAF-C0D1-234-291
   */
  makeTrackingId(userId: string | { toString(): string }, index: number = 0): string {
    return AuthService.generateTrackingId(userId, index);
  }

  static generateTrackingId(userId: string | { toString(): string }, index: number = 0): string {
    const userSegment = userId.toString().slice(-4).toUpperCase();
    return `MAF-${userSegment}-234-29${index + 1}`;
  }

  async register(input: RegisterInput): Promise<AuthResponseData> {
    const existingUser = await User.findOne({ email: input.email.toLowerCase() });
    if (existingUser) {
      throw new BadRequestError('An account with this email already exists');
    }

    const { user, token } = await runInTransaction(async (session) => {
      const newUser = new User({
        firstName: input.firstName,
        lastName: input.lastName,
        email: input.email.toLowerCase(),
        phone: input.phone,
        password: input.password,
      });

      await newUser.save(session ? { session } : undefined);

      await Wallet.create(
        [
          {
            userId: newUser._id,
            balance: config.wallet.initialBalance,
            currency: config.wallet.defaultCurrency,
          },
        ],
        { ...(session ? { session } : {}), ordered: true }
      );

      const userShipments = createSeedShipments({
        userId: newUser._id,
        sender: `${newUser.firstName} ${newUser.lastName}`,
        getTrackingId: (idx) => this.makeTrackingId(newUser._id, idx),
      });
      await Shipment.create(userShipments, { ...(session ? { session } : {}), ordered: true });

      const generatedToken = this.generateToken(newUser);
      return { user: newUser, token: generatedToken };
    });

    return {
      user: {
        id: user._id.toString(),
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        phone: user.phone,
      },
      token,
    };
  }

  async login(input: LoginInput): Promise<AuthResponseData> {
    const user = await User.findOne({ email: input.email.toLowerCase() }).select('+password');
    if (!user) {
      throw new AuthError('Invalid email or password');
    }

    const isMatch = await user.comparePassword(input.password);
    if (!isMatch) {
      throw new AuthError('Invalid email or password');
    }

    const token = this.generateToken(user);

    return {
      user: {
        id: user._id.toString(),
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        phone: user.phone,
      },
      token,
    };
  }

  async getProfile(userId: string) {
    const user = await User.findById(userId);
    if (!user) {
      throw new NotFoundError('User not found');
    }

    return {
      id: user._id.toString(),
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      phone: user.phone,
    };
  }
}

export const authService = new AuthService();

import mongoose, { Document, Schema } from 'mongoose';
import { config } from '../config';
import { SUPPORTED_CURRENCIES, SupportedCurrency } from '../schemas/currency.schema';

export interface IWallet extends Document {
  userId: mongoose.Types.ObjectId;
  balance: number;
  currency: SupportedCurrency;
  createdAt: Date;
  updatedAt: Date;
}

const WalletSchema = new Schema<IWallet>(
  {
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true, unique: true },
    balance: {
      type: Number,
      required: true,
      min: 0,
      default: () => config.wallet.initialBalance,
    },
    currency: {
      type: String,
      enum: SUPPORTED_CURRENCIES,
      required: true,
      default: () => config.wallet.defaultCurrency,
    },
  },
  {
    timestamps: true,
  }
);

export const Wallet = mongoose.model<IWallet>('Wallet', WalletSchema);

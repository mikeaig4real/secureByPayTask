import mongoose, { Document, Schema } from 'mongoose';

export type ShipmentStatus = 'In-Transit' | 'Delayed' | 'Delivered';

export interface IShipment extends Document {
  trackingId: string;
  sender: string;
  receiver: string;
  pickUp: string;
  deliveryTo: string;
  amount: number;
  currency: string;
  status: ShipmentStatus;
  processingTime: string;
  isPaid: boolean;
  userId?: mongoose.Types.ObjectId;
  createdAt: Date;
  updatedAt: Date;
}

const ShipmentSchema = new Schema<IShipment>(
  {
    trackingId: { type: String, required: true, unique: true, trim: true },
    sender: { type: String, required: true, trim: true },
    receiver: { type: String, required: true, trim: true },
    pickUp: { type: String, required: true, trim: true },
    deliveryTo: { type: String, required: true, trim: true },
    amount: { type: Number, required: true },
    currency: { type: String, default: 'NGN' },
    status: {
      type: String,
      enum: ['In-Transit', 'Delayed', 'Delivered'],
      default: 'In-Transit',
    },
    processingTime: { type: String, default: '10 hours' },
    isPaid: { type: Boolean, default: false },
    userId: { type: Schema.Types.ObjectId, ref: 'User' },
  },
  {
    timestamps: true,
  }
);

// Compound index supporting tenant-scoped reverse-chronological queries
ShipmentSchema.index({ userId: 1, createdAt: -1 });

export const Shipment = mongoose.model<IShipment>('Shipment', ShipmentSchema);

import { Types } from 'mongoose';
import { ShipmentStatus } from '../models/shipment.model';

export interface SeedShipmentItem {
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
  userId?: Types.ObjectId | string;
}

export interface SeedShipmentOverrides {
  userId?: Types.ObjectId | string;
  sender?: string;
  getTrackingId?: (index: number) => string;
}

/**
 * Generates seed shipments with optional overrides for tenant isolation.
 */
export function createSeedShipments(overrides: SeedShipmentOverrides = {}): SeedShipmentItem[] {
  const templates: Omit<SeedShipmentItem, 'userId'>[] = [
    {
      trackingId: 'MAF-100-234-291',
      sender: 'Bunmi Tanny',
      receiver: 'Mercy',
      pickUp: 'Lagos, Nigeria',
      deliveryTo: 'Oyo Nigeria',
      amount: 3000,
      currency: 'NGN',
      status: 'In-Transit',
      processingTime: '10 hours',
      isPaid: true,
    },
    {
      trackingId: 'MAF-100-234-292',
      sender: 'Bunmi Tanny',
      receiver: 'Mercy',
      pickUp: 'Lagos, Nigeria',
      deliveryTo: 'Oyo Nigeria',
      amount: 3000,
      currency: 'NGN',
      status: 'Delayed',
      processingTime: '10 hours',
      isPaid: false,
    },
    {
      trackingId: 'MAF-100-234-293',
      sender: 'Bunmi Tanny',
      receiver: 'Mercy',
      pickUp: 'Lagos, Nigeria',
      deliveryTo: 'Oyo Nigeria',
      amount: 3000,
      currency: 'NGN',
      status: 'In-Transit',
      processingTime: '10 hours',
      isPaid: false,
    },
  ];

  return templates.map((shipment, index) => ({
    ...shipment,
    ...(overrides.sender ? { sender: overrides.sender } : {}),
    ...(overrides.userId ? { userId: overrides.userId } : {}),
    ...(overrides.getTrackingId ? { trackingId: overrides.getTrackingId(index) } : {}),
  }));
}

export const mockSeedShipments = createSeedShipments();

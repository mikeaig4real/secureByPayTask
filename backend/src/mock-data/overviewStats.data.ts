export interface OverviewStatMetric {
  title: string;
  count: number;
  change: string;
  vsLastMonth: number;
  type: 'positive' | 'negative' | 'neutral';
}

export interface OverviewDashboardStats {
  totalShipment: OverviewStatMetric;
  totalExports: OverviewStatMetric;
  totalImport: OverviewStatMetric;
}

/**
 * Default overview statistics matching Figma logistics cards.
 */
export const mockOverviewStats: OverviewDashboardStats = {
  totalShipment: {
    title: 'Total Shipment',
    count: 34,
    change: '↑ 90%',
    vsLastMonth: 4,
    type: 'positive',
  },
  totalExports: {
    title: 'Total Exports',
    count: 34,
    change: '↑ 90%',
    vsLastMonth: 4,
    type: 'positive',
  },
  totalImport: {
    title: 'Total Import',
    count: 34,
    change: '↑ 90%',
    vsLastMonth: 4,
    type: 'positive',
  },
};

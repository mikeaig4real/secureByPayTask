import { GrowthPeriod } from '../schemas/dashboard.schema';

export interface GrowthChartSeries {
  period: GrowthPeriod;
  labels: string[];
  values: number[];
}

/**
 * Growth Chart spline metrics matching the Figma design specifications.
 * Available for Week, Month, and Year periods.
 */
export const mockGrowthChartData: Record<GrowthPeriod, GrowthChartSeries> = {
  Week: {
    period: 'Week',
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    values: [220, 310, 290, 450, 480, 520, 600],
  },
  Month: {
    period: 'Month',
    labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
    values: [300, 450, 420, 750],
  },
  Year: {
    period: 'Year',
    labels: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
    values: [260, 310, 290, 350, 320, 440, 330, 490, 460, 630, 210, 1000],
  },
};

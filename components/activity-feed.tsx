'use client';

import { useEffect, useState } from 'react';

interface Activity {
  id: number;
  text: string;
  amount: string;
}

const mockActivities = [
  { id: 1, text: 'Executed triangular arb', amount: '+0.0031 IOTA' },
  { id: 2, text: 'Flash loan repaid in same bundle', amount: '0 fees' },
  { id: 3, text: 'Stable pair arbitrage completed', amount: '+0.0047 IOTA' },
  { id: 4, text: 'Cross-chain bridge swap settled', amount: '+0.0089 IOTA' },
  { id: 5, text: 'RWA yield spread captured', amount: '+0.0052 IOTA' },
];

export default function ActivityFeed() {
  const [activities, setActivities] = useState<Activity[]>(mockActivities);

  useEffect(() => {
    const interval = setInterval(() => {
      const newActivity = {
        id: Math.random(),
        text: mockActivities[Math.floor(Math.random() * mockActivities.length)].text,
        amount: `+${(Math.random() * 0.01).toFixed(4)} IOTA`,
      };

      setActivities(prev => [newActivity, ...prev.slice(0, 4)]);
    }, 3000);

    return () => clearInterval(interval);
  }, []);

  return (
    <section className="relative py-20 px-4">
      <div className="max-w-2xl mx-auto">
        <h2 className="text-4xl font-bold mb-12 text-center">Live Activity</h2>

        <div className="space-y-3 max-h-96 overflow-y-auto">
          {activities.map((activity) => (
            <div
              key={activity.id}
              className="p-4 rounded-lg bg-card/50 border border-primary/20 backdrop-blur-sm hover:border-primary/50 transition-all duration-300 flex justify-between items-center"
            >
              <span className="text-foreground">{activity.text}</span>
              <span className="text-primary font-semibold font-mono text-sm whitespace-nowrap ml-4">
                {activity.amount}
              </span>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

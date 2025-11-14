import { Card } from '@/components/ui/card';

const strategies = [
  {
    name: 'Stable Arb',
    description: 'vUSD pools arbitrage',
    apy: '8-12%',
    risk: 'Low',
    riskColor: 'text-green-400',
  },
  {
    name: 'RWA Yield Arb',
    description: 'Treasuries vs stables',
    apy: '15-22%',
    risk: 'Medium',
    riskColor: 'text-yellow-400',
  },
  {
    name: 'Cross-chain Bridge Arb',
    description: 'Multi-chain opportunities',
    apy: '25%+',
    risk: 'High',
    riskColor: 'text-orange-400',
  },
];

export default function StrategyCards() {
  return (
    <section className="relative py-20 px-4">
      <div className="max-w-6xl mx-auto">
        <h2 className="text-4xl font-bold mb-12 text-center">Arbitrage Strategies</h2>

        <div className="grid md:grid-cols-3 gap-6">
          {strategies.map((strategy, i) => (
            <Card
              key={i}
              className="p-8 bg-card/50 border-primary/20 backdrop-blur-sm hover:border-primary/50 transition-all duration-300 glow-card cursor-pointer group"
            >
              <h3 className="text-xl font-bold mb-2 group-hover:text-primary transition-colors">
                {strategy.name}
              </h3>
              <p className="text-sm text-muted-foreground mb-6">{strategy.description}</p>

              <div className="space-y-4 mb-6 p-4 rounded-lg bg-primary/5 border border-primary/20">
                <div>
                  <p className="text-sm text-muted-foreground">Est. APY</p>
                  <p className="text-2xl font-bold text-primary">{strategy.apy}</p>
                </div>
                <div>
                  <p className="text-sm text-muted-foreground">Risk Level</p>
                  <p className={`font-semibold ${strategy.riskColor}`}>{strategy.risk}</p>
                </div>
              </div>

              <button className="w-full py-2 rounded-lg bg-primary/10 border border-primary/30 text-primary hover:bg-primary/20 transition-colors font-semibold">
                Select Strategy
              </button>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
}

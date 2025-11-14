interface StatCardProps {
  label: string;
  value: string;
}

export default function StatCard({ label, value }: StatCardProps) {
  return (
    <div className="px-4 py-6 rounded-lg bg-card/50 border border-primary/20 backdrop-blur-sm hover:border-primary/50 transition-all duration-300 glow-card">
      <p className="text-sm text-muted-foreground mb-2">{label}</p>
      <p className="text-2xl font-bold text-primary">{value}</p>
    </div>
  );
}

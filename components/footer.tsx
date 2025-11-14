export default function Footer() {
  return (
    <footer className="relative py-12 px-4 border-t border-primary/10 bg-card/30 backdrop-blur-sm">
      <div className="max-w-6xl mx-auto">
        <div className="flex flex-col md:flex-row justify-between items-center gap-6">
          <div className="text-center md:text-left">
            <p className="text-foreground font-semibold mb-1">TangleArb</p>
            <p className="text-sm text-muted-foreground">Built for Moveathon Europe 2025</p>
          </div>

          <div className="text-center">
            <p className="text-sm text-muted-foreground">
              Track: <span className="text-primary font-semibold">DeFi</span>
            </p>
          </div>

          <div className="flex gap-6 text-sm">
            <a href="#" className="text-muted-foreground hover:text-primary transition-colors">
              Docs
            </a>
            <a href="#" className="text-muted-foreground hover:text-primary transition-colors">
              GitHub
            </a>
            <a href="#" className="text-muted-foreground hover:text-primary transition-colors">
              Twitter
            </a>
          </div>
        </div>

        <div className="mt-8 pt-6 border-t border-primary/10 text-center text-xs text-muted-foreground">
          <p>Zero gas. Infinite frequency. 100% on-chain profits.</p>
        </div>
      </div>
    </footer>
  );
}

'use client';

import { useState, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import StatCard from './stat-card';

interface HeroProps {
  isConnected: boolean;
  onConnect: (address: string, balance: string) => void;
  address: string;
  balance: string;
}

export default function Hero({ isConnected, onConnect, address, balance }: HeroProps) {
  const [tvl, setTvl] = useState('2,847,592');
  const [volume, setVolume] = useState('15,238,945');
  const [bots, setBots] = useState('1,247');
  const [apy, setApy] = useState('18.5');

  // Simulate live stat updates
  useEffect(() => {
    const interval = setInterval(() => {
      setTvl(prev => (parseInt(prev.replace(/,/g, '')) + Math.floor(Math.random() * 5000)).toLocaleString());
      setVolume(prev => (parseInt(prev.replace(/,/g, '')) + Math.floor(Math.random() * 8000)).toLocaleString());
      setBots(prev => (parseInt(prev) + Math.floor(Math.random() * 5)).toString());
      setApy(prev => (parseFloat(prev) + (Math.random() - 0.5) * 0.2).toFixed(1));
    }, 5000);

    return () => clearInterval(interval);
  }, []);

  const handleConnect = async () => {
    try {
      // 1. Wallet Standard (generic IOTA extension, window.iota)
      if (typeof window !== 'undefined' && (window as any).iota && typeof (window as any).iota.request === 'function') {
        try {
          // This is a proposed Wallet Standard; check latest for extensions
          const result = await (window as any).iota.request({ method: 'iota_connect' });
          const address = result.addresses?.[0] || result.address || '';
          const balance = result.balance || '0';
          if (address) {
            onConnect(address, balance.toString());
            return;
          }
        } catch (e) {
          alert('IOTA Wallet Standard extension detected, but connection failed: ' + e);
          return;
        }
      }
      // 2. Firefly extension (window.firefly)
      if ((window as any).firefly && typeof (window as any).firefly.connect === 'function') {
        try {
          // Firefly web extension connect signature may differ, see actual docs for latest
          const response = await (window as any).firefly.connect();
          // Example: response = { addresses: ["..."], ... } or similar
          const address = response.addresses?.[0] || response.address || '';
          const balance = response.balance || '0';
          if (address) {
            onConnect(address, balance.toString());
            return;
          }
        } catch (e) {
          alert('Firefly extension detected but connection failed: ' + e);
          return;
        }
      }
      // 3. Fallback: Prompt for mnemonic as before
      alert('IOTA wallet extension (Wallet Standard or Firefly) not detected! For best security and usability, install an IOTA wallet browser extension. Falling back to manual mnemonic input.');
      let mnemonic = window.prompt('Enter your 12- or 24-word IOTA mnemonic');
      if (!mnemonic) {
        alert('Mnemonic is required');
        return;
      }
      const { Client, Wallet } = await import('@iota/sdk');
      const client = new Client({ nodes: ['https://api.testnet.iota.org'] });
      const wallet = new Wallet({ client, mnemonic });
      const account = await wallet.getAccount('TangleArb');
      const addresses = await account.addresses();
      const balance = await account.getBalance();
      onConnect(addresses[0].address, balance.baseCoin.total.toString());
    } catch (error) {
      alert('Failed to connect wallet: ' + error);
      console.error('Failed to connect wallet:', error);
    }
  };

  return (
    <section className="relative min-h-screen flex flex-col items-center justify-center px-4 py-20 text-center">
      {/* Background glow effects */}
      <div className="absolute top-20 left-1/4 w-96 h-96 bg-primary/20 rounded-full blur-3xl opacity-20"></div>
      <div className="absolute bottom-20 right-1/4 w-96 h-96 bg-primary/20 rounded-full blur-3xl opacity-20"></div>

      <div className="relative z-20 max-w-4xl mx-auto">
        <div className="mb-6 inline-block">
          <div className="px-4 py-2 rounded-full bg-primary/10 border border-primary/50 text-primary text-sm font-mono">
            {'> MOVEVM • IOTA • FEELESS'}
          </div>
        </div>

        <h1 className="text-5xl md:text-7xl font-bold mb-6 text-balance leading-tight">
          TangleArb
          <br />
          <span className="text-primary">Feeless Arbitrage Vault</span>
        </h1>

        <p className="text-xl md:text-2xl text-muted-foreground mb-8 text-balance">
          Zero gas. Infinite frequency. 100% on-chain profits.
        </p>

        {/* Live Stats */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-12">
          <StatCard label="Total TVL" value={`$${tvl}`} />
          <StatCard label="24h Volume" value={`$${volume}`} />
          <StatCard label="Active Bots" value={bots} />
          <StatCard label="Current APY" value={`${apy}%`} />
        </div>

        {/* Connect Wallet Button */}
        {!isConnected ? (
          <Button
            onClick={handleConnect}
            className="px-8 py-6 text-lg font-semibold bg-primary hover:bg-primary/90 text-primary-foreground rounded-lg transition-all duration-300 hover:shadow-2xl hover:shadow-primary/50 glow-card"
          >
            Connect Wallet (Firefly / Mnemonic)
          </Button>
        ) : (
          <div className="inline-block">
            <div className="px-6 py-3 rounded-lg bg-card border border-primary/30 text-primary font-mono text-sm">
              Connected: {address.slice(0, 6)}...{address.slice(-4)} • {balance} IOTA
            </div>
          </div>
        )}
      </div>
    </section>
  );
}

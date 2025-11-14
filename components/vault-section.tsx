'use client';

import { useState, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

export default function VaultSection() {
  const [depositAmount, setDepositAmount] = useState('10');
  const [vaultBalance, setVaultBalance] = useState('45.23');
  const [profits, setProfits] = useState('0.00');
  const [ops, setOps] = useState('1247');

  // Simulate profit counter
  useEffect(() => {
    const interval = setInterval(() => {
      setProfits(prev => (parseFloat(prev) + Math.random() * 0.05).toFixed(2));
      setOps(prev => (parseInt(prev) + Math.floor(Math.random() * 100)).toString());
    }, 2000);
    return () => clearInterval(interval);
  }, []);

  const handleDeposit = () => {
    setVaultBalance(prev => (parseFloat(prev) + parseFloat(depositAmount)).toFixed(2));
    setDepositAmount('10');
  };

  return (
    <section className="relative py-20 px-4">
      <div className="max-w-4xl mx-auto">
        <h2 className="text-4xl font-bold mb-12 text-center">Your Vault</h2>

        <div className="grid md:grid-cols-2 gap-6">
          {/* Deposit Card */}
          <div className="p-8 rounded-xl bg-card/50 border border-primary/20 backdrop-blur-sm glow-card">
            <h3 className="text-lg font-semibold mb-6 text-primary">Deposit IOTA</h3>
            
            <div className="space-y-4">
              <div>
                <label className="block text-sm text-muted-foreground mb-2">Amount</label>
                <div className="flex gap-2">
                  <Input
                    type="number"
                    value={depositAmount}
                    onChange={(e) => setDepositAmount(e.target.value)}
                    placeholder="Enter amount"
                    className="bg-input/50 border-primary/20 text-foreground placeholder:text-muted-foreground focus:border-primary/50"
                  />
                  <Button
                    onClick={handleDeposit}
                    className="px-6 bg-primary hover:bg-primary/90 text-primary-foreground"
                  >
                    Deposit
                  </Button>
                </div>
              </div>

              <div className="p-4 rounded-lg bg-primary/5 border border-primary/20">
                <p className="text-sm text-muted-foreground">Min deposit</p>
                <p className="text-xl font-semibold text-primary">10 IOTA</p>
              </div>
            </div>
          </div>

          {/* Stats Card */}
          <div className="space-y-4">
            <div className="p-6 rounded-xl bg-card/50 border border-primary/20 backdrop-blur-sm glow-card">
              <p className="text-sm text-muted-foreground mb-2">Vault Balance</p>
              <p className="text-3xl font-bold text-primary">{vaultBalance} IOTA</p>
            </div>

            <div className="p-6 rounded-xl bg-card/50 border border-primary/20 backdrop-blur-sm glow-card">
              <p className="text-sm text-muted-foreground mb-2">Total Profits Earned</p>
              <p className="text-3xl font-bold text-primary">+{profits} IOTA</p>
            </div>

            <div className="p-6 rounded-xl bg-card/50 border border-primary/20 backdrop-blur-sm glow-card">
              <p className="text-sm text-muted-foreground mb-2">Arb Bot Status</p>
              <p className="text-xl font-semibold text-primary">Running – {ops} ops/sec</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

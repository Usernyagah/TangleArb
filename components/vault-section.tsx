'use client';

import { useEffect, useState } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Client, Wallet } from '@iota/sdk';

export default function VaultSection({ accountMnemonic, accountAddress }) {
  const [depositAmount, setDepositAmount] = useState('10');
  const [vaultObjId, setVaultObjId] = useState('');
  const [vaultBalance, setVaultBalance] = useState('0');
  const [profits, setProfits] = useState('0');
  const [deposits, setDeposits] = useState('0');
  const [withdrawals, setWithdrawals] = useState('0');
  const [ops, setOps] = useState('0');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    if (!accountMnemonic || !accountAddress) return;
    (async () => {
      setLoading(true);
      setError('');
      try {
        const client = new Client({ nodes: ['https://api.testnet.iota.org'] });
        const wallet = new Wallet({ client, mnemonic: accountMnemonic });
        const account = await wallet.getAccount('TangleArb');
        // Fetch or create vault. This will need object ID persistence in your system!
        let vaultId = window.localStorage.getItem(`vault:${accountAddress}`);
        if (!vaultId) {
          // Try to create the vault
          // The actual call to Move function in IOTA SDK may require client.callContractFunction, pseudocode below:
          // const tx = await client.callContractFunction(...initialize_vault...)
          // Get the created objectId from the tx result
          // For now, prompt user to input or assume the vault exists or fail gracefully.
          vaultId = window.prompt('Enter your Vault Object ID if you have one, or leave blank to fetch default (dev/test only):') || '';
        }
        setVaultObjId(vaultId);
        if (vaultId) {
          // Fetch stats - pseudocode for Move query using SDK:
          // Example:
          // const stats = await client.queryMoveFunction({
          //   packageId: ...,
          //   module: "vault",
          //   function: "get_stats",
          //   args: [vaultId],
          // })
          // setVaultBalance(stats[0]); setProfits(stats[1]); ...
          // For now, fallback to 0 until Move query SDK is confirmed.
        }
      } catch (err) {
        setError(String(err));
      }
      setLoading(false);
    })();
  }, [accountMnemonic, accountAddress]);

  const handleDeposit = () => {
    // TODO: Implement on-chain deposit logic, calling Move contract via IOTA SDK. For now leave stubbed.
    setError('On-chain deposit not yet implemented in this demo.');
  };

  return (
    <section className="relative py-20 px-4">
      <div className="max-w-4xl mx-auto">
        <h2 className="text-4xl font-bold mb-12 text-center">Your Vault</h2>
        {error && <div className="mb-4 text-red-500">{error}</div>}
        {loading ? <div>Loading vault data...</div> : (
          <div className="grid md:grid-cols-2 gap-6">
            {/* Deposit Card */}
            <div className="p-8 rounded-xl bg-card/50 border border-primary/20 backdrop-blur-sm glow-card">
              <h3 className="text-lg font-semibold mb-6 text-primary">Deposit IOTA</h3>
              <div className="space-y-4">
                <div>
                  <label className="block text-sm text-muted-foreground mb-2">Amount</label>
                  <div className="flex gap-2">
                    <Input type="number" value={depositAmount} onChange={e => setDepositAmount(e.target.value)} placeholder="Enter amount" className="bg-input/50 border-primary/20 text-foreground placeholder:text-muted-foreground focus:border-primary/50" />
                    <Button onClick={handleDeposit} className="px-6 bg-primary hover:bg-primary/90 text-primary-foreground">Deposit</Button>
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
                <p className="text-sm text-muted-foreground mb-2">Vault Deposits</p>
                <p className="text-xl font-semibold text-primary">{deposits} IOTA</p>
              </div>
              <div className="p-6 rounded-xl bg-card/50 border border-primary/20 backdrop-blur-sm glow-card">
                <p className="text-sm text-muted-foreground mb-2">Vault Withdrawals</p>
                <p className="text-xl font-semibold text-primary">{withdrawals} IOTA</p>
              </div>
            </div>
          </div>
        )}
      </div>
    </section>
  );
}

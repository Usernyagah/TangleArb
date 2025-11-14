'use client';

import { useState, useEffect } from 'react';
import Hero from '@/components/hero';
import VaultSection from '@/components/vault-section';
import StrategyCards from '@/components/strategy-cards';
import ActivityFeed from '@/components/activity-feed';
import Footer from '@/components/footer';
import ParticleBackground from '@/components/particle-background';

export default function Home() {
  const [isConnected, setIsConnected] = useState(false);
  const [address, setAddress] = useState('');
  const [balance, setBalance] = useState('0');

  const handleConnect = (connectedAddress: string, connectedBalance: string) => {
    setIsConnected(true);
    setAddress(connectedAddress);
    setBalance(connectedBalance);
  };

  return (
    <main className="relative min-h-screen bg-background overflow-hidden">
      <ParticleBackground />
      
      <div className="relative z-10">
        <Hero 
          isConnected={isConnected} 
          onConnect={handleConnect}
          address={address}
          balance={balance}
        />

        {isConnected && (
          <>
            <VaultSection />
            <StrategyCards />
            <ActivityFeed />
          </>
        )}

        <Footer />
      </div>
    </main>
  );
}

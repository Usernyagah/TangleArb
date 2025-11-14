'use client';

import { useEffect } from 'react';

export default function ParticleBackground() {
  useEffect(() => {
    const container = document.body;
    const particleCount = 30;

    for (let i = 0; i < particleCount; i++) {
      const particle = document.createElement('div');
      particle.className = 'particle';
      particle.style.left = Math.random() * window.innerWidth + 'px';
      particle.style.top = window.innerHeight + 'px';
      particle.style.width = Math.random() * 2 + 1 + 'px';
      particle.style.height = particle.style.width;
      particle.style.backgroundColor = Math.random() > 0.5 
        ? 'rgb(0, 255, 186)' 
        : 'rgb(100, 200, 255)';
      particle.style.borderRadius = '50%';
      particle.style.animationDelay = Math.random() * 10 + 's';
      particle.style.animationDuration = (15 + Math.random() * 10) + 's';

      container.appendChild(particle);
    }
  }, []);

  return null;
}

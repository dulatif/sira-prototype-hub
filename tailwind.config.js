/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#11d4c4',
          hover: '#0fb9ab',
          dark: '#0a9e91',
        },
        'primary-hover': '#0fb9ab',
        'primary-dark': '#0a9e91',
        'background-light': '#f8fcfb',
        'background-dark': '#102220',
        'card-light': 'rgba(255, 255, 255, 0.7)',
        'card-stroke': 'rgba(255, 255, 255, 0.6)',
        'surface-light': 'rgba(255, 255, 255, 0.7)',
        'surface-dark': 'rgba(30, 41, 59, 0.7)',
        'text-main': '#0d1b1a',
        'text-secondary': '#4c9a93',
        'text-light': '#1E293B',
        'text-dark': '#E2E8F0',
        'border-light': '#e2e8f0',
        'border-dark': '#334155',
        'teal-gradient-start': '#11d4c4',
        'teal-gradient-end': '#a7f3ee',
      },
      fontFamily: {
        sans: ['Outfit', 'sans-serif'],
        display: ['Outfit', 'sans-serif'],
        body: ['Outfit', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
      borderRadius: {
        DEFAULT: '0.5rem',
        lg: '1rem',
        xl: '1.5rem',
        '2xl': '2rem',
        full: '9999px',
      },
      boxShadow: {
        glass: '0 8px 32px 0 rgba(31, 38, 135, 0.07)',
        glow: '0 0 15px rgba(17, 212, 196, 0.3)',
      },
    },
  },
  plugins: [],
}

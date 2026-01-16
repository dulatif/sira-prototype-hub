/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#2a9d8f',
          hover: '#238b7e',
          dark: '#1d7a6f',
        },
        secondary: '#e9c46a',
        accent: '#f4a261',
        danger: '#ef4444',
        background: {
          light: '#f8fafa',
          dark: '#0f172a',
        },
        text: {
          light: '#1e293b',
          dark: '#f1f5f9',
        },
        border: {
          light: '#e2e8f0',
          dark: '#334155',
        },
      },
      fontFamily: {
        sans: ['Outfit', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
        display: ['Outfit', 'system-ui', 'sans-serif'],
        body: ['Manrope', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [],
}

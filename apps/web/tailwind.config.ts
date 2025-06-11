import type { Config } from 'tailwindcss'

const config: Config = {
  darkMode: 'class',
  content: ['./src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      transitionDuration: { DEFAULT: '50ms' },
    },
  },
  plugins: [],
}
export default config

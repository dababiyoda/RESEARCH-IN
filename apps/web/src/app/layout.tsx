import './globals.css'
import { ReactNode } from 'react'

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className="min-h-screen bg-white text-black transition-colors dark:bg-black dark:text-white">
        {children}
      </body>
    </html>
  )
}

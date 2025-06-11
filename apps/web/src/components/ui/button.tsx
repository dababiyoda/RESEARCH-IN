import * as React from 'react'

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode
}

export const Button: React.FC<ButtonProps> = ({ children, ...props }) => (
  <button className="px-3 py-1 rounded bg-blue-600 text-white" {...props}>
    {children}
  </button>
)

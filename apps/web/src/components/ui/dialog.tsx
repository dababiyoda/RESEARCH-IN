import * as React from 'react'

interface DialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  children: React.ReactNode
}

export const Dialog = ({ open, onOpenChange, children }: DialogProps) => {
  if (!open) return null
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50" onClick={() => onOpenChange(false)}>
      <div className="bg-white rounded-md p-4" onClick={e => e.stopPropagation()}>
        {children}
      </div>
    </div>
  )
}

interface TriggerProps {
  children: React.ReactNode
}

export const DialogTrigger = ({ children }: TriggerProps) => <>{children}</>

export const DialogContent: React.FC<{ children: React.ReactNode }> = ({ children }) => <>{children}</>
export const DialogTitle: React.FC<{ children: React.ReactNode }> = ({ children }) => <h2 className="text-lg font-bold mb-2">{children}</h2>
export const DialogDescription: React.FC<{ children: React.ReactNode }> = ({ children }) => <p className="mb-2 text-sm text-gray-600">{children}</p>

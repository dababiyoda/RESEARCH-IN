import { useState } from 'react'
import supabase from '../lib/supabaseClient'
import { Button } from './ui/button'
import { Dialog, DialogTrigger, DialogContent, DialogTitle, DialogDescription } from './ui/dialog'

export const AuthDialog: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [open, setOpen] = useState(false)
  const [email, setEmail] = useState('')

  const loginEmail = async () => {
    await supabase.auth.signInWithOtp({ email })
  }

  const loginProvider = async (provider: 'google' | 'github' | 'orcid') => {
    await supabase.auth.signInWithOAuth({ provider })
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <span onClick={() => setOpen(true)}>{children}</span>
      </DialogTrigger>
      <DialogContent>
        <DialogTitle>Sign in</DialogTitle>
        <DialogDescription>
          Use email or your favorite provider
        </DialogDescription>
        <div className="space-y-2">
          <input
            className="w-full border rounded px-2 py-1"
            placeholder="you@example.com"
            value={email}
            onChange={e => setEmail(e.target.value)}
          />
          <Button onClick={loginEmail}>Send magic link</Button>
          <div className="flex gap-2">
            <Button onClick={() => loginProvider('google')}>Google</Button>
            <Button onClick={() => loginProvider('github')}>GitHub</Button>
            <Button onClick={() => loginProvider('orcid')}>ORCID</Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  )
}

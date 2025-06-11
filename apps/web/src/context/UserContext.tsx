import { createContext, useContext, useEffect, useState } from 'react'
import { User } from '@supabase/supabase-js'
import supabase from '../lib/supabaseClient'

interface UserState {
  user: User | null
  karma: number
  loading: boolean
}

const UserContext = createContext<UserState>({
  user: null,
  karma: 0,
  loading: true,
})

export const UserProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null)
  const [karma, setKarma] = useState(0)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      const u = data?.user ?? null
      setUser(u)
      if (u) {
        const { data: profile } = await supabase
          .from('profiles')
          .select('karma')
          .eq('id', u.id)
          .single()
        setKarma(profile?.karma ?? 0)
      }
      setLoading(false)
    })

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_e, session) => {
      const u = session?.user ?? null
      setUser(u)
      if (!u) {
        setKarma(0)
      }
    })

    return () => {
      subscription.unsubscribe()
    }
  }, [])

  return (
    <UserContext.Provider value={{ user, karma, loading }}>
      {children}
    </UserContext.Provider>
  )
}

export const useUser = () => useContext(UserContext)

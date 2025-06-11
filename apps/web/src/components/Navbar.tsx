import Image from 'next/image'
import { Button } from './ui/button'
import { AuthDialog } from './AuthDialog'
import { useUser } from '../context/UserContext'

export default function Navbar() {
  const { user, karma, loading } = useUser()

  return (
    <nav className="flex justify-between items-center p-4 border-b">
      <div className="font-bold">Research-IN</div>
      <div className="flex items-center gap-2">
        {loading ? null : user ? (
          <>
            <span className="bg-gray-200 text-sm px-2 rounded-full">{karma}</span>
            {user.user_metadata?.avatar_url ? (
              <Image
                src={user.user_metadata.avatar_url}
                alt="avatar"
                width={32}
                height={32}
                className="rounded-full"
              />
            ) : (
              <div className="w-8 h-8 rounded-full bg-gray-300" />
            )}
          </>
        ) : (
          <AuthDialog>
            <Button>Sign In</Button>
          </AuthDialog>
        )}
      </div>
    </nav>
  )
}

import { UserProvider } from './context/UserContext'
import Navbar from './components/Navbar'

export default function App({ children }: { children: React.ReactNode }) {
  return (
    <UserProvider>
      <Navbar />
      <main>{children}</main>
    </UserProvider>
  )
}

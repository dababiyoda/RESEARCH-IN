export type Database = {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          karma: number
          avatar_url: string | null
        }
      }
    }
  }
}

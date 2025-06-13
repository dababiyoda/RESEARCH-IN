import { cleanEnv, str, url } from 'envalid';

export const env = cleanEnv(process.env, {
  SUPABASE_URL: url(),
  SUPABASE_ANON_KEY: str(),
});

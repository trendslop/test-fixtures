import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseAnonKey = process.env.SUPABASE_ANON_KEY;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export async function listPosts() {
  const { data } = await supabase.from('posts').select('*').eq('published', true);
  return data;
}

export async function getUserPosts(userId) {
  const { data } = await supabase.from('posts').select('*').eq('user_id', userId);
  return data;
}

export async function getUser(userId) {
  const { data } = await supabase.from('users').select('*').eq('id', userId).single();
  return data;
}

-- Initial schema for the app
-- INTENTIONALLY MISSING RLS for testing Trendslop's supabase_rls check.

CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  display_name text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE posts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id),
  title text NOT NULL,
  body text,
  published boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id uuid REFERENCES posts(id),
  user_id uuid REFERENCES users(id),
  body text NOT NULL,
  created_at timestamptz DEFAULT now()
);

BEGIN;

-- =============================================================================
-- Enable RLS on all tables
-- =============================================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- =============================================================================
-- USERS table policies
-- =============================================================================

-- Allow anyone to read user profiles (public directory)
CREATE POLICY "users_select_all"
  ON users
  FOR SELECT
  USING (true);

-- Allow users to insert their own profile (assumes auth trigger creates the record with matching id)
CREATE POLICY "users_insert_own"
  ON users
  FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Allow users to update only their own profile
CREATE POLICY "users_update_own"
  ON users
  FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Allow users to delete only their own profile
CREATE POLICY "users_delete_own"
  ON users
  FOR DELETE
  USING (auth.uid() = id);

-- =============================================================================
-- POSTS table policies
-- =============================================================================

-- Allow anyone to read published posts
CREATE POLICY "posts_select_published"
  ON posts
  FOR SELECT
  USING (published = true);

-- Allow authors to read their own unpublished posts
CREATE POLICY "posts_select_own"
  ON posts
  FOR SELECT
  USING (auth.uid() = user_id);

-- Allow authenticated users to create posts (must set user_id to their own id)
CREATE POLICY "posts_insert_own"
  ON posts
  FOR INSERT
  WITH CHECK (
    auth.uid() IS NOT NULL
    AND auth.uid() = user_id
  );

-- Allow authors to update only their own posts
CREATE POLICY "posts_update_own"
  ON posts
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Allow authors to delete only their own posts
CREATE POLICY "posts_delete_own"
  ON posts
  FOR DELETE
  USING (auth.uid() = user_id);

-- =============================================================================
-- COMMENTS table policies
-- =============================================================================

-- Allow anyone to read comments on published posts
CREATE POLICY "comments_select_on_published_posts"
  ON comments
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM posts
      WHERE posts.id = comments.post_id
      AND posts.published = true
    )
  );

-- Allow comment authors to read their own comments (even on unpublished posts)
CREATE POLICY "comments_select_own"
  ON comments
  FOR SELECT
  USING (auth.uid() = user_id);

-- Allow authenticated users to create comments (must set user_id to their own id)
CREATE POLICY "comments_insert_own"
  ON comments
  FOR INSERT
  WITH CHECK (
    auth.uid() IS NOT NULL
    AND auth.uid() = user_id
  );

-- Allow comment authors to update only their own comments
CREATE POLICY "comments_update_own"
  ON comments
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Allow comment authors to delete only their own comments
CREATE POLICY "comments_delete_own"
  ON comments
  FOR DELETE
  USING (auth.uid() = user_id);

COMMIT;

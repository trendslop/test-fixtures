BEGIN;

-- ============================================================================
-- ASSUMPTIONS (verify these match your app):
-- 1. users.id = auth.uid() (standard Supabase auth pattern)
-- 2. User profiles (display_name) are publicly readable
-- 3. posts.published=true makes posts publicly readable
-- 4. Only post authors can update/delete their posts
-- 5. Comments visibility follows the parent post's published status
-- ============================================================================

-- ============================================================================
-- USERS TABLE
-- ============================================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Allow anyone to view user profiles (public directory pattern)
CREATE POLICY "Users are viewable by everyone"
  ON users FOR SELECT
  USING (true);

-- Users can insert their own profile (id must match auth.uid())
CREATE POLICY "Users can insert their own profile"
  ON users FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Users can delete their own profile
CREATE POLICY "Users can delete own profile"
  ON users FOR DELETE
  USING (auth.uid() = id);

-- ============================================================================
-- POSTS TABLE
-- ============================================================================

ALTER TABLE posts ENABLE ROW LEVEL SECURITY;

-- Anyone can view published posts; authors can view their own unpublished posts
CREATE POLICY "Published posts are viewable by everyone"
  ON posts FOR SELECT
  USING (published = true OR auth.uid() = user_id);

-- Authenticated users can create posts (user_id must match auth.uid())
CREATE POLICY "Authenticated users can create posts"
  ON posts FOR INSERT
  WITH CHECK (auth.uid() = user_id AND auth.uid() IS NOT NULL);

-- Users can update their own posts
CREATE POLICY "Users can update own posts"
  ON posts FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own posts
CREATE POLICY "Users can delete own posts"
  ON posts FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================================================
-- COMMENTS TABLE
-- ============================================================================

ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- Comments on published posts are viewable by everyone; otherwise only by the comment author
CREATE POLICY "Comments on published posts are viewable"
  ON comments FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM posts
      WHERE posts.id = comments.post_id
      AND posts.published = true
    )
    OR auth.uid() = user_id
  );

-- Authenticated users can create comments (user_id must match auth.uid())
CREATE POLICY "Authenticated users can create comments"
  ON comments FOR INSERT
  WITH CHECK (auth.uid() = user_id AND auth.uid() IS NOT NULL);

-- Users can update their own comments
CREATE POLICY "Users can update own comments"
  ON comments FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own comments
CREATE POLICY "Users can delete own comments"
  ON comments FOR DELETE
  USING (auth.uid() = user_id);

COMMIT;

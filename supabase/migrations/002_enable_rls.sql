-- Migration: Enable Row Level Security on users, posts, and comments
-- Created: 2024
-- Purpose: Add RLS policies to secure tables that were missing protection

BEGIN;

-- ============================================================================
-- USERS TABLE
-- ============================================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Allow anyone to view user profiles (common pattern for user directories)
CREATE POLICY "Users are viewable by everyone"
  ON users
  FOR SELECT
  USING (true);

-- Users can insert their own profile (auth.uid must match id)
CREATE POLICY "Users can insert their own profile"
  ON users
  FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON users
  FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Users can delete their own profile
CREATE POLICY "Users can delete own profile"
  ON users
  FOR DELETE
  USING (auth.uid() = id);

-- ============================================================================
-- POSTS TABLE
-- ============================================================================

ALTER TABLE posts ENABLE ROW LEVEL SECURITY;

-- Anyone can view published posts; users can view their own unpublished posts
CREATE POLICY "Published posts are viewable by everyone"
  ON posts
  FOR SELECT
  USING (
    published = true 
    OR auth.uid() = user_id
  );

-- Authenticated users can create posts (with user_id matching their auth.uid)
CREATE POLICY "Authenticated users can create posts"
  ON posts
  FOR INSERT
  WITH CHECK (
    auth.uid() = user_id
    AND auth.uid() IS NOT NULL
  );

-- Users can update their own posts
CREATE POLICY "Users can update own posts"
  ON posts
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own posts
CREATE POLICY "Users can delete own posts"
  ON posts
  FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================================================
-- COMMENTS TABLE
-- ============================================================================

ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- Anyone can view comments (standard for public discussion threads)
CREATE POLICY "Comments are viewable by everyone"
  ON comments
  FOR SELECT
  USING (true);

-- Authenticated users can create comments (with user_id matching their auth.uid)
CREATE POLICY "Authenticated users can create comments"
  ON comments
  FOR INSERT
  WITH CHECK (
    auth.uid() = user_id
    AND auth.uid() IS NOT NULL
  );

-- Users can update their own comments
CREATE POLICY "Users can update own comments"
  ON comments
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own comments
CREATE POLICY "Users can delete own comments"
  ON comments
  FOR DELETE
  USING (auth.uid() = user_id);

COMMIT;

-- Migration script for the initial schema of the Open-Research Nexus.
-- Located conceptually at packages/db/migrations/001_initial_schema.sql

-- 1. Enable the pgvector extension
-- This extension is required for storing and querying vector embeddings.
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. Create the 'users' table
-- This table stores public profile information for users, linked to Supabase Auth.
CREATE TABLE public.users (
    id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE, -- Link to Supabase Auth (auth.users)
    username text UNIQUE NOT NULL,
    display_name text,
    orcid text UNIQUE, -- Open Researcher and Contributor ID
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Add indexes for efficient lookup on common fields
CREATE INDEX idx_users_username ON public.users (username);
CREATE INDEX idx_users_orcid ON public.users (orcid);

-- Enable Row Level Security (RLS) for the users table
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Define RLS policies
CREATE POLICY "Public profiles are viewable by everyone."
  ON public.users FOR SELECT
  USING (true);

CREATE POLICY "Users can update their own profile."
  ON public.users FOR UPDATE
  USING ((auth.uid() = id));

-- 3. Create other core tables

-- Papers table: Stores metadata for research papers.
CREATE TABLE public.papers (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title text NOT NULL,
    abstract text,
    publication_date date,
    doi text UNIQUE, -- Digital Object Identifier
    arxiv_id text UNIQUE, -- arXiv identifier
    authors text[], -- List of author names (consider a separate authors table for more complex needs)
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE INDEX idx_papers_doi ON public.papers (doi);
CREATE INDEX idx_papers_arxiv_id ON public.papers (arxiv_id);

-- Datasets table: Stores metadata for research datasets.
CREATE TABLE public.datasets (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title text NOT NULL,
    description text,
    publication_date date,
    doi text UNIQUE, -- Digital Object Identifier
    url text, -- URL to the dataset repository/landing page
    authors text[], -- List of creators/authors
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE INDEX idx_datasets_doi ON public.datasets (doi);

-- Research Questions table: Stores research questions defined by users.
CREATE TABLE public.research_questions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    text text NOT NULL,
    created_by uuid REFERENCES public.users(id) ON DELETE SET NULL, -- Link to the user who created the question
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE INDEX idx_research_questions_created_by ON public.research_questions (created_by);

-- Paper Chunks table: Stores smaller segments of paper content for vector search and analysis.
CREATE TABLE public.paper_chunks (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    paper_id uuid REFERENCES public.papers(id) ON DELETE CASCADE, -- Link to the parent paper
    content text NOT NULL, -- The text content of the chunk
    chunk_order integer NOT NULL, -- The sequential order of the chunk within the paper
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE INDEX idx_paper_chunks_paper_id ON public.paper_chunks (paper_id);
CREATE INDEX idx_paper_chunks_chunk_order ON public.paper_chunks (chunk_order);

-- 4. Add the vector column to the paper_chunks table
-- This column will store the vector embeddings of the chunk content.
ALTER TABLE public.paper_chunks ADD COLUMN embedding VECTOR(768); -- Dimension 768 as specified

-- 5. Create an efficient index on the new vector column
-- Using the ivfflat index with L2 distance metric for fast nearest neighbor search.
CREATE INDEX idx_paper_chunks_embedding ON public.paper_chunks USING ivfflat (embedding vector_l2_ops);

-- Note: Additional tables and relationships (e.g., many-to-many relationships between papers, datasets, questions)
-- and more granular RLS policies may be added in subsequent migrations based on evolving requirements.

-- PostgreSQL initialization script for Navigator
-- This script runs automatically when the database container starts for the first time

-- Enable the pgvector extension for vector embeddings on the default 'navigator' database
CREATE EXTENSION IF NOT EXISTS vector;

-- Create a separate database for the Letta service
CREATE DATABASE letta;

-- Connect to the 'letta' database and enable the vector extension
\c letta
CREATE EXTENSION IF NOT EXISTS vector;

-- Verify the extension was created successfully in the 'navigator' database
\c navigator
SELECT extname FROM pg_extension WHERE extname = 'vector';

-- Verify the extension was created successfully in the 'letta' database
\c letta
SELECT extname FROM pg_extension WHERE extname = 'vector';

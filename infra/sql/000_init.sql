-- Initial schema
CREATE EXTENSION IF NOT EXISTS "vector";

CREATE TABLE users (
    id UUID PRIMARY KEY,
    orcid TEXT,
    karma INTEGER DEFAULT 0
);

CREATE TABLE papers (
    id BIGSERIAL PRIMARY KEY,
    cid TEXT,
    title TEXT,
    abstract TEXT,
    md5 CHAR(32),
    uploaded_by UUID REFERENCES users(id)
);

CREATE TABLE embeddings (
    paper_id BIGINT REFERENCES papers(id),
    chunk_idx INT,
    vector VECTOR(768)
);

CREATE TABLE questions (
    id BIGSERIAL PRIMARY KEY,
    slug TEXT,
    title TEXT,
    created_by UUID REFERENCES users(id)
);

CREATE TABLE threads (
    id BIGSERIAL PRIMARY KEY,
    question_id BIGINT REFERENCES questions(id),
    body TEXT,
    created_by UUID REFERENCES users(id)
);

CREATE TABLE votes (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    target TEXT,
    target_id BIGINT,
    weight INT
);

-- Row level security policies: anyone can read, writes allowed only on own rows.
-- Application should set current_user_id via: SET app.current_user_id = '<uuid>';
DO $$
DECLARE
    tbl text;
BEGIN
    FOR tbl IN SELECT 'users' UNION ALL
               SELECT 'papers' UNION ALL
               SELECT 'embeddings' UNION ALL
               SELECT 'questions' UNION ALL
               SELECT 'threads' UNION ALL
               SELECT 'votes'
    LOOP
        EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', tbl);
        EXECUTE format('CREATE POLICY %I_read ON %I FOR SELECT USING (true)', tbl, tbl);
    END LOOP;

    -- users table ownership is by id column
    EXECUTE 'CREATE POLICY users_write ON users FOR ALL USING (id = current_setting(''app.current_user_id'')::uuid) WITH CHECK (id = current_setting(''app.current_user_id'')::uuid)';

    -- other tables ownership via uploaded_by or created_by or user_id
    EXECUTE 'CREATE POLICY papers_write ON papers FOR ALL USING (uploaded_by = current_setting(''app.current_user_id'')::uuid) WITH CHECK (uploaded_by = current_setting(''app.current_user_id'')::uuid)';
    EXECUTE 'CREATE POLICY embeddings_write ON embeddings FOR ALL USING (paper_id IN (SELECT id FROM papers WHERE uploaded_by = current_setting(''app.current_user_id'')::uuid)) WITH CHECK (paper_id IN (SELECT id FROM papers WHERE uploaded_by = current_setting(''app.current_user_id'')::uuid))';
    EXECUTE 'CREATE POLICY questions_write ON questions FOR ALL USING (created_by = current_setting(''app.current_user_id'')::uuid) WITH CHECK (created_by = current_setting(''app.current_user_id'')::uuid)';
    EXECUTE 'CREATE POLICY threads_write ON threads FOR ALL USING (created_by = current_setting(''app.current_user_id'')::uuid) WITH CHECK (created_by = current_setting(''app.current_user_id'')::uuid)';
    EXECUTE 'CREATE POLICY votes_write ON votes FOR ALL USING (user_id = current_setting(''app.current_user_id'')::uuid) WITH CHECK (user_id = current_setting(''app.current_user_id'')::uuid)';
END $$;


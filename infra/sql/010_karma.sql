-- Karma and badge triggers

-- Table to store awarded badges
CREATE TABLE badges (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    code TEXT,
    awarded_at TIMESTAMPTZ DEFAULT now()
);

-- Row level security for badges table
ALTER TABLE badges ENABLE ROW LEVEL SECURITY;
CREATE POLICY badges_read ON badges FOR SELECT USING (true);
CREATE POLICY badges_write ON badges FOR ALL USING (user_id = current_setting('app.current_user_id')::uuid) WITH CHECK (user_id = current_setting('app.current_user_id')::uuid);

-- Function to award first upload badge
CREATE OR REPLACE FUNCTION award_first_upload(p_user uuid) RETURNS void AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM badges WHERE user_id = p_user AND code = 'first_upload'
    ) AND (
        SELECT COUNT(*) FROM papers WHERE uploaded_by = p_user
    ) = 1 THEN
        INSERT INTO badges(user_id, code) VALUES (p_user, 'first_upload');
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Trigger function for papers insert to increment karma and check badge
CREATE OR REPLACE FUNCTION papers_after_insert() RETURNS trigger AS $$
BEGIN
    UPDATE users SET karma = karma + 10 WHERE id = NEW.uploaded_by;
    PERFORM award_first_upload(NEW.uploaded_by);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_papers_after_insert
AFTER INSERT ON papers
FOR EACH ROW EXECUTE PROCEDURE papers_after_insert();

-- Trigger function for vote inserts to increment karma for target owner
CREATE OR REPLACE FUNCTION votes_after_insert() RETURNS trigger AS $$
DECLARE
    owner uuid;
BEGIN
    IF NEW.weight = 1 THEN
        IF NEW.target = 'papers' THEN
            SELECT uploaded_by INTO owner FROM papers WHERE id = NEW.target_id;
        ELSIF NEW.target = 'questions' THEN
            SELECT created_by INTO owner FROM questions WHERE id = NEW.target_id;
        ELSIF NEW.target = 'threads' THEN
            SELECT created_by INTO owner FROM threads WHERE id = NEW.target_id;
        END IF;
        IF owner IS NOT NULL THEN
            UPDATE users SET karma = karma + 2 WHERE id = owner;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_votes_after_insert
AFTER INSERT ON votes
FOR EACH ROW EXECUTE PROCEDURE votes_after_insert();

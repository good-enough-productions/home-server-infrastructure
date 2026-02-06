CREATE TABLE IF NOT EXISTS n8n_nodes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(50), -- Trigger, Action, Logic
    description TEXT,
    is_free BOOLEAN DEFAULT TRUE,
    local_alternative VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS n8n_templates (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    complexity VARCHAR(20) -- Low, Medium, High
);

-- Insert some initial data
INSERT INTO n8n_nodes (name, category, description, is_free, local_alternative) VALUES
('Webhook', 'Trigger', 'Starts workflow on HTTP request', TRUE, NULL),
('Schedule', 'Trigger', 'Starts workflow at specific time', TRUE, NULL),
('Cron', 'Trigger', 'Starts workflow on cron schedule', TRUE, NULL),
('MQTT Trigger', 'Trigger', 'Starts workflow on MQTT message', TRUE, NULL),
('Postgres Trigger', 'Trigger', 'Starts workflow on DB change', TRUE, NULL),
('HTTP Request', 'Action', 'Make HTTP calls', TRUE, NULL),
('Postgres', 'Action', 'Read/Write to Postgres DB', TRUE, NULL),
('Read/Write File', 'Action', 'File system operations', TRUE, NULL),
('Code', 'Action', 'Run JavaScript code', TRUE, NULL),
('Ollama (via HTTP)', 'Action', 'AI generation', TRUE, 'OpenAI API'),
('If', 'Logic', 'Conditional routing', TRUE, NULL),
('Switch', 'Logic', 'Multi-way routing', TRUE, NULL),
('Merge', 'Logic', 'Combine data streams', TRUE, NULL),
('Split In Batches', 'Logic', 'Loop over items', TRUE, NULL);

INSERT INTO n8n_templates (name, description, category, complexity) VALUES
('Sync GitHub Issues to Notion', 'Syncs issues from GitHub to Notion database', 'Productivity', 'Medium'),
('Daily Weather Report', 'Sends weather report via email/chat', 'Personal', 'Low'),
('Backup Postgres to S3', 'Backs up database to cloud storage', 'DevOps', 'Medium'),
('AI Chatbot with Ollama', 'Chat interface using local LLM', 'AI', 'High');

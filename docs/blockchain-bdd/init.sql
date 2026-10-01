-- SAE-Recommender - Initialisation de la base PostgreSQL
-- Responsable : Iyore
-- Phase 1

-- Supprimer les tables si elles existent
DROP TABLE IF EXISTS votes CASCADE;
DROP TABLE IF EXISTS legitimacies CASCADE;
DROP TABLE IF EXISTS battles CASCADE;
DROP TABLE IF EXISTS recommendations CASCADE;
DROP TABLE IF EXISTS cards CASCADE;
DROP TABLE IF EXISTS blocks CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Creer la table users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    is_bot BOOLEAN DEFAULT FALSE,
    reco_count INT DEFAULT 0,
    legitimacy_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Creer la table cards
CREATE TABLE cards (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    paradigm VARCHAR(30) NOT NULL,
    description TEXT,
    typing VARCHAR(20),
    difficulty VARCHAR(20),
    year_created INT,
    image_url VARCHAR(500),
    creator_id INT REFERENCES users(id),
    owner_id INT REFERENCES users(id),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    value INT DEFAULT 0,
    is_authenticated BOOLEAN DEFAULT FALSE,
    authenticated_by INT REFERENCES users(id),
    win_count INT DEFAULT 0,
    is_legitimate BOOLEAN DEFAULT FALSE,
    stake_va INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Creer la table recommendations
CREATE TABLE recommendations (
    id SERIAL PRIMARY KEY,
    card_id INT REFERENCES cards(id),
    user_id INT REFERENCES users(id),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Creer la table battles
CREATE TABLE battles (
    id SERIAL PRIMARY KEY,
    card1_id INT REFERENCES cards(id),
    card2_id INT REFERENCES cards(id),
    winner_id INT,
    status VARCHAR(20),
    started_at TIMESTAMP,
    ended_at TIMESTAMP
);

-- Creer la table votes
CREATE TABLE votes (
    id SERIAL PRIMARY KEY,
    battle_id INT REFERENCES battles(id),
    user_id INT REFERENCES users(id),
    card_id INT REFERENCES cards(id),
    weight INT DEFAULT 1,
    signature VARCHAR(256),
    voted_at TIMESTAMP DEFAULT NOW()
);

-- Creer la table legitimacies
CREATE TABLE legitimacies (
    id SERIAL PRIMARY KEY,
    card_id INT REFERENCES cards(id),
    user_id INT REFERENCES users(id),
    status VARCHAR(20),
    requested_at TIMESTAMP,
    granted_at TIMESTAMP
);

-- Creer la table blocks
CREATE TABLE blocks (
    id SERIAL PRIMARY KEY,
    timestamp BIGINT NOT NULL,
    data JSONB NOT NULL,
    prev_hash CHAR(64),
    nonce BIGINT,
    hash CHAR(64),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Inserer le bloc genesis
INSERT INTO blocks (timestamp, data, prev_hash, nonce, hash)
VALUES (
    0,
    '{"action":"GENESIS"}'::jsonb,
    '0000000000000000000000000000000000000000000000000000000000000000',
    0,
    '0000000000000000000000000000000000000000000000000000000000000000'
);

-- Verifier l'initialisation
SELECT 'Base initialisee avec succes' AS statut;

-- Afficher les tables creees
SELECT tablename FROM pg_tables WHERE schemaname = 'public';

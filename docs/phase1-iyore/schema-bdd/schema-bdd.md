# Schéma relationnel de la base de données

**Projet :** SAÉ BUT2 S3 2026-2027
**Thème :** Langages de programmation
**Responsable :** Iyore
**Partie :** Blockchain + PostgreSQL


---

## 1. Objectif

Ce document décrit le schéma relationnel de la base de données PostgreSQL du projet SAE-Recommender.

Il présente les 7 tables, leurs colonnes, leurs types et leurs relations.

---

## 2. Vue d'ensemble

La base contient 7 tables :

La table users contient les utilisateurs.

La table cards contient les cartes langages.

La table recommendations contient les recommandations.

La table battles contient les battles.

La table votes contient les votes.

La table legitimacies contient les légitimations.

La table blocks contient les blocs de la blockchain.

---

## 3. Table users

La table users stocke les utilisateurs de la plateforme.

Colonnes : id (SERIAL PRIMARY KEY), username (VARCHAR 50 UNIQUE NOT NULL), is_bot (BOOLEAN DEFAULT FALSE), reco_count (INT DEFAULT 0), legitimacy_count (INT DEFAULT 0), created_at (TIMESTAMP DEFAULT NOW()).

---

## 4. Table cards

La table cards stocke les cartes langages de programmation.

Colonnes : id (SERIAL PRIMARY KEY), title (VARCHAR 100 NOT NULL), paradigm (VARCHAR 30 NOT NULL), description (TEXT), typing (VARCHAR 20), difficulty (VARCHAR 20), year_created (INT), image_url (VARCHAR 500), creator_id (INT REFERENCES users), owner_id (INT REFERENCES users), status (VARCHAR 20 DEFAULT 'ACTIVE'), value (INT DEFAULT 0), is_authenticated (BOOLEAN DEFAULT FALSE), authenticated_by (INT REFERENCES users), win_count (INT DEFAULT 0), is_legitimate (BOOLEAN DEFAULT FALSE), stake_va (INT DEFAULT 0), created_at (TIMESTAMP DEFAULT NOW()).

---

## 5. Table recommendations

La table recommendations stocke les recommandations données par les utilisateurs.

Colonnes : id (SERIAL PRIMARY KEY), card_id (INT REFERENCES cards), user_id (INT REFERENCES users), active (BOOLEAN DEFAULT TRUE), created_at (TIMESTAMP DEFAULT NOW()).

---

## 6. Table battles

La table battles stocke les battles entre deux cartes.

Colonnes : id (SERIAL PRIMARY KEY), card1_id (INT REFERENCES cards), card2_id (INT REFERENCES cards), winner_id (INT), status (VARCHAR 20), started_at (TIMESTAMP), ended_at (TIMESTAMP).

---

## 7. Table votes

La table votes stocke les votes dans les battles.

Colonnes : id (SERIAL PRIMARY KEY), battle_id (INT REFERENCES battles), user_id (INT REFERENCES users), card_id (INT REFERENCES cards), weight (INT DEFAULT 1), signature (VARCHAR 256), voted_at (TIMESTAMP DEFAULT NOW()).

---

## 8. Table legitimacies

La table legitimacies stocke les demandes de légitimation.

Colonnes : id (SERIAL PRIMARY KEY), card_id (INT REFERENCES cards), user_id (INT REFERENCES users), status (VARCHAR 20), requested_at (TIMESTAMP), granted_at (TIMESTAMP).

---

## 9. Table blocks

La table blocks stocke les blocs de la blockchain.

Colonnes : id (SERIAL PRIMARY KEY), timestamp (BIGINT NOT NULL), data (JSONB NOT NULL), prev_hash (CHAR 64), nonce (BIGINT), hash (CHAR 64), created_at (TIMESTAMP DEFAULT NOW()).

---

## 10. Relations entre tables

Un user peut créer plusieurs cards.

Un user peut posséder plusieurs cards.

Un user peut émettre plusieurs recommendations.

Un user peut voter dans plusieurs battles.

Un user peut demander plusieurs legitimacies.

Une card peut recevoir plusieurs recommendations.

Une card peut participer à plusieurs battles.

Une card peut être concernée par plusieurs legitimacies.

Une battle peut recevoir plusieurs votes.

---

## 11. Clés primaires et étrangères

Chaque table a une clé primaire id.

Les clés étrangères sont :

creator_id et owner_id dans cards référencent users.

authenticated_by dans cards référence users.

card_id et user_id dans recommendations référencent cards et users.

card1_id et card2_id dans battles référencent cards.

battle_id, user_id et card_id dans votes référencent battles, users et cards.

card_id et user_id dans legitimacies référencent cards et users.

---

## 12. Script SQL

Le script SQL complet est disponible dans le fichier schema.sql du même dossier.

---

## 13. Validation

| Rôle | Nom | Statut |
|------|-----|--------|
| Blockchain + BDD | Iyore | ⏳ |
| Serveur C | Mai | ⏳ |
| Client Java | Usman | ⏳ |

---

**Fin du document.**

# Spécification technique — SAE-Recommender

> **SAÉ BUT2 S3 2026-2027**
> Plateforme de recommandations fondée sur une blockchain privée simplifiée.
> **Thème :** Langages de programmation

---

## Table des matières

1. [Introduction](#1-introduction)
2. [Répartition des rôles](#2-répartition-des-rôles)
3. [Architecture du serveur](#3-architecture-du-serveur)
4. [Architecture des clients](#4-architecture-des-clients)
5. [Organisation des données côté serveur](#5-organisation-des-données-côté-serveur)
6. [Organisation des données côté client](#6-organisation-des-données-côté-client)
7. [Schéma relationnel de la base de données](#7-schéma-relationnel-de-la-base-de-données)
8. [Structures de données de la blockchain](#8-structures-de-données-de-la-blockchain)
9. [Données associées](#9-données-associées)
10. [Règles métier](#10-règles-métier)
11. [Diagrammes de séquence](#11-diagrammes-de-séquence)
12. [Protocole applicatif](#12-protocole-applicatif)
13. [Cas d'erreur](#13-cas-derreur)
14. [Conclusion](#14-conclusion)
15. [Validation](#15-validation)

---

## 1. Introduction

### 1.1 Contexte

Ce document constitue la spécification technique du projet SAE-Recommender, réalisé dans le cadre de la SAÉ du troisième semestre du BUT Informatique (2026-2027).

### 1.2 Objectif du projet

L'objectif est de réaliser une plateforme client-serveur de recommandations structurée autour de cartes.

La plateforme s'appuie sur :

- une communication par sockets TCP ;
- un serveur multitâche en C ;
- une blockchain privée simplifiée avec preuve de travail ;
- une sauvegarde en base PostgreSQL ;
- des tests unitaires ;
- une interface graphique JavaFX.

### 1.3 Thème choisi

Une carte représente un **langage de programmation**.

**Justification :**

- cohérent avec la formation BUT Informatique ;
- objet concret et vérifiable ;
- facilite la description avec des critères objectifs ;
- permet des battles pertinentes (comparaison de langages) ;
- chaque langage possède un logo officiel.

**Exemples :** Python, Java, C, C++, Rust, JavaScript, TypeScript, Go, Ruby, Kotlin, Swift, Haskell, PHP, Scala, Elixir, Lua, R, SQL, Bash.

### 1.4 Technologies utilisées

| Technologie | Utilisation |
| --- | --- |
| Linux Debian | Environnement de développement |
| Langage C | Serveur + tests |
| Langage Java | Client + tests |
| JavaFX | Interface graphique |
| Blockchain | Traçabilité + intégrité |
| SHA-256 | Hashage |
| PostgreSQL | Base de données |
| Git | Versioning |

---

## 2. Répartition des rôles

Voir le document complet : [`commun/repartition-roles.md`](commun/repartition-roles.md)

### 2.1 Composition de l'équipe

| Membre | Partie | Technologies |
| --- | --- | --- |
| Usman | Client Java + JavaFX + Tests | Java, JavaFX, JUnit, Gson |
| Omar | Client Java + JavaFX + Tests | Java, JavaFX, JUnit, Gson |
| Mai | Serveur C + Sockets + Tests | C, pthreads, sockets |
| Albine | Serveur C + Sockets + Tests | C, pthreads, sockets |
| Iyore | Blockchain + PostgreSQL | C, SHA-256, PostgreSQL |

### 2.2 Répartition des tâches Phase 1

| # | Tâche | Usman + Omar | Mai + Albine | Iyore |
| --- | --- | --- | --- | --- |
| 1 | Répartition des rôles | ✓ | ✓ | ✓ |
| 2 | Architecture du serveur | Aide | Principal | — |
| 3 | Architecture des clients | Principal | — | — |
| 4 | Organisation données serveur | Aide | Principal | Aide |
| 5 | Organisation données client | Principal | — | Validation |
| 6 | Schéma relationnel BDD | — | Aide | Principal |
| 7 | Structures blockchain | — | Aide | Principal |
| 8 | Données cartes/recos/battles | ✓ | ✓ | ✓ |
| 9 | Règles métier | ✓ | ✓ | ✓ |
| 10 | Diagrammes de séquence | Client | Serveur | BDD |
| 11 | Protocole applicatif | Rédaction | Validation | — |
| 12 | Cas d'erreur | Client | Serveur | BDD |

---

## 3. Architecture du serveur

Voir le document complet : [`serveur/architecture-serveur.md`](serveur/architecture-serveur.md)

### 3.1 Vue d'ensemble

Le serveur C est structuré en modules pour séparer les responsabilités.

![Architecture serveur](src/diagrammes-serveur/01-architecture-serveur.png)

### 3.2 Modules du serveur

| Module | Fichier source | En-tête | Rôle |
| --- | --- | --- | --- |
| Boucle principale | `main.c` | — | Démarrage, arrêt |
| Réseau | `network.c` | `network.h` | Socket, bind, listen, accept |
| Client | `client_handler.c` | `client_handler.h` | 1 thread par client |
| Cartes | `carte.c` | `carte.h` | create, recommend, repudiate |
| Battles | `battle.c` | `battle.h` | launch, vote, apply_result |
| Légitimation | `legitimation.c` | `legitimation.h` | request, claim, authenticate |
| Blockchain | `blockchain.c` | `blockchain.h` | Blocs, SHA-256, PoW |
| Base de données | `db.c` | `db.h` | Connexion PostgreSQL |
| Protocole | `protocol.c` | `protocol.h` | Parse JSON, réponse JSON |
| Utilitaires | `utils.c` | `utils.h` | Fonctions communes |

### 3.3 Modèle de concurrence

Le serveur utilise un modèle **multithread (pthreads)** plutôt qu'un modèle multiprocessus (`fork`).

**Justification :**

- besoin de partager en mémoire la blockchain et les listes de cartes ;
- les threads d'un même processus partagent naturellement le même espace mémoire ;
- évite la complexité de la mémoire partagée inter-processus.

### 3.4 Boucle principale

1. Création du socket
2. `bind()` sur l'adresse IP et le port
3. `listen()` pour écouter
4. Restauration du contexte depuis PostgreSQL
5. Boucle `accept()` pour accepter les clients
6. Création d'un thread par client (`pthread_create`)
7. Le serveur retourne immédiatement à `accept()`

### 3.5 Traitement non bloquant

Chaque thread client est indépendant :

- un calcul long (minage) ne bloque pas les autres clients ;
- la boucle principale accepte rapidement les nouvelles connexions ;
- le serveur reste réactif.

### 3.6 Limite de connexions

- `MAX_CLIENTS = 10` clients simultanés.
- Au-delà, la connexion est acceptée puis rejetée avec un message d'erreur.
- Message : `{"status":"ERROR","code":"SERVER_BUSY"}`

### 3.7 Synchronisation

Les structures partagées sont protégées par des mutex :

| Structure | Mutex | Protection |
| --- | --- | --- |
| Liste cartes | `mutex_cartes` | Lecture/écriture |
| Liste utilisateurs | `mutex_utilisateurs` | Lecture/écriture |
| Liste battles | `mutex_battles` | Lecture/écriture |
| Blockchain | `mutex_blockchain` | Minage + ajout |

**Principe :** toute section critique est encadrée par `pthread_mutex_lock()` / `pthread_mutex_unlock()`.

---

## 4. Architecture des clients

Voir le document complet : [`client/architecture-client.md`](client/architecture-client.md)

### 4.1 Vue d'ensemble

Le client Java est structuré en 5 couches.

![Architecture client](src/diagrammes-client/00-architecture-client.png)

### 4.2 Rôle de chaque couche

| Couche | Technologie | Rôle | Contrainte |
| --- | --- | --- | --- |
| 1 - Vue | JavaFX, FXML, CSS | Afficher les écrans, capturer les clics | Aucune logique métier |
| 2 - Contrôleurs | Java, JavaFX | Lire les champs, appeler `NetworkClient`, MAJ UI | Utiliser `Platform.runLater()` |
| 3 - Réseau | `java.net.Socket` | Ouvrir le socket, envoyer, écouter | Thread séparé pour `listenLoop` |
| 4 - Modèle | POJO Java | Représenter les données | Sérialisables en JSON |
| 5 - Sérialisation | Gson | Convertir objet Java ↔ JSON | Noms de champs identiques |

### 4.3 Liste des fichiers FXML

| Fichier | Écran | Contrôleur |
| --- | --- | --- |
| `login.fxml` | Connexion | `LoginController` |
| `main.fxml` | Fenêtre principale | `MainController` |
| `cards.fxml` | Onglet Cartes | `CardController` |
| `card_view.fxml` | Composant carte | `CardViewController` |
| `create_card.fxml` | Dialog création | `CreateCardController` |
| `my_cards.fxml` | Mes cartes | `CardController` |
| `recommendations.fxml` | Recommandations | `RecommendationController` |
| `battles.fxml` | Battles | `BattleController` |
| `profile.fxml` | Profil | `ProfileController` |

---

## 5. Organisation des données côté serveur

Voir le document complet : [`serveur/donnees-serveur.md`](serveur/donnees-serveur.md)

### 5.1 Structures C

```c
typedef struct {
    int id;
    char title[100];
    char paradigm[30];
    char description[500];
    char typing[20];
    char difficulty[20];
    int year_created;
    char image_url[500];
    int creator_id;
    int owner_id;
    char status[20];
    int value;
    int is_authenticated;
    int win_count;
    long created_at;
} Carte;

typedef struct {
    int id;
    char username[50];
    int socket_fd;
    pthread_t thread_id;
    int connected;
    int reco_count;
    int legitimacy_count;
} Utilisateur;

typedef struct {
    int id;
    int user_id;
    int card_id;
    int active;
    long timestamp;
} Recommandation;

typedef struct {
    int id;
    int card_id;
    int card2_id;
    int winner_id;
    int status;
    int card1_votes;
    int card2_votes;
    long started_at;
    long ended_at;
} Battle;

typedef struct {
    int id;
    int battle_id;
    int user_id;
    int card_id;
    int weight;
} Vote;

typedef struct {
    int id;
    int card_id;
    int user_id;
    int type;   /* 0=legitimation, 1=revendication, 2=authentification */
    int status; /* 0=en attente, 1=acceptee, 2=refusee */
    long requested_at;
    long granted_at;
} ActionCarte;
```

### 5.2 Conteneurs globaux

```c
Carte *liste_cartes = NULL;
int nb_cartes = 0;

Utilisateur *liste_utilisateurs = NULL;
int nb_utilisateurs = 0;

Battle *liste_battles = NULL;
int nb_battles = 0;

Blockchain blockchain;
```

### 5.3 Lien avec la blockchain

Les structures en mémoire sont **dérivées** de la blockchain :

- jamais source de vérité définitive ;
- reconstruction optimisée pour un accès rapide ;
- toute modification validée → d'abord dans un bloc, puis en mémoire.

---

## 6. Organisation des données côté client

Voir le document complet : [`client/donnees-client.md`](client/donnees-client.md)

### 6.1 Vue d'ensemble

| Catégorie | Classes | Rôle |
| --- | --- | --- |
| Modèle métier | `Card`, `User`, `Recommendation`, `Battle`, `Vote`, `Legitimacy`, `Notification` | Représenter les objets |
| Communication | `Request`, `Response` | Encapsuler les messages JSON |
| Réseau | `NetworkClient` | Gérer le socket TCP |

### 6.2 Classe Card

| Champ | Type | Description |
| --- | --- | --- |
| `id` | String | Identifiant (`c_001`) |
| `title` | String | Nom du langage |
| `paradigm` | String | `OBJECT`, `FUNCTIONAL`, `MULTI`… |
| `description` | String | Description |
| `typing` | String | `STATIC`, `DYNAMIC`… |
| `difficulty` | String | `BEGINNER`, `INTERMEDIATE`… |
| `yearCreated` | int | Année de création |
| `imageUrl` | String | URL du logo |
| `creator` | String | Créateur (`u_001`) |
| `owner` | String | Propriétaire courant |
| `status` | String | `ACTIVE` ou `INACTIVE` |
| `value` | int | Nombre de recos (VA) |
| `isAuthenticated` | boolean | Authentifiée ? |
| `authenticatedBy` | String | Qui a authentifié |
| `authenticatedAt` | String | Quand |
| `winCount` | int | Victoires en battle |
| `isLegitimate` | boolean | Propriétaire légitime ? |
| `stakeVA` | int | VA engagée |
| `createdAt` | String | Date (ISO 8601) |

### 6.3 Stockage côté client

Le client ne stocke rien de manière permanente :

- données en mémoire (`ObservableList` JavaFX) ;
- rechargement à chaque connexion (`CONTEXT_RESTORED`) ;
- aucun accès à la base de données.

---

## 7. Schéma relationnel de la base de données

Voir le document complet : [`blockchain-bdd/schema-bdd.md`](blockchain-bdd/schema-bdd.md)

### 7.1 Vue d'ensemble

La base PostgreSQL contient **7 tables** :

1. `users`
2. `cards`
3. `recommendations`
4. `battles`
5. `votes`
6. `legitimacies`
7. `blocks`

### 7.2 Table `users`

| Champ | Type | Contrainte |
| --- | --- | --- |
| `id` | SERIAL | PRIMARY KEY |
| `username` | VARCHAR(50) | UNIQUE, NOT NULL |
| `is_bot` | BOOLEAN | DEFAULT FALSE |
| `reco_count` | INT | DEFAULT 0 |
| `legitimacy_count` | INT | DEFAULT 0 |
| `created_at` | TIMESTAMP | DEFAULT NOW() |

### 7.3 Table `cards`

| Champ | Type | Contrainte |
| --- | --- | --- |
| `id` | SERIAL | PRIMARY KEY |
| `title` | VARCHAR(100) | NOT NULL |
| `paradigm` | VARCHAR(30) | NOT NULL |
| `description` | TEXT | |
| `typing` | VARCHAR(20) | |
| `difficulty` | VARCHAR(20) | |
| `year_created` | INT | |
| `image_url` | VARCHAR(500) | |
| `creator_id` | INT | REFERENCES users(id) |
| `owner_id` | INT | REFERENCES users(id) |
| `status` | VARCHAR(20) | DEFAULT 'ACTIVE' |
| `value` | INT | DEFAULT 0 |
| `is_authenticated` | BOOLEAN | DEFAULT FALSE |
| `authenticated_by` | INT | REFERENCES users(id) |
| `win_count` | INT | DEFAULT 0 |
| `is_legitimate` | BOOLEAN | DEFAULT FALSE |
| `stake_va` | INT | DEFAULT 0 |
| `created_at` | TIMESTAMP | DEFAULT NOW() |

### 7.4 Table `recommendations`

| Champ | Type | Contrainte |
| --- | --- | --- |
| `id` | SERIAL | PRIMARY KEY |
| `card_id` | INT | REFERENCES cards(id) |
| `user_id` | INT | REFERENCES users(id) |
| `active` | BOOLEAN | DEFAULT TRUE |
| `created_at` | TIMESTAMP | DEFAULT NOW() |

### 7.5 Table `battles`

| Champ | Type | Contrainte |
| --- | --- | --- |
| `id` | SERIAL | PRIMARY KEY |
| `card1_id` | INT | REFERENCES cards(id) |
| `card2_id` | INT | REFERENCES cards(id) |
| `winner_id` | INT | |
| `status` | VARCHAR(20) | |
| `started_at` | TIMESTAMP | |
| `ended_at` | TIMESTAMP | |

### 7.6 Table `votes`

| Champ | Type | Contrainte |
| --- | --- | --- |
| `id` | SERIAL | PRIMARY KEY |
| `battle_id` | INT | REFERENCES battles(id) |
| `user_id` | INT | REFERENCES users(id) |
| `card_id` | INT | REFERENCES cards(id) |
| `weight` | INT | DEFAULT 1 |
| `signature` | VARCHAR(256) | |
| `voted_at` | TIMESTAMP | DEFAULT NOW() |

### 7.7 Table `legitimacies`

| Champ | Type | Contrainte |
| --- | --- | --- |
| `id` | SERIAL | PRIMARY KEY |
| `card_id` | INT | REFERENCES cards(id) |
| `user_id` | INT | REFERENCES users(id) |
| `status` | VARCHAR(20) | |
| `requested_at` | TIMESTAMP | |
| `granted_at` | TIMESTAMP | |

### 7.8 Table `blocks`

| Champ | Type | Contrainte |
| --- | --- | --- |
| `id` | SERIAL | PRIMARY KEY |
| `timestamp` | BIGINT | NOT NULL |
| `data` | JSONB | NOT NULL |
| `prev_hash` | CHAR(64) | |
| `nonce` | BIGINT | |
| `hash` | CHAR(64) | |
| `created_at` | TIMESTAMP | DEFAULT NOW() |

---

## 8. Structures de données de la blockchain

Voir le document complet : [`blockchain-bdd/structures-blockchain.md`](blockchain-bdd/structures-blockchain.md)

### 8.1 Structure d'un bloc

```c
typedef struct {
    int id;
    long timestamp;
    char data[1024];
    char prev_hash[65];
    int nonce;
    char hash[65];
} Block;
```

| Champ | Type | Description |
| --- | --- | --- |
| `id` | int | Identifiant unique |
| `timestamp` | long | Date de création (epoch) |
| `data` | char[1024] | Données de l'action (JSON) |
| `prev_hash` | char[65] | Hash du bloc précédent |
| `nonce` | int | Preuve de travail |
| `hash` | char[65] | Hash courant |

### 8.2 Bloc genesis

- `id = 0`
- `prev_hash` = 64 zéros (`"0000…0000"`)
- `nonce = 0`
- `data = "GENESIS"`
- `hash = SHA-256(data + prev_hash + nonce)`

### 8.3 Calcul du hash

```
hash = SHA-256(data + prev_hash + nonce)
```

- Algorithme : SHA-256
- Sortie : 64 caractères hexadécimaux

### 8.4 Preuve de travail (PoW)

Le minage consiste à faire varier le nonce jusqu'à obtenir un hash respectant un motif.

- Motif : N zéros au début du hash
- Difficulté : 3 ou 4

Exemple pour difficulté = 3 :

- `000abc123...` → valide
- `00abc1234...` → invalide

### 8.5 Vérification de la cohérence

La fonction `verify_blockchain()` contrôle :

| # | Contrôle | Description |
| --- | --- | --- |
| 1 | Validité du hash | `hash == SHA-256(data + prev_hash + nonce)` |
| 2 | Cohérence du `prev_hash` | `block[i].prev_hash == block[i-1].hash` |
| 3 | Preuve de travail | Le hash commence par N zéros |
| 4 | Détection de modification | Si un champ est modifié, le hash change |

---

## 9. Données associées

Voir le document complet : [`commun/regles-metier.md`](commun/regles-metier.md)

### 9.1 Carte (langage)

| Donnée | Type | Règle |
| --- | --- | --- |
| `id` | String | Généré serveur |
| `title` | String | 1-100 caractères |
| `paradigm` | Enum | `OBJECT`, `FUNCTIONAL`, `MULTI`… |
| `description` | String | 1-500 caractères |
| `typing` | Enum | `STATIC`, `DYNAMIC`… |
| `difficulty` | Enum | `BEGINNER`, `INTERMEDIATE`… |
| `yearCreated` | int | 1950-2030 |
| `imageUrl` | String | URL valide |
| `creator` | String | `u_XXX` |
| `owner` | String | `u_XXX` |
| `status` | Enum | `ACTIVE`, `INACTIVE` |
| `value` | int | Nombre de recos |
| `isAuthenticated` | boolean | `false` par défaut |
| `winCount` | int | 0 par défaut |
| `isLegitimate` | boolean | `false` par défaut |
| `stakeVA` | int | 0 par défaut |
| `createdAt` | String | ISO 8601 |

### 9.2 Recommandation

| Donnée | Type | Règle |
| --- | --- | --- |
| `cardId` | String | `c_XXX` |
| `userId` | String | `u_XXX` |
| `date` | String | ISO 8601 |
| `active` | boolean | `true` |

**Impact :** +1 VA sur la carte.

### 9.3 Battle

| Donnée | Type | Règle |
| --- | --- | --- |
| `id` | String | `b_XXX` |
| `card1Id` | String | `c_XXX` |
| `card2Id` | String | `c_XXX` |
| `card1Votes` | int | Poids cumulés |
| `card2Votes` | int | Poids cumulés |
| `duration` | int | 60 secondes |
| `status` | String | `EN_COURS`, `TERMINEE` |
| `winnerId` | String | `c_XXX` |

### 9.4 Vote

| Donnée | Type | Règle |
| --- | --- | --- |
| `battleId` | String | `b_XXX` |
| `userId` | String | `u_XXX` |
| `cardId` | String | `c_XXX` |
| `weight` | int | Nb recos émises (min 1) |
| `signature` | String | SHA-256 |
| `votedAt` | String | ISO 8601 |

### 9.5 Légitimation

| Donnée | Type | Règle |
| --- | --- | --- |
| `id` | String | `l_XXX` |
| `cardId` | String | `c_XXX` |
| `userId` | String | `u_XXX` |
| `status` | String | `PENDING`, `GRANTED`, `REJECTED` |
| `requestedAt` | String | ISO 8601 |
| `grantedAt` | String | ISO 8601 |

### 9.6 Revendication

| Donnée | Type | Règle |
| --- | --- | --- |
| `id` | String | `l_XXX` |
| `cardId` | String | `c_XXX` |
| `userId` | String | `u_XXX` |
| `status` | String | `PENDING`, `GRANTED`, `REJECTED` |
| `requestedAt` | String | ISO 8601 |

### 9.7 Authentification

| Donnée | Type | Règle |
| --- | --- | --- |
| `cardId` | String | `c_XXX` |
| `authenticatedBy` | String | `u_XXX` |
| `authenticatedAt` | String | ISO 8601 |

**Impact :** +10 VA + statut `AUTHENTIFIED`.

---

## 10. Règles métier

Voir le document complet : [`commun/regles-metier.md`](commun/regles-metier.md)

### 10.1 Valeur d'une carte (VA)

| Action | Impact |
| --- | --- |
| 1 reco active | +1 VA |
| 1 authentification | +10 VA |
| Victoire en battle | +50 % des recos du perdant |
| Défaite en battle | −50 % des recos |

**Formule :**

```
VA = nb_recos_actives + (10 × auth) + transfers_battle
```

### 10.2 Valeur d'un utilisateur

```
VA(user) = Σ VA(cartes possédées)
```

### 10.3 Critère de proximité (battle)

Deux cartes peuvent se battre si elles ont le **même `paradigm`**.

### 10.4 Légitimation

| Condition | Détail |
| --- | --- |
| Seuil | 5 recos valides |
| Alternative | Validation du créateur |
| Droits | Authentifier + Revendiquer |

### 10.5 Battle

| Règle | Valeur |
| --- | --- |
| Nombre de cartes | 2 |
| Statut | `ACTIVE` |
| Paradigme | Identique |
| VA minimum | 5 |
| Durée | 60 secondes |
| Vote | 1 par utilisateur |
| Pondération | Nb recos (min 1) |
| Égalité | VA la plus élevée l'emporte |
| Transfert | 50 % des recos |
| Carte perdante | `INACTIVE` si VA = 0 |

### 10.6 Authentification

| Règle | Valeur |
| --- | --- |
| Acteur | Utilisateur légitime |
| Impact | +10 VA |
| Statut | `AUTHENTIFIED` |
| Effet | Verrouillage |

### 10.7 Revendication

| Règle | Valeur |
| --- | --- |
| Demandeur | Légitime |
| Cible | Non-légitime |
| Délai | 10 blocs |

### 10.8 Cycle de vie

```
[*] → CREATE_CARD → ACTIVE
ACTIVE → RECOMMEND → ACTIVE
ACTIVE → AUTHENTICATE → AUTHENTIFIED
ACTIVE → START_BATTLE → IN_BATTLE
IN_BATTLE → VICTOIRE → ACTIVE
IN_BATTLE → DÉFAITE → INACTIVE (si VA = 0)
INACTIVE → RÉACTIVATION → ACTIVE
```

---

## 11. Diagrammes de séquence

Voir les annexes : [Annexe D — Séquences](annexes/annexe-d-sequences.md)

### 11.1 Scénarios principaux

| # | Scénario | Diagramme |
| --- | --- | --- |
| 1 | LOGIN | `src/diagrammes-serveur/03-sequence-login-serveur.png` |
| 2 | CREATE_CARD | `src/diagrammes-serveur/04-sequence-create-card-serveur.png` |
| 3 | RECOMMEND | `src/diagrammes-serveur/05-sequence-recommend-serveur.png` |
| 4 | BATTLE | `src/diagrammes-serveur/07-sequence-battle-serveur.png` |
| 5 | LÉGITIMATION | `src/diagrammes-serveur/10-sequence-legitimation-serveur.png` |
| 6 | AUTHENTIFICATION | `src/diagrammes-serveur/11-sequence-authentification-serveur.png` |
| 7 | REVENDICATION | `src/diagrammes-client/11-sequence-revendication.png` |
| 8 | DISCONNECT | `src/diagrammes-serveur/12-sequence-disconnect-serveur.png` |

---

## 12. Protocole applicatif

Voir le document complet : [`commun/protocole-applicatif-commun.md`](commun/protocole-applicatif-commun.md)

### 12.1 Format général

| Élément | Valeur |
| --- | --- |
| Format | JSON |
| Encodage | UTF-8 |
| Délimiteur | `\n` |
| Transport | Socket TCP |

### 12.2 Structure des messages

**Requête :**

```json
{"action":"LOGIN","payload":{"username":"usman"}}
```

**Réponse OK :**

```json
{"status":"OK","action":"LOGIN_SUCCESS","data":{"userId":"u_001"}}
```

**Réponse ERROR :**

```json
{"status":"ERROR","code":"USERNAME_TAKEN","message":"Ce pseudo est deja utilise."}
```

**Notification :**

```json
{"status":"NOTIFY","action":"CARD_UPDATED","data":{"cardId":"c_001","value":13}}
```

### 12.3 Liste des actions

| # | Action | Description |
| --- | --- | --- |
| 1 | `LOGIN` | Connexion |
| 2 | `GET_CONTEXT` | Récupérer le contexte |
| 3 | `CREATE_CARD` | Créer une carte |
| 4 | `RECOMMEND` | Recommander |
| 5 | `REPUDIATE` | Répudier |
| 6 | `START_BATTLE` | Lancer une battle |
| 7 | `VOTE_BATTLE` | Voter |
| 8 | `REQUEST_LEGITIMACY` | Demander la légitimation |
| 9 | `CLAIM_CARD` | Revendiquer |
| 10 | `AUTHENTICATE_CARD` | Authentifier |
| 11 | `DISCONNECT` | Déconnexion |

### 12.4 Notifications push

| # | Action | Quand |
| --- | --- | --- |
| 1 | `USER_CONNECTED` | Connexion |
| 2 | `USER_DISCONNECTED` | Déconnexion |
| 3 | `NEW_CARD` | Nouvelle carte |
| 4 | `CARD_UPDATED` | VA modifiée |
| 5 | `NEW_BATTLE` | Battle lancée |
| 6 | `BATTLE_UPDATE` | Vote enregistré |
| 7 | `BATTLE_RESULT` | Battle terminée |
| 8 | `LEGITIMACY_GRANTED` | Légitimation accordée |
| 9 | `NEW_NOTIFICATION` | Notification |

### 12.5 Points techniques

| Point | Valeur |
| --- | --- |
| Timeout connexion | 5 secondes |
| Timeout lecture | 10 secondes |
| Max clients | 10 |
| Encodage | UTF-8 |
| Délimiteur | `\n` |
| Taille max message | 4096 octets |

---

## 13. Cas d'erreur

Voir le document complet : [`commun/cas-erreur.md`](commun/cas-erreur.md)

### 13.1 Format standard

```json
{"status":"ERROR","code":"USERNAME_TAKEN","message":"Ce pseudo est deja utilise."}
```

### 13.2 Liste complète

| # | Code | Signification | Actions concernées |
| --- | --- | --- | --- |
| 1 | `INVALID_DATA` | Champs invalides | Toutes |
| 2 | `USERNAME_TAKEN` | Pseudo déjà pris | LOGIN |
| 3 | `CARD_NOT_FOUND` | Carte inexistante | RECOMMEND, REPUDIATE, START_BATTLE, VOTE_BATTLE, REQUEST_LEGITIMACY, CLAIM_CARD, AUTHENTICATE_CARD |
| 4 | `CARD_NOT_ACTIVE` | Carte inactive | RECOMMEND, START_BATTLE |
| 5 | `DUPLICATE_CARD` | Carte existante | CREATE_CARD |
| 6 | `ALREADY_RECOMMENDED` | Déjà recommandée | RECOMMEND |
| 7 | `NOT_RECOMMENDED` | Rien à répudier | REPUDIATE |
| 8 | `BATTLE_NOT_FOUND` | Battle inexistante | VOTE_BATTLE |
| 9 | `BATTLE_ALREADY_ACTIVE` | Carte déjà en battle | START_BATTLE |
| 10 | `ALREADY_VOTED` | Déjà voté | VOTE_BATTLE |
| 11 | `NOT_LEGITIMATE` | Non légitime | CLAIM_CARD, AUTHENTICATE_CARD |
| 12 | `THRESHOLD_NOT_REACHED` | Seuil non atteint | REQUEST_LEGITIMACY |
| 13 | `CARDS_NOT_COMPATIBLE` | Paradigmes différents | START_BATTLE |
| 14 | `VA_TOO_LOW` | VA < 5 | START_BATTLE |
| 15 | `ALREADY_AUTHENTICATED` | Déjà authentifiée | AUTHENTICATE_CARD |
| 16 | `SERVER_BUSY` | Serveur plein | LOGIN |
| 17 | `INTERNAL_ERROR` | Erreur interne | Toutes |

### 13.3 Gestion côté serveur

Quand une action échoue, le serveur :

1. n'ajoute **pas** de bloc à la blockchain ;
2. n'écrit **pas** en base de données ;
3. renvoie un message d'erreur au client ;
4. garde les structures en mémoire intactes.

### 13.4 Gestion côté client

Toutes les erreurs sont affichées dans un label rouge sous le formulaire ou la zone d'action.

```java
statusLabel.setStyle("-fx-text-fill: red;");
statusLabel.setText(resp.getMessage());
```

---

## 14. Conclusion

### 14.1 Récapitulatif

Ce document a présenté la spécification technique complète du projet SAE-Recommender :

- **Architecture serveur** : modulaire, multitâche, avec mutex
- **Architecture client** : 5 couches (Vue, Contrôleur, Réseau, Modèle, Sérialisation)
- **Organisation des données** : côté serveur (C) et côté client (Java)
- **Schéma relationnel** : 7 tables PostgreSQL
- **Blockchain** : structure de bloc, SHA-256, PoW
- **Règles métier** : VA, légitimation, battle, authentification
- **Diagrammes de séquence** : 8 scénarios principaux
- **Protocole applicatif** : JSON + socket TCP
- **Cas d'erreur** : 17 codes serveur + 7 client

### 14.2 Livrables Phase 1

| # | Livrable | Statut |
| --- | --- | --- |
| 1 | Répartition des rôles | ✓ |
| 2 | Architecture du serveur | ✓ |
| 3 | Architecture des clients | ✓ |
| 4 | Organisation des données serveur | ✓ |
| 5 | Organisation des données client | ✓ |
| 6 | Schéma relationnel BDD | ✓ |
| 7 | Structures blockchain | ✓ |
| 8 | Données cartes / recos / battles | ✓ |
| 9 | Règles métier | ✓ |
| 10 | Diagrammes de séquence | ✓ |
| 11 | Protocole applicatif | ✓ |
| 12 | Cas d'erreur | ✓ |




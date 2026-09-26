# Organisation des données côté serveur

**Projet :** SAÉ BUT2 S3 2026-2027
**Thème :** Langages de programmation
**Responsables :** Mai + Albine
**Partie :** Serveur C + Sockets

---

## 📑 Sommaire

1. [Objectif](#1-objectif)
2. [Structures C complètes](#2-structures-c-complètes)
   - [2.1 Structure Carte](#21-structure-carte)
   - [2.2 Structure Utilisateur](#22-structure-utilisateur)
   - [2.3 Structure Recommandation](#23-structure-recommandation)
   - [2.4 Structure Battle](#24-structure-battle)
   - [2.5 Structure Vote](#25-structure-vote)
   - [2.6 Structure ActionCarte](#26-structure-actioncarte)
   - [2.7 Structure Block](#27-structure-block)
   - [2.8 Structure Blockchain](#28-structure-blockchain)
3. [Conteneurs globaux](#3-conteneurs-globaux)
   - [3.1 Liste des cartes](#31-liste-des-cartes)
   - [3.2 Liste des utilisateurs](#32-liste-des-utilisateurs)
   - [3.3 Liste des battles](#33-liste-des-battles)
   - [3.4 Blockchain globale](#34-blockchain-globale)
   - [3.5 Opérations sur les listes](#35-opérations-sur-les-listes)
4. [Synchronisation](#4-synchronisation)
   - [4.1 Mutex](#41-mutex)
   - [4.2 Utilisation](#42-utilisation)
   - [4.3 Règles de synchronisation](#43-règles-de-synchronisation)
5. [Lien avec la blockchain](#5-lien-avec-la-blockchain)
   - [5.1 Principe](#51-principe)
   - [5.2 Ordre des opérations](#52-ordre-des-opérations)
   - [5.3 Exemple concret](#53-exemple-concret)
6. [Lien avec PostgreSQL](#6-lien-avec-postgresql)
   - [6.1 Principe](#61-principe)
   - [6.2 Mapping structures C vers tables SQL](#62-mapping-structures-c-vers-tables-sql)
   - [6.3 Fonctions de connexion](#63-fonctions-de-connexion)
   - [6.4 Structure de la connexion](#64-structure-de-la-connexion)
7. [Prototypes de fonctions](#7-prototypes-de-fonctions)
   - [7.1 Module Carte](#71-module-carte)
   - [7.2 Module Utilisateur](#72-module-utilisateur)
   - [7.3 Module Battle](#73-module-battle)
   - [7.4 Module Legitimation](#74-module-legitimation)
   - [7.5 Module Blockchain](#75-module-blockchain)
   - [7.6 Module BDD](#76-module-bdd)
   - [7.7 Module Protocole](#77-module-protocole)
   - [7.8 Module Réseau](#78-module-réseau)
8. [Gestion des erreurs](#8-gestion-des-erreurs)
   - [8.1 Principe](#81-principe)
   - [8.2 Cas d'erreur par action](#82-cas-derreur-par-action)
   - [8.3 Format des erreurs](#83-format-des-erreurs)
9. [Cycle de vie d'une donnée](#9-cycle-de-vie-dune-donnée)
   - [9.1 Création](#91-création)
   - [9.2 Modification](#92-modification)
   - [9.3 Suppression (inactivation)](#93-suppression-inactivation)
   - [9.4 Restauration](#94-restauration)
10. [Récapitulatif](#10-récapitulatif)
11. [Validation](#11-validation)

---

## 1. Objectif

Ce document décrit l'organisation complète des données côté serveur C.

Il présente :

- Les structures C avec leurs types exacts
- Les conteneurs globaux
- La synchronisation (mutex)
- Le lien avec la blockchain
- Le lien avec PostgreSQL (libpq)
- Les prototypes de fonctions
- La gestion des erreurs
- Les cas d'erreur

---

## 2. Structures C complètes

### 2.1 Structure Carte

La structure Carte représente une carte langage.

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
```

**Taille totale :** environ 1200 octets

### 2.2 Structure Utilisateur

La structure Utilisateur représente un client connecté.

```c
typedef struct {
    int id;
    char username[50];
    int socket_fd;
    pthread_t thread_id;
    int connected;
    int reco_count;
    int legitimacy_count;
} Utilisateur;
```

**Taille totale :** environ 100 octets

### 2.3 Structure Recommandation

La structure Recommandation représente une recommandation.

```c
typedef struct {
    int id;
    int user_id;
    int card_id;
    int active;
    long timestamp;
} Recommandation;
```

**Taille totale :** environ 20 octets

### 2.4 Structure Battle

La structure Battle représente une battle.

```c
typedef struct {
    int id;
    int card1_id;
    int card2_id;
    int winner_id;
    int status;
    int card1_votes;
    int card2_votes;
    long started_at;
    long ended_at;
} Battle;
```

**Taille totale :** environ 40 octets

### 2.5 Structure Vote

La structure Vote représente un vote dans une battle.

```c
typedef struct {
    int id;
    int battle_id;
    int user_id;
    int card_id;
    int weight;
} Vote;
```

**Taille totale :** environ 20 octets

### 2.6 Structure ActionCarte

La structure ActionCarte représente une légitimation, revendication ou authentification.

```c
typedef struct {
    int id;
    int card_id;
    int user_id;
    int type;
    int status;
    long requested_at;
    long granted_at;
} ActionCarte;
```

**Taille totale :** environ 30 octets

### 2.7 Structure Block

La structure Block représente un bloc de la blockchain.

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

**Taille totale :** environ 1200 octets

### 2.8 Structure Blockchain

La structure Blockchain représente la blockchain complète.

```c
typedef struct {
    Block *blocks;
    int size;
    int capacity;
    int difficulty;
    pthread_mutex_t mutex;
} Blockchain;
```

**Taille totale :** environ 50 octets

---

## 3. Conteneurs globaux

### 3.1 Liste des cartes

```c
Carte *liste_cartes = NULL;
int nb_cartes = 0;
int capacite_cartes = 0;
```

### 3.2 Liste des utilisateurs

```c
Utilisateur *liste_utilisateurs = NULL;
int nb_utilisateurs = 0;
int capacite_utilisateurs = 0;
```

### 3.3 Liste des battles

```c
Battle *liste_battles = NULL;
int nb_battles = 0;
int capacite_battles = 0;
```

### 3.4 Blockchain globale

```c
Blockchain blockchain;
```

### 3.5 Opérations sur les listes

```c
int add_carte(Carte *carte);
int add_utilisateur(Utilisateur *user);
int add_battle(Battle *battle);

Carte* find_carte(int card_id);
Utilisateur* find_utilisateur(int user_id);
Battle* find_battle(int battle_id);

int remove_utilisateur(int user_id);
int remove_battle(int battle_id);
```

---

## 4. Synchronisation

### 4.1 Mutex

Trois mutex protègent les listes.

```c
pthread_mutex_t mutex_cartes = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex_utilisateurs = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex_battles = PTHREAD_MUTEX_INITIALIZER;
```

La blockchain a son propre mutex.

```c
pthread_mutex_t mutex_blockchain = PTHREAD_MUTEX_INITIALIZER;
```

### 4.2 Utilisation

Chaque section critique utilise pthread_mutex_lock et pthread_mutex_unlock.

```c
pthread_mutex_lock(&mutex_cartes);
/* Section critique */
pthread_mutex_unlock(&mutex_cartes);
```

### 4.3 Règles de synchronisation

- Un thread ne doit jamais bloquer plus longtemps que nécessaire.
- Un thread ne doit jamais acquérir deux mutex en même temps.
- Toujours libérer le mutex après utilisation.

---

## 5. Lien avec la blockchain

### 5.1 Principe

Les structures en mémoire sont dérivées de la blockchain.

Toute modification validée est d'abord écrite dans un bloc, puis répercutée en mémoire.

### 5.2 Ordre des opérations

1. Le serveur mine un nouveau bloc
2. Le bloc est ajouté à la blockchain
3. Le bloc est sauvegardé en base de données
4. La structure en mémoire est mise à jour

### 5.3 Exemple concret

```c
/* 1. Mine un bloc */
Block block;
block.id = blockchain.size;
block.timestamp = time(NULL);
snprintf(block.data, sizeof(block.data), "ACTION_RECOMMEND|%d|%d", user_id, card_id);
mine_block(&block);

/* 2. Ajoute a la blockchain */
pthread_mutex_lock(&mutex_blockchain);
add_block(&blockchain, &block);
pthread_mutex_unlock(&mutex_blockchain);

/* 3. Sauvegarde en BDD */
save_block_to_db(&block);

/* 4. Met a jour la memoire */
pthread_mutex_lock(&mutex_cartes);
Carte *carte = find_carte(card_id);
carte->value = carte->value + 1;
pthread_mutex_unlock(&mutex_cartes);
```

---

## 6. Lien avec PostgreSQL

### 6.1 Principe

Les blocs sont sauvegardés dans la table `blocks`.

Les données courantes sont sauvegardées dans les tables `cards`, `users`, `battles`, `votes`, `legitimacies`.

### 6.2 Mapping structures C vers tables SQL

| Structure C | Table SQL | Colonnes principales |
|-------------|-----------|----------------------|
| Carte | cards | id, title, paradigm, description, typing, difficulty, year_created, image_url, creator_id, owner_id, status, value, is_authenticated, win_count, created_at |
| Utilisateur | users | id, username, is_bot, reco_count, legitimacy_count, created_at |
| Recommandation | recommendations | id, card_id, user_id, active, created_at |
| Battle | battles | id, card1_id, card2_id, winner_id, status, started_at, ended_at |
| Vote | votes | id, battle_id, user_id, card_id, weight, signature, voted_at |
| ActionCarte | legitimacies | id, card_id, user_id, status, requested_at, granted_at |
| Block | blocks | id, timestamp, data, prev_hash, nonce, hash, created_at |

### 6.3 Fonctions de connexion

```c
int db_connect();
void db_disconnect();
int db_save_block(Block *block);
int db_load_blocks(Block **blocks, int *count);
int db_save_card(Carte *card);
int db_update_card_value(int card_id, int new_value);
int db_save_user(Utilisateur *user);
int db_save_recommendation(Recommandation *reco);
int db_save_battle(Battle *battle);
int db_save_vote(Vote *vote);
```

### 6.4 Structure de la connexion

```c
static PGconn *conn = NULL;
```

---

## 7. Prototypes de fonctions

### 7.1 Module Carte

```c
int create_card(char *title, char *paradigm, char *description,
                char *typing, char *difficulty, int year_created,
                char *image_url, int creator_id);
int recommend_card(int user_id, int card_id);
int repudiate_recommendation(int user_id, int card_id);
Carte* find_carte(int card_id);
int update_card_status(int card_id, char *status);
```

### 7.2 Module Utilisateur

```c
int create_user(char *username, int socket_fd);
Utilisateur* find_utilisateur(int user_id);
Utilisateur* find_utilisateur_by_username(char *username);
int remove_utilisateur(int user_id);
```

### 7.3 Module Battle

```c
int launch_battle(int card1_id, int card2_id);
int vote_battle(int user_id, int battle_id, int card_id);
int apply_battle_result(int battle_id);
Battle* find_battle(int battle_id);
```

### 7.4 Module Legitimation

```c
int request_legitimation(int user_id, int card_id);
int claim_card(int user_id, int card_id);
int authenticate_card(int user_id, int card_id);
```

### 7.5 Module Blockchain

```c
int blockchain_init(int difficulty);
int mine_block(Block *block);
int add_block(Blockchain *bc, Block *block);
int verify_chain();
char* compute_hash(Block *block);
Block* get_last_block();
```

### 7.6 Module BDD

```c
int db_connect();
void db_disconnect();
int db_save_block(Block *block);
int db_load_blocks(Block **blocks, int *count);
int db_save_card(Carte *card);
int db_update_card_value(int card_id, int new_value);
```

### 7.7 Module Protocole

```c
char* parse_json_request(char *buffer);
char* create_json_response(char *status, char *action, char *data);
char* create_json_error(char *code, char *message);
```

### 7.8 Module Réseau

```c
int network_init(int port);
int network_accept(int server_fd);
void network_close(int fd);
void* client_thread(void *arg);
```

---

## 8. Gestion des erreurs

### 8.1 Principe

Quand une action échoue, le serveur :

1. N'ajoute PAS de bloc à la blockchain
2. N'écrit PAS en base de données
3. Renvoie un message d'erreur au client
4. Garde les structures en mémoire intactes

### 8.2 Cas d'erreur par action

**LOGIN :** USERNAME_TAKEN, SERVER_BUSY, INVALID_DATA

**CREATE_CARD :** INVALID_DATA, DUPLICATE_CARD, INTERNAL_ERROR

**RECOMMEND :** CARD_NOT_FOUND, CARD_NOT_ACTIVE, ALREADY_RECOMMENDED

**REPUDIATE :** CARD_NOT_FOUND, NOT_RECOMMENDED

**START_BATTLE :** CARD_NOT_FOUND, CARD_NOT_ACTIVE, CARDS_NOT_COMPATIBLE, VA_TOO_LOW, BATTLE_ALREADY_ACTIVE

**VOTE_BATTLE :** BATTLE_NOT_FOUND, ALREADY_VOTED, NOT_ALLOWED

**REQUEST_LEGITIMACY :** CARD_NOT_FOUND, THRESHOLD_NOT_REACHED

**CLAIM_CARD :** CARD_NOT_FOUND, NOT_LEGITIMATE

**AUTHENTICATE_CARD :** CARD_NOT_FOUND, NOT_LEGITIMATE, ALREADY_AUTHENTICATED

### 8.3 Format des erreurs

```json
{
  "status": "ERROR",
  "code": "CARD_NOT_FOUND",
  "message": "Carte introuvable."
}
```

---

## 9. Cycle de vie d'une donnée

### 9.1 Création

L'utilisateur envoie une requête. Le serveur valide. Le serveur mine un bloc. Le serveur sauvegarde. Le serveur met à jour la mémoire.

### 9.2 Modification

L'utilisateur envoie une requête. Le serveur valide. Le serveur mine un bloc. Le serveur met à jour la BDD. Le serveur met à jour la mémoire.

### 9.3 Suppression (inactivation)

L'utilisateur envoie une requête. Le serveur valide. Le serveur mine un bloc. Le serveur change le statut en INACTIVE. La donnée reste dans la BDD.

### 9.4 Restauration

Au démarrage du serveur :

1. Connexion à PostgreSQL
2. Chargement des blocs depuis la table `blocks`
3. Reconstruction de la blockchain en mémoire
4. Reconstruction des listes cartes, utilisateurs, battles

---

## 10. Récapitulatif

| Structure | Champs | Taille | Utilisation |
|-----------|--------|--------|-------------|
| Carte | 15 | ~1200 octets | Cartes langages |
| Utilisateur | 7 | ~100 octets | Clients connectés |
| Recommandation | 5 | ~20 octets | Recommandations |
| Battle | 9 | ~40 octets | Battles |
| Vote | 5 | ~20 octets | Votes |
| ActionCarte | 7 | ~30 octets | Légitimations, revendications, authentifications |
| Block | 6 | ~1200 octets | Blocs blockchain |
| Blockchain | 5 | ~50 octets | Chaîne complète |

---

## 11. Validation

| Rôle | Nom | Statut |
|------|-----|--------|
| Serveur C | Mai | En attente |
| Serveur C | Albine | En attente |
| Blockchain + BDD | Iyore | En attente |

---


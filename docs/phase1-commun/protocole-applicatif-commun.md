# 📡 Protocole applicatif complet — SAE-Recommender

**Version :** Définitive et exhaustive
**Projet :** SAÉ BUT2 S3 2026-2027
**Thème :** Langages de programmation

---

## 📑 Sommaire

1. [Vue d'ensemble](#1-vue-densemble)
2. [Règles de nommage](#2-règles-de-nommage)
3. [Structure des messages](#3-structure-des-messages)
4. [Objets JSON complets](#4-objets-json-complets)
5. [Détail des 11 actions](#5-détail-des-11-actions)
6. [Détail des 9 notifications push](#6-détail-des-9-notifications-push)
7. [Codes d'erreur](#7-codes-derreur)
8. [Points techniques](#8-points-techniques)
9. [Mapping Java ↔ JSON ↔ C ↔ SQL](#9-mapping-java--json--c--sql)
10. [Récapitulatif](#10-récapitulatif)
11. [Validation](#11-validation)

---

# 1. Vue d'ensemble

| Élément                       | Valeur               |
| ----------------------------- | -------------------- |
| **Format**                    | JSON                 |
| **Encodage**                  | UTF-8                |
| **Délimiteur**                | `\n` (saut de ligne) |
| **Transport**                 | Socket TCP           |
| **Bibliothèque Java**         | Gson                 |
| **Bibliothèque C**            | cJSON                |
| **Port par défaut**           | `8080`               |
| **Nombre maximal de clients** | `10`                 |

Chaque message est une **ligne JSON** terminée par `\n`.

---

# 2. Règles de nommage

> ⚠️ **Ces règles sont critiques pour assurer la compatibilité entre Java, JSON, C et SQL.**

## 2.1 JSON et Java : camelCase

```json
{
  "cardId": "c_001",
  "isAuthenticated": true
}
```

```java
private String cardId;
private boolean isAuthenticated;
```

---

## 2.2 C et SQL : snake_case

```c
char card_id[20];
int is_authenticated;
```

```sql
card_id VARCHAR(20);
is_authenticated BOOLEAN;
```

---

## 2.3 cJSON respecte les noms JSON

```c
cJSON_AddStringToObject(root, "cardId", card->id);   // ✅
cJSON_AddStringToObject(root, "card_id", card->id);  // ❌
```

---

## 2.4 Gson utilise les noms Java

```java
private String cardId;   // → "cardId" en JSON ✅
private String card_id;  // → "card_id" en JSON ❌
```

---

# 3. Structure des messages

## 3.1 Requête — Client → Serveur

```json
{
  "action": "LOGIN",
  "payload": {
    "username": "usman"
  }
}
```

| Champ     | Type   | Obligatoire | Description         |
| --------- | ------ | ----------- | ------------------- |
| `action`  | String | ✅           | Nom de l'action     |
| `payload` | Objet  | ✅           | Données de l'action |

---

## 3.2 Réponse succès — Serveur → Client

```json
{
  "status": "OK",
  "action": "LOGIN_SUCCESS",
  "data": {
    "userId": "u_001",
    "username": "usman"
  }
}
```

| Champ    | Type   | Description           |
| -------- | ------ | --------------------- |
| `status` | String | `"OK"`                |
| `action` | String | Nom du résultat       |
| `data`   | Objet  | Données de la réponse |

---

## 3.3 Réponse erreur — Serveur → Client

```json
{
  "status": "ERROR",
  "code": "USERNAME_TAKEN",
  "message": "Ce pseudo est déjà utilisé."
}
```

| Champ     | Type   | Description                       |
| --------- | ------ | --------------------------------- |
| `status`  | String | `"ERROR"`                         |
| `code`    | String | Code d'erreur                     |
| `message` | String | Message lisible par l'utilisateur |

---

## 3.4 Notification push — Serveur → Clients

```json
{
  "status": "NOTIFY",
  "action": "CARD_UPDATED",
  "data": {
    "cardId": "c_001",
    "value": 13
  }
}
```

| Champ    | Type   | Description                |
| -------- | ------ | -------------------------- |
| `status` | String | `"NOTIFY"`                 |
| `action` | String | Type de notification       |
| `data`   | Objet  | Données de la notification |

---

# 4. Objets JSON complets

## 4.1 Objet `Card`

### Exemple complet

```json
{
  "id": "c_001",
  "title": "Python",
  "paradigm": "MULTI",
  "description": "Langage interprété, polyvalent",
  "typing": "DYNAMIC",
  "difficulty": "BEGINNER",
  "yearCreated": 1991,
  "imageUrl": "https://example.com/python.png",
  "creator": "u_001",
  "owner": "u_001",
  "status": "ACTIVE",
  "value": 15,
  "isAuthenticated": false,
  "authenticatedBy": null,
  "authenticatedAt": null,
  "winCount": 0,
  "isLegitimate": false,
  "stakeVA": 0,
  "createdAt": "2026-09-25T11:30:00Z"
}
```

### Champs

| Champ JSON        | Type JSON | Obligatoire | Description                                                         |
| ----------------- | --------- | ----------- | ------------------------------------------------------------------- |
| `id`              | String    | ✅           | Identifiant unique (`c_XXX`)                                        |
| `title`           | String    | ✅           | Nom du langage                                                      |
| `paradigm`        | String    | ✅           | `OBJECT`, `FUNCTIONAL`, `PROCEDURAL`, `LOGIC`, `SCRIPTING`, `MULTI` |
| `description`     | String    | ✅           | Description                                                         |
| `typing`          | String    | ✅           | `STATIC`, `DYNAMIC`, `STRONG`, `WEAK`                               |
| `difficulty`      | String    | ✅           | `BEGINNER`, `INTERMEDIATE`, `ADVANCED`, `EXPERT`                    |
| `yearCreated`     | int       | ❌           | Année de création                                                   |
| `imageUrl`        | String    | ❌           | URL du logo                                                         |
| `creator`         | String    | ✅           | ID du créateur (`u_XXX`)                                            |
| `owner`           | String    | ✅           | ID du propriétaire (`u_XXX`)                                        |
| `status`          | String    | ✅           | `ACTIVE`, `INACTIVE`, `AUTHENTIFIED`                                |
| `value`           | int       | ✅           | Valeur de la carte (VA)                                             |
| `isAuthenticated` | boolean   | ✅           | Carte authentifiée ou non                                           |
| `authenticatedBy` | String    | ❌           | Utilisateur ayant authentifié la carte                              |
| `authenticatedAt` | String    | ❌           | Date d'authentification                                             |
| `winCount`        | int       | ✅           | Nombre de victoires en battle                                       |
| `isLegitimate`    | boolean   | ✅           | Propriétaire légitime ou non                                        |
| `stakeVA`         | int       | ✅           | VA engagée                                                          |
| `createdAt`       | String    | ✅           | Date au format ISO 8601                                             |

---

## 4.2 Objet `User`

```json
{
  "id": "u_001",
  "username": "usman",
  "isBot": false,
  "recoCount": 0,
  "legitimacyCount": 0
}
```

| Champ             | Type    | Description                         |
| ----------------- | ------- | ----------------------------------- |
| `id`              | String  | Identifiant (`u_XXX`)               |
| `username`        | String  | Pseudo                              |
| `isBot`           | boolean | Indique si l'utilisateur est un bot |
| `recoCount`       | int     | Nombre de recommandations émises    |
| `legitimacyCount` | int     | Nombre de légitimations obtenues    |

---

## 4.3 Objet `Recommendation`

```json
{
  "cardId": "c_001",
  "userId": "u_002",
  "date": "2026-09-25T11:30:00Z"
}
```

---

## 4.4 Objet `Battle`

```json
{
  "id": "b_014",
  "card1Id": "c_001",
  "card2Id": "c_005",
  "card1VA": 15,
  "card2VA": 10,
  "card1Votes": 0,
  "card2Votes": 0,
  "duration": 60,
  "endTime": "2026-09-25T11:35:00Z",
  "status": "EN_COURS",
  "winnerId": null
}
```

---

## 4.5 Objet `Vote`

```json
{
  "battleId": "b_014",
  "userId": "u_002",
  "cardId": "c_001",
  "weight": 5,
  "signature": "a1b2c3d4...",
  "votedAt": "2026-09-25T11:32:00Z"
}
```

---

## 4.6 Objet `Legitimacy`

```json
{
  "id": "l_001",
  "cardId": "c_001",
  "userId": "u_002",
  "status": "PENDING",
  "requestedAt": "2026-09-25T11:40:00Z",
  "grantedAt": null
}
```

---

## 4.7 Objet `Notification`

```json
{
  "type": "RECOMMEND",
  "from": "alice",
  "message": "alice a recommandé votre carte Python"
}
```

---

# 5. Détail des 11 actions

## 5.1 `LOGIN`

**Cas du cahier des charges :** 5, 6, 7 (page 4)

### Requête

```json
{
  "action": "LOGIN",
  "payload": {
    "username": "usman"
  }
}
```

### Réponse succès

```json
{
  "status": "OK",
  "action": "LOGIN_SUCCESS",
  "data": {
    "userId": "u_001",
    "username": "usman",
    "connectedUsers": [
      "usman",
      "alice"
    ],
    "recoCount": 0,
    "legitimacyCount": 0
  }
}
```

### Erreurs

* `USERNAME_TAKEN` — Pseudo déjà utilisé
* `SERVER_BUSY` — Serveur plein

> **Note :** après `LOGIN_SUCCESS`, le serveur envoie automatiquement `CONTEXT_RESTORED`.

---

## 5.2 `GET_CONTEXT`
** restaurer tout le contexte d'un utilisateur (cartes, recos, battles, légitimations, notifications) 
**Cas du cahier des charges :** 7, 22 (pages 4 et 6)

### Requête

```json
{
  "action": "GET_CONTEXT",
  "payload": {}
}
```

### Réponse succès

```json
{
  "status": "OK",
  "action": "CONTEXT_RESTORED",
  "data": {
    "myCards": [
      {
        "id": "c_001",
        "title": "Python",
        "paradigm": "MULTI",
        "status": "ACTIVE",
        "value": 15
      }
    ],
    "myRecommendations": [
      {
        "cardId": "c_002",
        "date": "2026-09-24T10:00:00Z"
      }
    ],
    "receivedRecommendations": [
      {
        "cardId": "c_001",
        "userId": "u_002",
        "date": "2026-09-24T11:00:00Z"
      }
    ],
    "activeBattles": [],
    "myLegitimacies": [],
    "myAuthentications": [],
    "notifications": []
  }
}
```

---

## 5.3 `CREATE_CARD`

**Cas du cahier des charges :** 11 (page 5)

### Requête

```json
{
  "action": "CREATE_CARD",
  "payload": {
    "title": "Python",
    "paradigm": "MULTI",
    "description": "Langage interprété, polyvalent",
    "typing": "DYNAMIC",
    "difficulty": "BEGINNER",
    "yearCreated": 1991,
    "imageUrl": "https://example.com/python.png"
  }
}
```

### Contraintes

| Champ         | Type   | Obligatoire | Contraintes                                                         |
| ------------- | ------ | ----------- | ------------------------------------------------------------------- |
| `title`       | String | ✅           | 1–100 caractères                                                    |
| `paradigm`    | String | ✅           | `OBJECT`, `FUNCTIONAL`, `PROCEDURAL`, `LOGIC`, `SCRIPTING`, `MULTI` |
| `description` | String | ✅           | 1–500 caractères                                                    |
| `typing`      | String | ✅           | `STATIC`, `DYNAMIC`, `STRONG`, `WEAK`                               |
| `difficulty`  | String | ✅           | `BEGINNER`, `INTERMEDIATE`, `ADVANCED`, `EXPERT`                    |
| `yearCreated` | int    | ❌           | 1950–2030                                                           |
| `imageUrl`    | String | ❌           | URL valide                                                          |

### Réponse succès

```json
{
  "status": "OK",
  "action": "CARD_CREATED",
  "data": {
    "id": "c_001",
    "title": "Python",
    "paradigm": "MULTI",
    "description": "Langage interprété, polyvalent",
    "typing": "DYNAMIC",
    "difficulty": "BEGINNER",
    "yearCreated": 1991,
    "imageUrl": "https://example.com/python.png",
    "creator": "u_001",
    "owner": "u_001",
    "status": "ACTIVE",
    "value": 0,
    "isAuthenticated": false,
    "winCount": 0,
    "isLegitimate": false,
    "stakeVA": 0,
    "createdAt": "2026-09-25T11:30:00Z"
  }
}
```

### Erreurs

* `INVALID_DATA` — Champs invalides
* `DUPLICATE_CARD` — Carte existante

### Notification push

```json
{
  "status": "NOTIFY",
  "action": "NEW_CARD",
  "data": {
    "cardId": "c_001",
    "title": "Python",
    "creator": "usman"
  }
}
```

---

## 5.4 `RECOMMEND`

**Cas du cahier des charges :** 12 (page 5)

### Requête

```json
{
  "action": "RECOMMEND",
  "payload": {
    "cardId": "c_001"
  }
}
```

### Réponse succès

```json
{
  "status": "OK",
  "action": "RECOMMENDATION_ADDED",
  "data": {
    "cardId": "c_001",
    "newValue": 16,
    "newRecoCount": 6
  }
}
```

### Erreurs

* `CARD_NOT_FOUND`
* `CARD_NOT_ACTIVE`
* `ALREADY_RECOMMENDED`

### Notification push

```json
{
  "status": "NOTIFY",
  "action": "CARD_UPDATED",
  "data": {
    "cardId": "c_001",
    "value": 16
  }
}
```

---

## 5.5 `REPUDIATE`

**Cas du cahier des charges :** 14 (page 5)

### Requête

```json
{
  "action": "REPUDIATE",
  "payload": {
    "cardId": "c_001"
  }
}
```

### Réponse succès

```json
{
  "status": "OK",
  "action": "RECOMMENDATION_REPUDIATED",
  "data": {
    "cardId": "c_001",
    "newValue": 15,
    "newRecoCount": 5
  }
}
```

### Erreurs

* `CARD_NOT_FOUND`
* `NOT_RECOMMENDED`

### Notification push

```json
{
  "status": "NOTIFY",
  "action": "CARD_UPDATED",
  "data": {
    "cardId": "c_001",
    "value": 15
  }
}
```

---

## 5.6 `START_BATTLE`

**Cas du cahier des charges :** 15 (page 5)

### Requête

```json
{
  "action": "START_BATTLE",
  "payload": {
    "cardId1": "c_001",
    "cardId2": "c_005"
  }
}
```

### Réponse succès

```json
{
  "status": "OK",
  "action": "BATTLE_STARTED",
  "data": {
    "battleId": "b_014",
    "card1": "c_001",
    "card2": "c_005",
    "card1VA": 15,
    "card2VA": 10,
    "duration": 60,
    "endTime": "2026-09-25T11:35:00Z",
    "votes": {
      "c_001": 0,
      "c_005": 0
    }
  }
}
```

### Erreurs

* `CARD_NOT_FOUND`
* `CARD_NOT_ACTIVE`
* `CARDS_NOT_COMPATIBLE`
* `VA_TOO_LOW`
* `BATTLE_ALREADY_ACTIVE`

### Notification push

```json
{
  "status": "NOTIFY",
  "action": "NEW_BATTLE",
  "data": {
    "battleId": "b_014",
    "card1": "c_001",
    "card2": "c_005"
  }
}
```

---

## 5.7 `VOTE_BATTLE`

**Cas du cahier des charges :** 16 (page 5)

### Requête

```json
{
  "action": "VOTE_BATTLE",
  "payload": {
    "battleId": "b_014",
    "cardId": "c_001"
  }
}
```

### Réponse succès

```json
{
  "status": "OK",
  "action": "VOTE_REGISTERED",
  "data": {
    "battleId": "b_014",
    "cardId": "c_001",
    "weight": 5,
    "votes": {
      "c_001": 5,
      "c_005": 3
    }
  }
}
```

### Erreurs

* `BATTLE_NOT_FOUND`
* `ALREADY_VOTED`
* `NOT_ALLOWED` *(propriétaire d'une carte)*

### Notification push

```json
{
  "status": "NOTIFY",
  "action": "BATTLE_UPDATE",
  "data": {
    "battleId": "b_014",
    "votes": {
      "c_001": 5,
      "c_005": 3
    }
  }
}
```

---

## 5.8 `REQUEST_LEGITIMACY`

**Cas du cahier des charges :** 18 (page 5)

### Requête

```json
{
  "action": "REQUEST_LEGITIMACY",
  "payload": {
    "cardId": "c_001",
    "justification": "Je suis expert Python"
  }
}
```

### Réponse succès

```json
{
  "status": "OK",
  "action": "LEGITIMACY_REQUESTED",
  "data": {
    "legitimacyId": "l_001",
    "cardId": "c_001",
    "userId": "u_002",
    "status": "PENDING",
    "requestedAt": "2026-09-25T11:40:00Z"
  }
}
```

### Erreurs

* `CARD_NOT_FOUND`
* `THRESHOLD_NOT_REACHED`

### Notification push au créateur

```json
{
  "status": "NOTIFY",
  "action": "LEGITIMACY_REQUEST",
  "data": {
    "cardId": "c_001",
    "userId": "u_002",
    "justification": "Je suis expert Python"
  }
}
```

---

## 5.9 `CLAIM_CARD`

**Cas du cahier des charges :** 19 (page 6)

### Requête

```json
{
  "action": "CLAIM_CARD",
  "payload": {
    "cardId": "c_001"
  }
}
```

### Réponse succès

```json
{
  "status": "OK",
  "action": "CARD_CLAIMED",
  "data": {
    "cardId": "c_001",
    "previousOwner": "u_001",
    "newOwner": "u_003",
    "claimedAt": "2026-09-25T11:50:00Z"
  }
}
```

### Erreurs

* `CARD_NOT_FOUND`
* `NOT_LEGITIMATE`

### Notification push

```json
{
  "status": "NOTIFY",
  "action": "CARD_UPDATED",
  "data": {
    "cardId": "c_001",
    "owner": "u_003"
  }
}
```

---

## 5.10 `AUTHENTICATE_CARD`

**Cas du cahier des charges :** 20 (page 6)

### Requête

```json
{
  "action": "AUTHENTICATE_CARD",
  "payload": {
    "cardId": "c_001"
  }
}
```

### Réponse succès

```json
{
  "status": "OK",
  "action": "CARD_AUTHENTICATED",
  "data": {
    "cardId": "c_001",
    "authenticatedBy": "u_003",
    "authenticatedAt": "2026-09-25T11:55:00Z",
    "newValue": 30
  }
}
```

### Erreurs

* `CARD_NOT_FOUND`
* `NOT_LEGITIMATE`
* `ALREADY_AUTHENTICATED`

### Notification push

```json
{
  "status": "NOTIFY",
  "action": "CARD_UPDATED",
  "data": {
    "cardId": "c_001",
    "value": 30,
    "isAuthenticated": true
  }
}
```

---

## 5.11 `DISCONNECT`

**Cas du cahier des charges :** 25 (page 6)

### Requête

```json
{
  "action": "DISCONNECT",
  "payload": {}
}
```

### Réponse succès

```json
{
  "status": "OK",
  "action": "DISCONNECTED",
  "data": {}
}
```

### Notification push

```json
{
  "status": "NOTIFY",
  "action": "USER_DISCONNECTED",
  "data": {
    "username": "usman"
  }
}
```

---

# 6. Détail des 9 notifications push

|  # | Action               | Données                                                                                                    | Quand                   |
| -: | -------------------- | ---------------------------------------------------------------------------------------------------------- | ----------------------- |
|  1 | `USER_CONNECTED`     | `{username}`                                                                                               | Connexion               |
|  2 | `USER_DISCONNECTED`  | `{username}`                                                                                               | Déconnexion             |
|  3 | `NEW_CARD`           | `{cardId, title, creator}`                                                                                 | Création d'une carte    |
|  4 | `CARD_UPDATED`       | `{cardId, value, owner?, isAuthenticated?}`                                                                | Modification            |
|  5 | `NEW_BATTLE`         | `{battleId, card1, card2}`                                                                                 | Battle lancée           |
|  6 | `BATTLE_UPDATE`      | `{battleId, votes}`                                                                                        | Vote enregistré         |
|  7 | `BATTLE_RESULT`      | `{battleId, winner, loser, transferredRecommendations, loserNewStatus, winnerNewValue, winnerNewWinCount}` | Fin de battle           |
|  8 | `LEGITIMACY_REQUEST` | `{cardId, userId, justification}`                                                                          | Demande de légitimation |
|  9 | `LEGITIMACY_GRANTED` | `{cardId, userId, grantedAt}`                                                                              | Légitimation accordée   |

---

# 7. Codes d'erreur

## 7.1 Liste des 17 codes

|  # | Code                    | Signification                      | Actions concernées                                                                                               |
| -: | ----------------------- | ---------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
|  1 | `INVALID_DATA`          | Champs invalides                   | Toutes                                                                                                           |
|  2 | `USERNAME_TAKEN`        | Pseudo déjà pris                   | `LOGIN`                                                                                                          |
|  3 | `CARD_NOT_FOUND`        | Carte inexistante                  | `RECOMMEND`, `REPUDIATE`, `START_BATTLE`, `VOTE_BATTLE`, `REQUEST_LEGITIMACY`, `CLAIM_CARD`, `AUTHENTICATE_CARD` |
|  4 | `CARD_NOT_ACTIVE`       | Carte inactive                     | `RECOMMEND`, `START_BATTLE`                                                                                      |
|  5 | `DUPLICATE_CARD`        | Carte existante                    | `CREATE_CARD`                                                                                                    |
|  6 | `ALREADY_RECOMMENDED`   | Carte déjà recommandée             | `RECOMMEND`                                                                                                      |
|  7 | `NOT_RECOMMENDED`       | Aucune recommandation à répudier   | `REPUDIATE`                                                                                                      |
|  8 | `BATTLE_NOT_FOUND`      | Battle inexistante                 | `VOTE_BATTLE`                                                                                                    |
|  9 | `BATTLE_ALREADY_ACTIVE` | Carte déjà engagée dans une battle | `START_BATTLE`                                                                                                   |
| 10 | `ALREADY_VOTED`         | Utilisateur ayant déjà voté        | `VOTE_BATTLE`                                                                                                    |
| 11 | `NOT_LEGITIMATE`        | Utilisateur non légitime           | `CLAIM_CARD`, `AUTHENTICATE_CARD`                                                                                |
| 12 | `THRESHOLD_NOT_REACHED` | Seuil non atteint                  | `REQUEST_LEGITIMACY`                                                                                             |
| 13 | `CARDS_NOT_COMPATIBLE`  | Paradigmes différents              | `START_BATTLE`                                                                                                   |
| 14 | `VA_TOO_LOW`            | VA inférieure à 5                  | `START_BATTLE`                                                                                                   |
| 15 | `ALREADY_AUTHENTICATED` | Carte déjà authentifiée            | `AUTHENTICATE_CARD`                                                                                              |
| 16 | `SERVER_BUSY`           | Serveur plein                      | `LOGIN`                                                                                                          |
| 17 | `INTERNAL_ERROR`        | Erreur interne                     | Toutes                                                                                                           |

---

# 8. Points techniques

| Point                     | Valeur                                               |
| ------------------------- | ---------------------------------------------------- |
| Timeout connexion         | 5 secondes                                           |
| Timeout lecture           | 10 secondes                                          |
| Nombre maximal de clients | 10                                                   |
| Format des IDs            | `c_001`, `u_001`, `b_001`, `r_001`, `v_001`, `l_001` |
| Timestamps                | ISO 8601 UTC                                         |
| Encodage                  | UTF-8                                                |
| Délimiteur                | `\n`                                                 |

---

# 9. Mapping Java ↔ JSON ↔ C ↔ SQL

## 9.1 Objet `Card`

| JSON              | Java              | C                  | SQL                |
| ----------------- | ----------------- | ------------------ | ------------------ |
| `id`              | `id`              | `id`               | `id`               |
| `title`           | `title`           | `title`            | `title`            |
| `paradigm`        | `paradigm`        | `paradigm`         | `paradigm`         |
| `description`     | `description`     | `description`      | `description`      |
| `typing`          | `typing`          | `typing`           | `typing`           |
| `difficulty`      | `difficulty`      | `difficulty`       | `difficulty`       |
| `yearCreated`     | `yearCreated`     | `year_created`     | `year_created`     |
| `imageUrl`        | `imageUrl`        | `image_url`        | `image_url`        |
| `creator`         | `creator`         | `creator`          | `creator_id`       |
| `owner`           | `owner`           | `owner`            | `owner_id`         |
| `status`          | `status`          | `status`           | `status`           |
| `value`           | `value`           | `value`            | `value`            |
| `isAuthenticated` | `isAuthenticated` | `is_authenticated` | `is_authenticated` |
| `authenticatedBy` | `authenticatedBy` | `authenticated_by` | `authenticated_by` |
| `authenticatedAt` | `authenticatedAt` | `authenticated_at` | `authenticated_at` |
| `winCount`        | `winCount`        | `win_count`        | `win_count`        |
| `isLegitimate`    | `isLegitimate`    | `is_legitimate`    | `is_legitimate`    |
| `stakeVA`         | `stakeVA`         | `stake_va`         | `stake_va`         |
| `createdAt`       | `createdAt`       | `created_at`       | `created_at`       |

---

## 9.2 Objet `User`

| JSON              | Java              | C                  | SQL                |
| ----------------- | ----------------- | ------------------ | ------------------ |
| `id`              | `id`              | `id`               | `id`               |
| `username`        | `username`        | `username`         | `username`         |
| `isBot`           | `isBot`           | `is_bot`           | `is_bot`           |
| `recoCount`       | `recoCount`       | `reco_count`       | `reco_count`       |
| `legitimacyCount` | `legitimacyCount` | `legitimacy_count` | `legitimacy_count` |

---

## 9.3 Objet `Battle`

| JSON         | Java         | C             | SQL           |
| ------------ | ------------ | ------------- | ------------- |
| `id`         | `id`         | `id`          | `id`          |
| `card1Id`    | `card1Id`    | `card1_id`    | `card1_id`    |
| `card2Id`    | `card2Id`    | `card2_id`    | `card2_id`    |
| `card1VA`    | `card1VA`    | `card1_va`    | `card1_va`    |
| `card2VA`    | `card2VA`    | `card2_va`    | `card2_va`    |
| `card1Votes` | `card1Votes` | `card1_votes` | `card1_votes` |
| `card2Votes` | `card2Votes` | `card2_votes` | `card2_votes` |
| `duration`   | `duration`   | `duration`    | `duration`    |
| `endTime`    | `endTime`    | `end_time`    | `ended_at`    |
| `status`     | `status`     | `status`      | `status`      |
| `winnerId`   | `winnerId`   | `winner_id`   | `winner_id`   |

---

# 10. Récapitulatif

| Élément            |  Nombre |
| ------------------ | ------: |
| Actions            |  **11** |
| Notifications push |   **9** |
| Codes d'erreur     |  **17** |
| Objets JSON        |   **7** |
| Champs au total    | **~80** |

---

# 11. Validation

| Rôle             | Nom          | Statut |
| ---------------- | ------------ | ------ |
| Client Java      | Usman + Omar | ⏳      |
| Serveur C        | Mai + Albine | ⏳      |
| Blockchain + BDD | Iyore        | ⏳      |

---



# Protocole applicatif complet — SAE-Recommender

**Projet :** SAÉ BUT2 S3 2026-2027
**Thème :** Langages de programmation
**Rédacteur :** Usman + Omar
**Validateurs :** Mai + Albine + Iyore
**Version :** 2.0 (complète)

---

## Historique des versions

| Version | Date | Auteur | Modifications |
|---------|------|--------|----------------|
| 1.0 | 23/09/2026 | Usman | Version initiale |
| 1.1 | 25/09/2026 | Usman | Ajout mapping |
| 2.0 | 26/09/2026 | Usman | Version complète |

---

## Table des matières

1. [Vue d'ensemble](#1-vue-densemble)
2. [Règles de nommage](#2-règles-de-nommage)
3. [Structure des messages](#3-structure-des-messages)
4. [Objets JSON complets](#4-objets-json-complets)
5. [Détail des 11 actions](#5-détail-des-11-actions)
6. [Détail des 9 notifications push](#6-détail-des-9-notifications-push)
7. [Codes d'erreur](#7-codes-derreur)
8. [Points techniques](#8-points-techniques)
9. [Mapping Java ↔ JSON ↔ C ↔ SQL](#9-mapping-java--json--c--sql)
10. [Gestion des timeouts](#10-gestion-des-timeouts)
11. [Exemples de flux complets](#11-exemples-de-flux-complets)
12. [Limites et contraintes](#12-limites-et-contraintes)
13. [Récapitulatif](#13-récapitulatif)
14. [Validation](#14-validation)

---

## 1. Vue d'ensemble

| Élément | Valeur |
|---------|--------|
| **Format** | JSON |
| **Encodage** | UTF-8 |
| **Délimiteur** | `\n` (saut de ligne) |
| **Transport** | Socket TCP |
| **Bibliothèque Java** | Gson |
| **Bibliothèque C** | cJSON |
| **Port par défaut** | 8080 |
| **Nombre maximal de clients** | 10 |

Chaque message est une ligne JSON terminée par `\n`.

---

## 2. Règles de nommage

Ces règles sont critiques pour assurer la compatibilité entre Java, JSON, C et SQL.

### 2.1 JSON et Java : camelCase

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

### 2.2 C et SQL : snake_case

```c
char card_id[20];
int is_authenticated;
```

```sql
card_id VARCHAR(20);
is_authenticated BOOLEAN;
```

### 2.3 cJSON respecte les noms JSON

```c
cJSON_AddStringToObject(root, "cardId", card->id);
```

### 2.4 Gson utilise les noms Java

```java
private String cardId;
```

---

## 3. Structure des messages

### 3.1 Requête — Client → Serveur

```json
{
  "action": "LOGIN",
  "payload": {
    "username": "usman"
  }
}
```

| Champ | Type | Obligatoire | Description |
|-------|------|-------------|-------------|
| action | String | Oui | Nom de l'action |
| payload | Objet | Oui | Données de l'action |

### 3.2 Réponse succès — Serveur → Client

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

| Champ | Type | Description |
|-------|------|-------------|
| status | String | OK |
| action | String | Nom du résultat |
| data | Objet | Données de la réponse |

### 3.3 Réponse erreur — Serveur → Client

```json
{
  "status": "ERROR",
  "code": "USERNAME_TAKEN",
  "message": "Ce pseudo est deja utilise."
}
```

| Champ | Type | Description |
|-------|------|-------------|
| status | String | ERROR |
| code | String | Code d'erreur |
| message | String | Message lisible |

### 3.4 Notification push — Serveur → Clients

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

| Champ | Type | Description |
|-------|------|-------------|
| status | String | NOTIFY |
| action | String | Type de notification |
| data | Objet | Données de la notification |

---

## 4. Objets JSON complets

### 4.1 Objet Card

Exemple complet :

```json
{
  "id": "c_001",
  "title": "Python",
  "paradigm": "MULTI",
  "description": "Langage interprete, polyvalent",
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

| Champ | Type | Obligatoire | Description |
|-------|------|-------------|-------------|
| id | String | Oui | Identifiant unique (c_XXX) |
| title | String | Oui | Nom du langage |
| paradigm | String | Oui | OBJECT, FUNCTIONAL, PROCEDURAL, LOGIC, SCRIPTING, MULTI |
| description | String | Oui | Description |
| typing | String | Oui | STATIC, DYNAMIC, STRONG, WEAK |
| difficulty | String | Oui | BEGINNER, INTERMEDIATE, ADVANCED, EXPERT |
| yearCreated | int | Non | Année de création |
| imageUrl | String | Non | URL du logo |
| creator | String | Oui | ID du créateur (u_XXX) |
| owner | String | Oui | ID du propriétaire (u_XXX) |
| status | String | Oui | ACTIVE, INACTIVE, AUTHENTIFIED |
| value | int | Oui | Valeur de la carte (VA) |
| isAuthenticated | boolean | Oui | Carte authentifiée ou non |
| authenticatedBy | String | Non | Utilisateur ayant authentifié |
| authenticatedAt | String | Non | Date d'authentification |
| winCount | int | Oui | Nombre de victoires |
| isLegitimate | boolean | Oui | Propriétaire légitime ou non |
| stakeVA | int | Oui | VA engagée |
| createdAt | String | Oui | Date ISO 8601 |

### 4.2 Objet User

```json
{
  "id": "u_001",
  "username": "usman",
  "isBot": false,
  "recoCount": 0,
  "legitimacyCount": 0
}
```

### 4.3 Objet Recommendation

```json
{
  "cardId": "c_001",
  "userId": "u_002",
  "date": "2026-09-25T11:30:00Z"
}
```

### 4.4 Objet Battle

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

### 4.5 Objet Vote

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

### 4.6 Objet Legitimacy

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

### 4.7 Objet Notification

```json
{
  "type": "RECOMMEND",
  "from": "alice",
  "message": "alice a recommande votre carte Python"
}
```

---

## 5. Détail des 11 actions

### 5.1 LOGIN

Cas du cahier des charges : 5, 6, 7 (page 4)

Requête :

```json
{
  "action": "LOGIN",
  "payload": {
    "username": "usman"
  }
}
```

Réponse succès :

```json
{
  "status": "OK",
  "action": "LOGIN_SUCCESS",
  "data": {
    "userId": "u_001",
    "username": "usman",
    "connectedUsers": ["usman", "alice"],
    "recoCount": 0,
    "legitimacyCount": 0
  }
}
```

Erreurs possibles :

| Code | Signification |
|------|---------------|
| USERNAME_TAKEN | Pseudo déjà utilisé |
| SERVER_BUSY | Serveur plein |
| INVALID_DATA | Champs invalides |
| INTERNAL_ERROR | Erreur interne |

Note : après LOGIN_SUCCESS, le serveur envoie automatiquement CONTEXT_RESTORED.

### 5.2 GET_CONTEXT

Cas du cahier des charges : 7, 22 (pages 4 et 6)

Permet de restaurer tout le contexte d'un utilisateur (cartes, recos, battles, légitimations, notifications).

Requête :

```json
{
  "action": "GET_CONTEXT",
  "payload": {}
}
```

Réponse succès :

```json
{
  "status": "OK",
  "action": "CONTEXT_RESTORED",
  "data": {
    "myCards": [],
    "myRecommendations": [],
    "receivedRecommendations": [],
    "activeBattles": [],
    "myLegitimacies": [],
    "myAuthentications": [],
    "notifications": []
  }
}
```

Erreurs possibles :

| Code | Signification |
|------|---------------|
| INTERNAL_ERROR | Erreur interne |

### 5.3 CREATE_CARD

Cas du cahier des charges : 11 (page 5)

Requête :

```json
{
  "action": "CREATE_CARD",
  "payload": {
    "title": "Python",
    "paradigm": "MULTI",
    "description": "Langage interprete, polyvalent",
    "typing": "DYNAMIC",
    "difficulty": "BEGINNER",
    "yearCreated": 1991,
    "imageUrl": "https://example.com/python.png"
  }
}
```

Contraintes :

| Champ | Type | Obligatoire | Contraintes |
|-------|------|-------------|-------------|
| title | String | Oui | 1-100 caractères |
| paradigm | String | Oui | OBJECT, FUNCTIONAL, PROCEDURAL, LOGIC, SCRIPTING, MULTI |
| description | String | Oui | 1-500 caractères |
| typing | String | Oui | STATIC, DYNAMIC, STRONG, WEAK |
| difficulty | String | Oui | BEGINNER, INTERMEDIATE, ADVANCED, EXPERT |
| yearCreated | int | Non | 1950-2030 |
| imageUrl | String | Non | URL valide |

Réponse succès :

```json
{
  "status": "OK",
  "action": "CARD_CREATED",
  "data": {
    "id": "c_001",
    "title": "Python",
    "owner": "u_001",
    "status": "ACTIVE",
    "value": 0
  }
}
```

Erreurs possibles :

| Code | Signification |
|------|---------------|
| INVALID_DATA | Champs invalides |
| DUPLICATE_CARD | Carte existante |
| INTERNAL_ERROR | Erreur interne |

Notification push :

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

### 5.4 RECOMMEND

Cas du cahier des charges : 12 (page 5)

Requête :

```json
{
  "action": "RECOMMEND",
  "payload": {
    "cardId": "c_001"
  }
}
```

Réponse succès :

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

Erreurs possibles :

| Code | Signification |
|------|---------------|
| CARD_NOT_FOUND | Carte inexistante |
| CARD_NOT_ACTIVE | Carte inactive |
| ALREADY_RECOMMENDED | Déjà recommandée |
| INTERNAL_ERROR | Erreur interne |

### 5.5 REPUDIATE

Cas du cahier des charges : 14 (page 5)

Requête :

```json
{
  "action": "REPUDIATE",
  "payload": {
    "cardId": "c_001"
  }
}
```

Réponse succès :

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

Erreurs possibles :

| Code | Signification |
|------|---------------|
| CARD_NOT_FOUND | Carte inexistante |
| NOT_RECOMMENDED | Aucune reco à répudier |
| INTERNAL_ERROR | Erreur interne |

### 5.6 START_BATTLE

Cas du cahier des charges : 15 (page 5)

Requête :

```json
{
  "action": "START_BATTLE",
  "payload": {
    "cardId1": "c_001",
    "cardId2": "c_005"
  }
}
```

Réponse succès :

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

Erreurs possibles :

| Code | Signification |
|------|---------------|
| CARD_NOT_FOUND | Carte inexistante |
| CARD_NOT_ACTIVE | Carte inactive |
| CARDS_NOT_COMPATIBLE | Paradigmes différents |
| VA_TOO_LOW | VA inférieure à 5 |
| BATTLE_ALREADY_ACTIVE | Carte déjà en battle |
| INTERNAL_ERROR | Erreur interne |

### 5.7 VOTE_BATTLE

Cas du cahier des charges : 16 (page 5)

Requête :

```json
{
  "action": "VOTE_BATTLE",
  "payload": {
    "battleId": "b_014",
    "cardId": "c_001"
  }
}
```

Réponse succès :

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

Erreurs possibles :

| Code | Signification |
|------|---------------|
| BATTLE_NOT_FOUND | Battle inexistante |
| ALREADY_VOTED | Déjà voté |
| NOT_ALLOWED | Propriétaire d'une carte |
| INTERNAL_ERROR | Erreur interne |

### 5.8 REQUEST_LEGITIMACY

Cas du cahier des charges : 18 (page 5)

Requête :

```json
{
  "action": "REQUEST_LEGITIMACY",
  "payload": {
    "cardId": "c_001",
    "justification": "Je suis expert Python"
  }
}
```

Réponse succès :

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

Erreurs possibles :

| Code | Signification |
|------|---------------|
| CARD_NOT_FOUND | Carte inexistante |
| THRESHOLD_NOT_REACHED | Seuil non atteint |
| INTERNAL_ERROR | Erreur interne |

### 5.9 CLAIM_CARD

Cas du cahier des charges : 19 (page 6)

Requête :

```json
{
  "action": "CLAIM_CARD",
  "payload": {
    "cardId": "c_001"
  }
}
```

Réponse succès :

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

Erreurs possibles :

| Code | Signification |
|------|---------------|
| CARD_NOT_FOUND | Carte inexistante |
| NOT_LEGITIMATE | Utilisateur non légitime |
| INTERNAL_ERROR | Erreur interne |

### 5.10 AUTHENTICATE_CARD

Cas du cahier des charges : 20 (page 6)

Requête :

```json
{
  "action": "AUTHENTICATE_CARD",
  "payload": {
    "cardId": "c_001"
  }
}
```

Réponse succès :

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

Erreurs possibles :

| Code | Signification |
|------|---------------|
| CARD_NOT_FOUND | Carte inexistante |
| NOT_LEGITIMATE | Utilisateur non légitime |
| ALREADY_AUTHENTICATED | Carte déjà authentifiée |
| INTERNAL_ERROR | Erreur interne |

### 5.11 DISCONNECT

Cas du cahier des charges : 25 (page 6)

Requête :

```json
{
  "action": "DISCONNECT",
  "payload": {}
}
```

Réponse succès :

```json
{
  "status": "OK",
  "action": "DISCONNECTED",
  "data": {}
}
```

Erreurs possibles :

| Code | Signification |
|------|---------------|
| INTERNAL_ERROR | Erreur interne |

---

## 6. Détail des 9 notifications push

| # | Action | Données | Quand |
|---|--------|---------|-------|
| 1 | USER_CONNECTED | {username} | Connexion |
| 2 | USER_DISCONNECTED | {username} | Déconnexion |
| 3 | NEW_CARD | {cardId, title, creator} | Création d'une carte |
| 4 | CARD_UPDATED | {cardId, value, owner?, isAuthenticated?} | Modification |
| 5 | NEW_BATTLE | {battleId, card1, card2} | Battle lancée |
| 6 | BATTLE_UPDATE | {battleId, votes} | Vote enregistré |
| 7 | BATTLE_RESULT | {battleId, winner, loser, ...} | Fin de battle |
| 8 | LEGITIMACY_REQUEST | {cardId, userId, justification} | Demande légitimation |
| 9 | LEGITIMACY_GRANTED | {cardId, userId, grantedAt} | Légitimation accordée |

---

## 7. Codes d'erreur

| # | Code | Signification | Actions concernées |
|---|------|---------------|--------------------|
| 1 | INVALID_DATA | Champs invalides | Toutes |
| 2 | USERNAME_TAKEN | Pseudo déjà pris | LOGIN |
| 3 | CARD_NOT_FOUND | Carte inexistante | RECOMMEND, REPUDIATE, START_BATTLE, VOTE_BATTLE, REQUEST_LEGITIMACY, CLAIM_CARD, AUTHENTICATE_CARD |
| 4 | CARD_NOT_ACTIVE | Carte inactive | RECOMMEND, START_BATTLE |
| 5 | DUPLICATE_CARD | Carte existante | CREATE_CARD |
| 6 | ALREADY_RECOMMENDED | Carte déjà recommandée | RECOMMEND |
| 7 | NOT_RECOMMENDED | Aucune reco à répudier | REPUDIATE |
| 8 | BATTLE_NOT_FOUND | Battle inexistante | VOTE_BATTLE |
| 9 | BATTLE_ALREADY_ACTIVE | Carte déjà en battle | START_BATTLE |
| 10 | ALREADY_VOTED | Déjà voté | VOTE_BATTLE |
| 11 | NOT_LEGITIMATE | Utilisateur non légitime | CLAIM_CARD, AUTHENTICATE_CARD |
| 12 | THRESHOLD_NOT_REACHED | Seuil non atteint | REQUEST_LEGITIMACY |
| 13 | CARDS_NOT_COMPATIBLE | Paradigmes différents | START_BATTLE |
| 14 | VA_TOO_LOW | VA inférieure à 5 | START_BATTLE |
| 15 | ALREADY_AUTHENTICATED | Carte déjà authentifiée | AUTHENTICATE_CARD |
| 16 | SERVER_BUSY | Serveur plein | LOGIN |
| 17 | INTERNAL_ERROR | Erreur interne | Toutes |

---

## 8. Points techniques

| Point | Valeur |
|-------|--------|
| Timeout connexion | 5 secondes |
| Timeout lecture | 10 secondes |
| Nombre maximal de clients | 10 |
| Format des IDs | c_001, u_001, b_001, r_001, v_001, l_001 |
| Timestamps | ISO 8601 UTC |
| Encodage | UTF-8 |
| Délimiteur | \n |

---

## 9. Mapping Java ↔ JSON ↔ C ↔ SQL

### 9.1 Objet Card

| JSON | Java | C | SQL |
|------|------|---|-----|
| id | id | id | id |
| title | title | title | title |
| paradigm | paradigm | paradigm | paradigm |
| description | description | description | description |
| typing | typing | typing | typing |
| difficulty | difficulty | difficulty | difficulty |
| yearCreated | yearCreated | year_created | year_created |
| imageUrl | imageUrl | image_url | image_url |
| creator | creator | creator | creator_id |
| owner | owner | owner | owner_id |
| status | status | status | status |
| value | value | value | value |
| isAuthenticated | isAuthenticated | is_authenticated | is_authenticated |
| authenticatedBy | authenticatedBy | authenticated_by | authenticated_by |
| authenticatedAt | authenticatedAt | authenticated_at | authenticated_at |
| winCount | winCount | win_count | win_count |
| isLegitimate | isLegitimate | is_legitimate | is_legitimate |
| stakeVA | stakeVA | stake_va | stake_va |
| createdAt | createdAt | created_at | created_at |

### 9.2 Objet User

| JSON | Java | C | SQL |
|------|------|---|-----|
| id | id | id | id |
| username | username | username | username |
| isBot | isBot | is_bot | is_bot |
| recoCount | recoCount | reco_count | reco_count |
| legitimacyCount | legitimacyCount | legitimacy_count | legitimacy_count |

### 9.3 Objet Battle

| JSON | Java | C | SQL |
|------|------|---|-----|
| id | id | id | id |
| card1Id | card1Id | card1_id | card1_id |
| card2Id | card2Id | card2_id | card2_id |
| card1VA | card1VA | card1_va | card1_va |
| card2VA | card2VA | card2_va | card2_va |
| card1Votes | card1Votes | card1_votes | card1_votes |
| card2Votes | card2Votes | card2_votes | card2_votes |
| duration | duration | duration | duration |
| endTime | endTime | end_time | ended_at |
| status | status | status | status |
| winnerId | winnerId | winner_id | winner_id |

---

## 10. Gestion des timeouts

### 10.1 Timeout de connexion

Si le client ne peut pas se connecter en 5 secondes :

- Le client affiche "Serveur injoignable"
- Le client propose de réessayer

### 10.2 Timeout de lecture

Si le client n'a pas de réponse en 10 secondes :

- Le client affiche "Delai depasse"
- Le client peut relancer la requête

### 10.3 Déconnexion brutale du serveur

Si le serveur s'arrête brutalement :

- Le client détecte readLine() == null
- Le client affiche "Connexion perdue"
- Le client propose de se reconnecter

---

## 11. Exemples de flux complets

### 11.1 Connexion + Création + Recommandation

```
CLIENT                          SERVEUR
   |                               |
   | LOGIN -------------------->   |
   | <---- LOGIN_SUCCESS --------- |
   | <---- CONTEXT_RESTORED ------ |
   |                               |
   | CREATE_CARD -------------->   |
   | <---- CARD_CREATED ---------- |
   |                               |
   | RECOMMEND ---------------->   |
   | <---- RECOMMENDATION_ADDED -- |
   |                               |
   | (Serveur notifie les autres)  |
   | <---- CARD_UPDATED ---------- |
```

### 11.2 Battle complete

```
CLIENT A                        SERVEUR
   |                               |
   | START_BATTLE ------------->   |
   | <---- BATTLE_STARTED -------- |
   |                               |

CLIENT B                        SERVEUR
   |                               |
   | VOTE_BATTLE -------------->   |
   | <---- VOTE_REGISTERED ------- |
   |                               |
   | (60 secondes plus tard)       |
   |                               |
   | <---- BATTLE_RESULT --------- |
```

---

## 12. Limites et contraintes

| Contrainte | Valeur |
|------------|--------|
| Taille max d'un message | 4096 octets |
| Taille max d'un champ | 500 caractères |
| Nombre max d'actions par client | Illimité |
| Nombre max de notifications | Illimité |
| Taille max d'un ID | 20 caractères |
| Taille max d'un timestamp | 30 caractères |

---

## 13. Récapitulatif

| Élément | Nombre |
|---------|--------|
| Actions | 11 |
| Notifications push | 9 |
| Codes d'erreur | 17 |
| Objets JSON | 7 |
| Champs au total | ~80 |

---

## 14. Validation

| Rôle | Nom | Statut |
|------|-----|--------|
| Client Java | Usman + Omar | En attente |
| Serveur C | Mai + Albine | En attente |
| Blockchain + BDD | Iyore | En attente |

---

**Fin du document.**

# Cas d'erreur — SAE-Recommender

**Projet :** SAÉ BUT2 S3 2026-2027
**Thème :** Langages de programmation

---

## Sommaire

1. [Objectif](#1-objectif)
2. [Format standard des erreurs](#2-format-standard-des-erreurs)
3. [Liste complète des codes d'erreur](#3-liste-complète-des-codes-derreur)
4. [Détail des cas d'erreur](#4-détail-des-cas-derreur)
5. [Cas d'erreur côté client uniquement](#5-cas-derreur-côté-client-uniquement)
6. [Gestion des erreurs côté client](#6-gestion-des-erreurs-côté-client)
7. [Correspondance avec le cahier des charges](#7-correspondance-avec-le-cahier-des-charges)
8. [Récapitulatif](#8-récapitulatif)
9. [Validation](#9-validation)

---

## 1. Objectif

Ce document liste les cas d'erreur que le client Java et le serveur C doivent gérer.

Le cahier des charges (page 7) précise :

> « Les cas d'utilisation listent les principales actions supportées. De nombreux cas d'erreur ne sont pas explicités. Les étudiants prennent en charge les cas d'erreur les plus représentatifs dans leur code. »

---

## 2. Format standard des erreurs

Toutes les erreurs suivent le même format JSON :

```json
{
  "status": "ERROR",
  "code": "USERNAME_TAKEN",
  "message": "Ce pseudo est deja utilise."
}
```

| Champ     | Type   | Description                          |
|-----------|--------|---------------------------------------|
| `status`  | String | Toujours `"ERROR"`                    |
| `code`    | String | Code machine (majuscules + underscores) |
| `message` | String | Message lisible par l'utilisateur     |

---

## 3. Liste complète des codes d'erreur

| # | Code | Signification | Action(s) concernée(s) |
|---|------|----------------|--------------------------|
| 1 | `INVALID_DATA` | Champs manquants ou invalides | Toutes |
| 2 | `USERNAME_TAKEN` | Pseudo déjà utilisé | `LOGIN` |
| 3 | `CARD_NOT_FOUND` | Carte inexistante | `RECOMMEND`, `REPUDIATE`, `START_BATTLE`, `VOTE_BATTLE`, `REQUEST_LEGITIMACY`, `CLAIM_CARD`, `AUTHENTICATE_CARD` |
| 4 | `CARD_NOT_ACTIVE` | Carte inactive | `RECOMMEND`, `START_BATTLE` |
| 5 | `DUPLICATE_CARD` | Carte déjà existante | `CREATE_CARD` |
| 6 | `ALREADY_RECOMMENDED` | Déjà recommandée | `RECOMMEND` |
| 7 | `NOT_RECOMMENDED` | Aucune recommandation à répudier | `REPUDIATE` |
| 8 | `BATTLE_NOT_FOUND` | Battle inexistante | `VOTE_BATTLE` |
| 9 | `BATTLE_ALREADY_ACTIVE` | Carte déjà en battle | `START_BATTLE` |
| 10 | `ALREADY_VOTED` | Déjà voté | `VOTE_BATTLE` |
| 11 | `NOT_LEGITIMATE` | Utilisateur non légitime | `CLAIM_CARD`, `AUTHENTICATE_CARD` |
| 12 | `THRESHOLD_NOT_REACHED` | Seuil non atteint | `REQUEST_LEGITIMACY` |
| 13 | `CARDS_NOT_COMPATIBLE` | Paradigmes différents | `START_BATTLE` |
| 14 | `VA_TOO_LOW` | VA inférieure à 5 | `START_BATTLE` |
| 15 | `ALREADY_AUTHENTICATED` | Carte déjà authentifiée | `AUTHENTICATE_CARD` |
| 16 | `SERVER_BUSY` | Serveur plein | `LOGIN` |
| 17 | `INTERNAL_ERROR` | Erreur interne du serveur | Toutes |

---

## 4. Détail des cas d'erreur

### 4.1 `INVALID_DATA`

**Quand :** Un champ obligatoire est manquant ou invalide.

**Exemples de déclenchement :**
- Créer une carte sans `title`
- Créer une carte avec `yearCreated = 3000`
- Envoyer un JSON mal formé

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "INVALID_DATA",
  "message": "Le titre est obligatoire."
}
```

**Comportement client :**
- Afficher le message dans un label rouge
- Ne pas fermer le formulaire
- Permettre de corriger et réessayer

---

### 4.2 `USERNAME_TAKEN`

**Quand :** Un utilisateur tente de se connecter avec un pseudo déjà utilisé par un autre client connecté.

**Exemples de déclenchement :**
- `usman` se connecte
- `usman` tente de se reconnecter depuis un autre client

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "USERNAME_TAKEN",
  "message": "Ce pseudo est deja utilise."
}
```

**Comportement client :**
- Afficher le message en rouge
- Proposer un autre pseudo
- Rester sur l'écran de connexion

---

### 4.3 `CARD_NOT_FOUND`

**Quand :** Une action référence une carte qui n'existe pas.

**Exemple de déclenchement :**
- Recommander une carte avec `cardId = "c_999"`

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "CARD_NOT_FOUND",
  "message": "Carte introuvable."
}
```

**Comportement client :**
- Afficher un message d'erreur
- Rafraîchir la liste des cartes
- Retirer la carte de l'affichage si nécessaire

---

### 4.4 `CARD_NOT_ACTIVE`

**Quand :** Une action est tentée sur une carte inactive.

**Exemples de déclenchement :**
- Recommander une carte `INACTIVE`
- Lancer une battle avec une carte `INACTIVE`

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "CARD_NOT_ACTIVE",
  "message": "Cette carte est inactive."
}
```

**Comportement client :**
- Désactiver les boutons « Recommander » et « Battle » pour les cartes inactives
- Afficher un badge « Inactive » sur la carte

---

### 4.5 `DUPLICATE_CARD`

**Quand :** Un utilisateur tente de créer une carte avec un titre déjà existant.

**Exemple de déclenchement :**
- Créer `Python` alors que `Python` existe déjà

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "DUPLICATE_CARD",
  "message": "Cette carte existe deja."
}
```

**Comportement client :**
- Afficher le message d'erreur
- Proposer un autre titre
- Laisser le formulaire ouvert

---

### 4.6 `ALREADY_RECOMMENDED`

**Quand :** Un utilisateur tente de recommander une carte qu'il a déjà recommandée.

**Exemple de déclenchement :**
- `usman` recommande `Python`
- `usman` clique à nouveau sur « Recommander »

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "ALREADY_RECOMMENDED",
  "message": "Vous avez deja recommande cette carte."
}
```

**Comportement client :**
- Désactiver le bouton « Recommander » après un clic réussi
- Afficher un état visuel (bouton grisé)

---

### 4.7 `NOT_RECOMMENDED`

**Quand :** Un utilisateur tente de répudier une recommandation qu'il n'a pas donnée.

**Exemple de déclenchement :**
- `usman` clique « Répudier » sur `Python` sans l'avoir recommandé

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "NOT_RECOMMENDED",
  "message": "Aucune recommandation a repudier."
}
```

**Comportement client :**
- N'afficher le bouton « Répudier » que pour les cartes recommandées
- Afficher un message d'erreur sinon

---

### 4.8 `BATTLE_NOT_FOUND`

**Quand :** Une action référence une battle qui n'existe pas.

**Exemple de déclenchement :**
- Voter avec `battleId = "b_999"`

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "BATTLE_NOT_FOUND",
  "message": "Battle introuvable."
}
```

**Comportement client :**
- Afficher un message d'erreur
- Rafraîchir la liste des battles

---

### 4.9 `BATTLE_ALREADY_ACTIVE`

**Quand :** Une carte est déjà engagée dans une autre battle.

**Exemple de déclenchement :**
- Lancer une battle avec `Python` alors qu'elle est déjà en battle

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "BATTLE_ALREADY_ACTIVE",
  "message": "Cette carte est deja en battle."
}
```

**Comportement client :**
- Désactiver le bouton « Battle » pour les cartes en battle
- Afficher un badge « En battle »

---

### 4.10 `ALREADY_VOTED`

**Quand :** Un utilisateur tente de voter deux fois dans la même battle.

**Exemple de déclenchement :**
- `usman` vote pour `Python` dans la battle `b_014`
- `usman` clique à nouveau sur « Voter »

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "ALREADY_VOTED",
  "message": "Vous avez deja vote dans cette battle."
}
```

**Comportement client :**
- Désactiver les boutons de vote après un vote réussi
- Afficher un badge « Voté »

---

### 4.11 `NOT_LEGITIMATE`

**Quand :** Un utilisateur non légitime tente une action réservée aux utilisateurs légitimes.

**Exemple de déclenchement :**
- `usman` non légitime tente d'authentifier `Python`

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "NOT_LEGITIMATE",
  "message": "Vous n'etes pas legitime pour cette carte."
}
```

**Comportement client :**
- N'afficher les boutons « Authentifier » et « Revendiquer » que pour les utilisateurs légitimes
- Masquer ces boutons sinon

---

### 4.12 `THRESHOLD_NOT_REACHED`

**Quand :** Un utilisateur tente de demander la légitimation sans avoir atteint le seuil de 5 recommandations.

**Exemple de déclenchement :**
- `usman` a émis 3 recommandations et demande la légitimation

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "THRESHOLD_NOT_REACHED",
  "message": "Vous devez avoir emis au moins 5 recommandations."
}
```

**Comportement client :**
- Afficher le seuil requis
- Afficher la progression actuelle (3/5)

---

### 4.13 `CARDS_NOT_COMPATIBLE`

**Quand :** Deux cartes n'ont pas le même paradigme.

**Exemple de déclenchement :**
- `Java` (`OBJECT`) VS `Haskell` (`FUNCTIONAL`)

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "CARDS_NOT_COMPATIBLE",
  "message": "Les deux cartes doivent avoir le meme paradigme."
}
```

**Comportement client :**
- Dans le dialogue de battle, ne proposer que les cartes du même paradigme
- Afficher un message explicatif

---

### 4.14 `VA_TOO_LOW`

**Quand :** Une carte a une VA inférieure à 5.

**Exemple de déclenchement :**
- Lancer une battle avec une carte ayant `VA = 3`

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "VA_TOO_LOW",
  "message": "La carte doit avoir au moins 5 VA."
}
```

**Comportement client :**
- Désactiver le bouton « Battle » pour les cartes avec `VA < 5`
- Afficher la VA actuelle et le seuil requis

---

### 4.15 `ALREADY_AUTHENTICATED`

**Quand :** Une carte déjà authentifiée est authentifiée à nouveau.

**Exemple de déclenchement :**
- `usman` légitime authentifie `Python` déjà authentifiée

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "ALREADY_AUTHENTICATED",
  "message": "Cette carte est deja authentifiee."
}
```

**Comportement client :**
- Masquer le bouton « Authentifier » pour les cartes déjà authentifiées
- Afficher un badge « Certifiée »

---

### 4.16 `SERVER_BUSY`

**Quand :** Le nombre maximum de clients connectés (10) est atteint.

**Exemple de déclenchement :**
- 10 clients sont connectés
- Un 11ème tente de se connecter

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "SERVER_BUSY",
  "message": "Le serveur est plein. Reessayez plus tard."
}
```

**Comportement client :**
- Afficher un message clair
- Proposer de réessayer
- Rester sur l'écran de connexion

---

### 4.17 `INTERNAL_ERROR`

**Quand :** Une erreur interne survient côté serveur (bug, exception, etc.).

**Exemples de déclenchement :**
- Erreur de parsing JSON inattendue
- Erreur de base de données

**Réponse serveur :**
```json
{
  "status": "ERROR",
  "code": "INTERNAL_ERROR",
  "message": "Une erreur interne est survenue."
}
```

**Comportement client :**
- Afficher un message générique
- Logger l'erreur pour analyse
- Proposer de réessayer

---

## 5. Cas d'erreur côté client uniquement

En plus des erreurs serveur, le client gère ses propres erreurs.

| Cas | Message client | Quand |
|-----|------------------|-------|
| Champs vides | Tous les champs sont obligatoires. | Validation locale |
| Port invalide | Le port doit etre un nombre entre 1 et 65535. | Validation locale |
| Serveur injoignable | Serveur injoignable. | `IOException` |
| Timeout | Delai depasse. Reessayez. | `SocketTimeoutException` |
| Connexion perdue | Connexion perdue. | `readLine()` retourne `null` |
| Erreur JSON | Reponse invalide du serveur. | `JsonSyntaxException` |
| Champs formulaire | Le titre est obligatoire. | Avant envoi |

---

## 6. Gestion des erreurs côté client

### 6.1 Affichage

Toutes les erreurs sont affichées dans un label rouge sous le formulaire ou la zone d'action.

```java
statusLabel.setStyle("-fx-text-fill: red;");
statusLabel.setText(resp.getMessage());
```

### 6.2 Logging

Toutes les erreurs sont loggées dans la console pour débogage.

```java
System.err.println("[ERROR] " + resp.getCode() + " : " + resp.getMessage());
```

### 6.3 Récupération

Le client reste fonctionnel après une erreur :
- Ne ferme pas la fenêtre
- Ne bloque pas l'interface
- Permet de réessayer

### 6.4 Timeout

Le client applique un timeout de 5 secondes pour la connexion et de 10 secondes pour la lecture.

```java
socket.setSoTimeout(5000);
```

---

## 7. Correspondance avec le cahier des charges

| Cas d'erreur | Cas du cahier des charges (page 4-6) |
|---------------|----------------------------------------|
| `INVALID_DATA` | Cas 8, 11 |
| `USERNAME_TAKEN` | Cas 4, 5, 7 |
| `CARD_NOT_FOUND` | Cas 12, 14, 15 |
| `CARD_NOT_ACTIVE` | Cas 12, 15, 21 |
| `DUPLICATE_CARD` | Cas 11 |
| `ALREADY_RECOMMENDED` | Cas 12 |
| `NOT_RECOMMENDED` | Cas 14 |
| `BATTLE_NOT_FOUND` | Cas 16 |
| `BATTLE_ALREADY_ACTIVE` | Cas 15 |
| `ALREADY_VOTED` | Cas 16 |
| `NOT_LEGITIMATE` | Cas 19, 20 |
| `THRESHOLD_NOT_REACHED` | Cas 18 |
| `CARDS_NOT_COMPATIBLE` | Cas 15 |
| `VA_TOO_LOW` | Cas 15 |
| `ALREADY_AUTHENTICATED` | Cas 20 |
| `SERVER_BUSY` | Cas 4 |
| `INTERNAL_ERROR` | Cas 8 |

---

## 8. Récapitulatif

| Catégorie | Nombre |
|-----------|--------|
| Erreurs serveur | 17 |
| Erreurs client | 7 |
| **TOTAL** | **24** |

---

## 9. Validation

| Rôle | Nom | Statut |
|------|-----|--------|
| Client Java | Usman + Omar | ⏳ |
| Serveur C | Mai + Albine | ⏳ |
| Blockchain + BDD | Iyore | ⏳ |

---

*Fin du document.*

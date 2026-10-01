# Annexe E — Déploiement

> Vue physique de la plateforme.

## 1. Diagramme de déploiement

![Déploiement](../src/diagrammes-generaux/04-deploiement.png)

## 2. Composants physiques

### Postes clients

- **Système** : Linux Debian
- **Application** : Client JavaFX
- **Java** : JDK 21
- **JavaFX** : SDK 21
- **Communication** : Socket TCP vers le serveur

### Serveur

- **Système** : Linux Debian
- **Application** : Serveur C multitâche
- **Bibliothèques** : OpenSSL (SHA-256), libpq (PostgreSQL), pthreads
- **Port d'écoute** : 8080 (par défaut)
- **Nombre max de clients** : 10

### Base de données

- **Système** : PostgreSQL
- **Hôte** : `linserv-info-01` (LAN de l'IUT)
- **Tables** : `blocks`, `cards`, `users`, `recommendations`, `battles`, `votes`, `legitimacies`

## 3. Communication réseau

| Source | Destination | Protocole | Port |
|---|---|---|---|
| Client | Serveur | TCP | 8080 |
| Serveur | PostgreSQL | TCP | 5432 |

## 4. Contraintes

- Aucun client n'accède directement à la BDD.
- Le serveur est l'unique point d'entrée.
- Toutes les communications passent par des sockets.

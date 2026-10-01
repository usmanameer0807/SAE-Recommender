## Étape 3 — Annexes (5 fichiers)

### Annexe A — Architecture globale

```bash
# Annexe A — Architecture globale

> Vue d'ensemble de la plateforme SAE-Recommender.

## 1. Architecture globale

![Architecture globale](../src/diagrammes-generaux/00-architecture-globale.png)

## 2. Description

La plateforme est composée de :

- **Clients JavaFX** (un par utilisateur humain) ;
- **Serveur C multitâche** (unique, avec pthreads) ;
- **Base de données PostgreSQL** (sauvegarde de la blockchain) ;
- **Blockchain privée simplifiée** (intégrée au serveur, avec preuve de travail SHA-256).

## 3. Flux principaux

1. Le client se connecte au serveur via une socket TCP.
2. Le serveur authentifie l'utilisateur et restaure son contexte.
3. Le client envoie des requêtes JSON (une par ligne).
4. Le serveur valide, mine un bloc, sauvegarde en BDD, et répond.
5. Le serveur notifie les autres clients si nécessaire.

## 4. Contraintes

- Aucune communication directe client ↔ BDD.
- Toute action validée est inscrite dans la blockchain.
- Le serveur est la seule source de vérité.

# SAE-Recommender

> **SAÉ BUT2 — Semestre 3 — 2026-2027**
> Plateforme de recommandations fondée sur une blockchain privée simplifiée.
> **Thème :** Langages de programmation

## 📋 Présentation

Ce projet consiste à développer une plateforme client-serveur de recommandations
structurées autour de cartes représentant des **langages de programmation**.

La plateforme repose sur :

- une communication par **sockets TCP** ;
- un **serveur multitâche en C** (pthreads) ;
- une **blockchain privée simplifiée** avec preuve de travail (SHA-256) ;
- une sauvegarde dans une base de données **PostgreSQL** ;
- des **tests** (C et JUnit) ;
- une **spécification technique** complète ;
- une **interface graphique JavaFX** ;
- une **présentation et démonstration finales**.

## 👥 Équipe

| Membre | Partie | Technologies |
|---|---|---|
| **Usman** | Client Java + JavaFX + Tests | Java, JavaFX, JUnit, Gson |
| **Omar** | Client Java + JavaFX + Tests | Java, JavaFX, JUnit, Gson |
| **Mai** | Serveur C + Sockets + Tests | C, pthreads, sockets |
| **Albine** | Serveur C + Sockets + Tests | C, pthreads, sockets |
| **Iyore** | Blockchain + PostgreSQL | C, SHA-256, PostgreSQL |

## 📂 Organisation du dépôt

- `docs/` — Documentation Markdown du dépôt
- `docs/src/` — Diagrammes (PNG)
- `docs/specification-technique.md` — Document unique de spécification technique
- `docs/annexes/` — Annexes référencées
- `bdd/` — Scripts SQL PostgreSQL
- `client-java/` — Code Java du client (Phase 2)
- `server-c/` — Code C du serveur (Phase 2)
- `scripts/` — Scripts de lancement
- `ressources/` — Fichiers fournis (ex : `bc_example.py`)

## 🚀 Livrables

| Phase | Contenu | Tag GitLab |
|---|---|---|
| **Phase 1** | Conception et spécification technique | `phase1` |
| **Phase 2** | Codage et tests | `phase2` |
| **Phase 3** | Qualité | `phase3` |
| **Phase 4** | Présentation et démonstration | `phase4` |

## 🔗 Documentation

Voir [`docs/README.md`](docs/README.md) pour le sommaire complet.

## 📅 Dates clés

- **Phase 1** : début septembre → 10/10/2026
- **Phase 2** : 12/10/2026 → 18/12/2026
- **Phase 3** : 04/01/2027 → 15/01/2027
- **Phase 4** : 18/01/2027 → 21/01/2027

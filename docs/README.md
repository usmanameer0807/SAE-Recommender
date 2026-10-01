# Documentation — SAE-Recommender

> Sommaire et organisation de la documentation du dépôt.
> SAÉ BUT2 S3 2026-2027 — Plateforme de recommandations (thème : langages de programmation).

## 📑 Organisation

### Documents communs
- [Vocabulaire commun](commun/vocabulaire-commun.md)
- [Répartition des rôles](commun/repartition-roles.md)
- [Règles métier](commun/regles-metier.md)
- [Protocole applicatif](commun/protocole-applicatif-commun.md)
- [Cas d'erreur](commun/cas-erreur.md)

### Partie client (Java / JavaFX)
- [Architecture client](client/architecture-client.md)
- [Données client](client/donnees-client.md)
- [Séquences client](client/sequences-client.md)
- [Maquette JavaFX](client/maquette-javafx.md)
- [Cas d'erreur client](client/cas-erreur-client.md)

### Partie serveur (C)
- [Architecture serveur](serveur/architecture-serveur.md)
- [Données serveur](serveur/donnees-serveur.md)
- [Séquences serveur](serveur/sequences-serveur.md)
- [Cas d'erreur serveur](serveur/cas-erreur-serveur.md)

### Blockchain et BDD
- [Structures blockchain](blockchain-bdd/structures-blockchain.md)
- [Schéma BDD](blockchain-bdd/schema-bdd.md)
- [Documentation blockchain](blockchain-bdd/documentation-blockchain.md)

### Spécification technique
- [Document unique](specification-technique.md)
- [Annexes](annexes/)

### Chronologique
- [Suivi chronologique](chronologique/suivieChronologique.md)

## 🎨 Diagrammes UML utilisés (≤ 5 types)

1. **Cas d'utilisation** — `src/diagrammes-generaux/01-cas-utilisation-global.png`
2. **Classes** — `src/diagrammes-client/02-diagramme-classes.png`, `src/diagrammes-serveur/02-classes-serveur.png`
3. **Séquence** — `src/diagrammes-*/sequence-*.png`
4. **Déploiement** — `src/diagrammes-generaux/04-deploiement.png`
5. **État / Activité** — `src/diagrammes-blockchain-bdd/04-blockchain-etats.png`

## 🖼️ Convention pour les images

Toutes les images (PNG) sont stockées dans `docs/src/` et référencées
depuis les fichiers Markdown avec des chemins relatifs.

Exemple depuis `docs/client/architecture-client.md` :

```markdown
![Architecture client](../src/diagrammes-client/00-architecture-client.png)

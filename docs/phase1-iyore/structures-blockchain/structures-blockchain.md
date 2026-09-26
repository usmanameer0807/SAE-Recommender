# Structures de la blockchain

**Projet :** SAÉ BUT2 S3 2026-2027
**Thème :** Langages de programmation
**Responsable :** Iyore
**Partie :** Blockchain + PostgreSQL
**Date :** 26 septembre 2026

---

## 1. Objectif

Ce document décrit les structures de la blockchain du projet SAE-Recommender.

---

## 2. Structure d'un bloc

Un bloc contient les champs suivants :

Le champ id est un int qui identifie le bloc de manière unique.

Le champ timestamp est un long qui représente la date de création du bloc en epoch.

Le champ data est un tableau de char de 1024 caractères qui contient les données de l'action validée.

Le champ prev_hash est un tableau de char de 65 caractères qui contient le hash du bloc précédent.

Le champ nonce est un int utilisé pour la preuve de travail.

Le champ hash est un tableau de char de 65 caractères qui contient le hash courant du bloc.

---

## 3. Bloc genesis

Le premier bloc de la blockchain est appelé genesis.

Ses caractéristiques sont : id = 0, prev_hash = "0000000000000000000000000000000000000000000000000000000000000000", nonce = 0, data = "GENESIS".

---

## 4. Calcul du hash

Le hash d'un bloc est calculé avec SHA-256.

La formule est : hash = SHA-256(data + prev_hash + nonce).

Le résultat est une chaîne de 64 caractères hexadécimaux.

---

## 5. Preuve de travail

Le minage consiste à faire varier le nonce jusqu'à obtenir un hash respectant un motif.

Le motif attendu est un nombre N de zéros au début du hash.

La difficulté est fixée à 3 ou 4 selon les performances attendues.

Pour difficulté 3, un hash valide commence par "000".

Pour difficulté 4, un hash valide commence par "0000".

---

## 6. Vérification de la cohérence

La fonction verify_chain() contrôle quatre choses.

Premièrement, la validité du hash de chaque bloc.

Deuxièmement, la cohérence du prev_hash avec le hash du bloc précédent.

Troisièmement, le respect de la preuve de travail.

Quatrièmement, la détection d'une donnée modifiée frauduleusement.

---

## 7. Structure Blockchain

La structure Blockchain contient un tableau de blocs, un compteur de taille, une difficulté et un mutex.

Le mutex protège l'accès concurrent à la blockchain entre les threads.

---

## 8. Récapitulatif

| Champ | Type | Description |
|-------|------|-------------|
| id | int | Identifiant unique |
| timestamp | long | Date de création |
| data | char[1024] | Données de l'action |
| prev_hash | char[65] | Hash précédent |
| nonce | int | Preuve de travail |
| hash | char[65] | Hash courant |

---

## 9. Validation

| Rôle | Nom | Statut |
|------|-----|--------|
| Blockchain | Iyore | ⏳ |
| Serveur C | Mai | ⏳ |
| Serveur C | Albine | ⏳ |

---

**Fin du document.**

# Documentation blockchain

**Projet :** SAÉ BUT2 S3 2026-2027
**Thème :** Langages de programmation
**Responsable :** Iyore
**Partie :** Blockchain + PostgreSQL
**Date :** 26 septembre 2026

---

## 1. Objectif

Ce document décrit le fonctionnement de la blockchain du projet SAE-Recommender.

---

## 2. Definition

La blockchain est une liste chaînée sécurisée de blocs.

Chaque bloc contient un hash du bloc précédent, ce qui rend la chaîne infalsifiable.

---

## 3. Composants

La blockchain contient trois composants principaux.

Premièrement, les blocs qui contiennent les données.

Deuxièmement, le mécanisme de hashage SHA-256.

Troisièmement, la preuve de travail qui sécurise l'ajout de blocs.

---

## 4. Minage

Le minage consiste à trouver un nonce tel que le hash du bloc commence par un certain nombre de zéros.

L'algorithme est le suivant : initialiser nonce à 0, calculer SHA-256(data + prev_hash + nonce), vérifier si le hash commence par N zéros, si non incrémenter nonce et recommencer.

---

## 5. Verification

La vérification de la blockchain s'appelle verify_chain().

Elle parcourt tous les blocs et vérifie quatre choses.

Le hash de chaque bloc est valide.

Le prev_hash correspond au hash du bloc précédent.

La preuve de travail est respectée.

Aucune donnée n'a été modifiée frauduleusement.

---

## 6. Persistance

Les blocs sont sauvegardés en base PostgreSQL.

La table blocks contient tous les blocs.

Le serveur C lit et écrit dans cette table via libpq.

---

## 7. Detection de fraude

Si une donnée d'un bloc est modifiée, le hash du bloc change.

La vérification détecte alors l'incohérence.

Le serveur peut alors signaler BLOCKCHAIN_CORRUPTED.

---

## 8. Validation

| Rôle | Nom | Statut |
|------|-----|--------|
| Blockchain | Iyore | ⏳ |
| Serveur C | Mai | ⏳ |
| Serveur C | Albine | ⏳ |

---

**Fin du document.**

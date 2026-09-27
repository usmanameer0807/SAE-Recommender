# 📄 DOCUMENT 2 — `repartition-roles.md`

# Répartition des rôles — SAE-Recommender

> **Projet :** SAÉ BUT2 — S3 2026-2027
> **Thème :** Langages de programmation
> **Date :** 15 septembre 2026

---

## 📑 Sommaire

1. [Composition de l'équipe](#1-composition-de-léquipe)
2. [Détail des rôles](#2-détail-des-rôles)

   * [Usman + Omar — Client Java + JavaFX](#21-usman--omar--client-java--javafx)
   * [Mai + Albine — Serveur C + Sockets](#22-mai--albine--serveur-c--sockets)
   * [Iyore — Blockchain + PostgreSQL](#23-iyore--blockchain--postgresql)
3. [Répartition des tâches — Phase 1](#3-répartition-des-tâches-phase-1-page-8-du-cahier-des-charges)
4. [Répartition des tâches — Phase 2](#4-répartition-des-tâches-phase-2-codage)
5. [Répartition des tâches — Phase 3](#5-répartition-des-tâches-phase-3-qualité)
6. [Répartition des tâches — Phase 4](#6-répartition-des-tâches-phase-4-présentation)
7. [Planning — Phase 1](#7-planning-phase-1-4-semaines)
8. [Outils de communication](#8-outils-de-communication)
9. [Règles de collaboration](#9-règles-de-collaboration)
10. [Récapitulatif](#10-récapitulatif)

---

## 1. Composition de l'équipe

L'équipe est composée de **5 membres**, répartis en **2 binômes et 1 personne seule**.

| Membre     | Partie                       | Technologies              |
| :--------- | :--------------------------- | :------------------------ |
| **Usman**  | Client Java + JavaFX + Tests | Java, JavaFX, JUnit, Gson |
| **Omar**   | Client Java + JavaFX + Tests | Java, JavaFX, JUnit, Gson |
| **Mai**    | Serveur C + Sockets + Tests  | C, pthreads, sockets      |
| **Albine** | Serveur C + Sockets + Tests  | C, pthreads, sockets      |
| **Iyore**  | Blockchain + PostgreSQL      | C, SHA-256, PostgreSQL    |

---

## 2. Détail des rôles

### 2.1 Usman + Omar — Client Java + JavaFX

#### Responsabilités

* Concevoir l'architecture du client JavaFX
* Développer les interfaces graphiques avec **FXML**
* Coder les contrôleurs JavaFX
* Gérer la communication par socket avec le serveur
* Sérialiser et désérialiser les données JSON avec **Gson**
* Écrire les tests unitaires avec **JUnit**

#### Livrables — Phase 1

* Architecture des clients
* Organisation des données côté client
* Diagrammes de séquence client
* Maquette JavaFX
* Cas d'erreur client
* Protocole applicatif — rédaction

#### Livrables — Phase 2

* Code Java complet
* Fichiers FXML
* Feuille de style CSS
* Tests JUnit

---

### 2.2 Mai + Albine — Serveur C + Sockets

#### Responsabilités

* Concevoir l'architecture du serveur C
* Développer le serveur multitâche avec **pthreads**
* Gérer les sockets TCP
* Parser le JSON reçu avec **cJSON**
* Valider les actions demandées
* Écrire les tests C

#### Livrables — Phase 1

* Architecture du serveur
* Organisation des données côté serveur
* Diagrammes de séquence serveur
* Cas d'erreur serveur
* Protocole applicatif — validation

#### Livrables — Phase 2

* Code C complet
* `Makefile`
* Tests C

---

### 2.3 Iyore — Blockchain + PostgreSQL

#### Responsabilités

* Concevoir les structures de la blockchain
* Implémenter le hachage **SHA-256**
* Implémenter la preuve de travail (**PoW**)
* Concevoir le schéma relationnel PostgreSQL
* Gérer la persistance des blocs

#### Livrables — Phase 1

* Structures de données de la blockchain
* Schéma relationnel de la base de données
* Diagrammes de la blockchain
* Documentation blockchain

#### Livrables — Phase 2

* Code blockchain en C
* Schémas SQL
* Scripts d'initialisation

---

## 3. Répartition des tâches — Phase 1

### Page 8 du cahier des charges

|  # | Tâche                            | Usman + Omar | Mai + Albine |     Iyore     |
| -: | :------------------------------- | :----------: | :----------: | :-----------: |
|  1 | Répartition des rôles            |       ✅      |       ✅      |       ✅       |
|  2 | Architecture du serveur          |    🟠 Aide   |  ✅ Principal |       —       |
|  3 | Architecture des clients         |  ✅ Principal |       —      |       —       |
|  4 | Organisation des données serveur |    🟠 Aide   |  ✅ Principal |    🟠 Aide    |
|  5 | Organisation des données client  |  ✅ Principal |       —      | 🟠 Validation |
|  6 | Schéma relationnel BDD           |       —      |    🟠 Aide   |  ✅ Principal  |
|  7 | Structures blockchain            |       —      |    🟠 Aide   |  ✅ Principal  |
|  8 | Données cartes / recos / battles |       ✅      |       ✅      |       ✅       |
|  9 | Règles métier                    |       ✅      |       ✅      |       ✅       |
| 10 | Diagrammes de séquence           |   ✅ Client   |   ✅ Serveur  |     🟠 BDD    |
| 11 | Protocole applicatif             |  ✅ Rédaction | ✅ Validation |       —       |
| 12 | Cas d'erreur                     |   ✅ Client   |   ✅ Serveur  |     🟠 BDD    |

### Légende

* **✅ Principal** : responsable de la tâche
* **🟠 Aide / Validation** : participe à la tâche
* **—** : aucune responsabilité directe

---

## 4. Répartition des tâches — Phase 2

### Codage

|  # | Tâche                  | Responsable      |
| -: | :--------------------- | :--------------- |
|  1 | Code client JavaFX     | **Usman + Omar** |
|  2 | Fichiers FXML + CSS    | **Usman + Omar** |
|  3 | Tests JUnit            | **Usman + Omar** |
|  4 | Code serveur C         | **Mai + Albine** |
|  5 | Makefile + compilation | **Mai + Albine** |
|  6 | Tests C                | **Mai + Albine** |
|  7 | Code blockchain        | **Iyore**        |
|  8 | Schémas PostgreSQL     | **Iyore**        |
|  9 | Tests d'intégration    | **Tous**         |

---

## 5. Répartition des tâches — Phase 3

### Qualité

|  # | Tâche                                     | Responsable |
| -: | :---------------------------------------- | :---------- |
|  1 | Mise à jour de la spécification technique | **Tous**    |
|  2 | Diagramme de Gantt                        | **Usman**   |
|  3 | Commentaires du code — anglais            | **Tous**    |
|  4 | En-têtes des fonctions                    | **Tous**    |
|  5 | Tests unitaires                           | **Tous**    |
|  6 | Organisation GitLab                       | **Tous**    |

---

## 6. Répartition des tâches — Phase 4

### Présentation

|  # | Tâche                  | Responsable |
| -: | :--------------------- | :---------- |
|  1 | Introduction           | **Usman**   |
|  2 | Organisation du groupe | **Omar**    |
|  3 | Architecture serveur   | **Mai**     |
|  4 | Architecture clients   | **Omar**    |
|  5 | Structures de données  | **Albine**  |
|  6 | Base de données        | **Iyore**   |
|  7 | Blockchain             | **Iyore**   |
|  8 | Protocole applicatif   | **Usman**   |
|  9 | Diagramme de séquence  | **Mai**     |
| 10 | Problème technique     | **Omar**    |
| 11 | Conclusion             | **Mai**     |

---

## 7. Planning — Phase 1

### 4 semaines

### 📅 Semaine 1 — 22 au 28 septembre

| Jour     | Tâche                        | Responsable |
| :------- | :--------------------------- | :---------: |
| **Lun.** | Réunion — vocabulaire commun |     Tous    |
| **Mar.** | Rédaction du vocabulaire     |    Usman    |
| **Mer.** | Réunion — règles métier      |     Tous    |
| **Jeu.** | Rédaction des règles métier  |    Usman    |
| **Ven.** | Réunion — protocole          |     Tous    |

---

### 📅 Semaine 2 — 29 septembre au 5 octobre

| Jour     | Tâche                     | Responsable |
| :------- | :------------------------ | :---------: |
| **Lun.** | Rédaction du protocole    |    Usman    |
| **Mar.** | Création des diagrammes   |     Tous    |
| **Mer.** | Diagrammes d'architecture |     Tous    |
| **Jeu.** | Diagrammes de séquence    |     Tous    |
| **Ven.** | Réunion de validation     |     Tous    |

---

### 📅 Semaine 3 — 6 au 12 octobre

| Jour            | Tâche                                   | Responsable |
| :-------------- | :-------------------------------------- | :---------: |
| **Lun. → Ven.** | Rédaction de la spécification technique |     Tous    |

---

### 📅 Semaine 4 — 13 au 19 octobre

| Jour             | Tâche                     | Responsable |
| :--------------- | :------------------------ | :---------: |
| **Lun. → Jeu.**  | Corrections + push GitLab |     Tous    |
| **Ven. 19 oct.** | **🚨 DEADLINE — PHASE 1** |   **Tous**  |

---

## 8. Outils de communication

| Outil        | Usage                     |
| :----------- | :------------------------ |
| **WhatsApp** | Communication quotidienne |
| **Discord**  | Réunions vocales          |
| **GitLab**   | Versioning + livrables    |
| **Email**    | Communication formelle    |

---

## 9. Règles de collaboration

| Règle                    | Description               |
| :----------------------- | :------------------------ |
| **Réunion hebdomadaire** | 1 h par semaine           |
| **Push GitLab**          | Tous les 2 jours          |
| **Commit message**       | Clair et en français      |
| **Branches**             | 1 branche par phase       |
| **Revue de code**        | Croisée entre les binômes |

---

## 10. Récapitulatif

| Membre     | Partie           | Livrables principaux                       |
| :--------- | :--------------- | :----------------------------------------- |
| **Usman**  | Client Java      | Architecture client, diagrammes, protocole |
| **Omar**   | Client Java      | FXML, contrôleurs, tests                   |
| **Mai**    | Serveur C        | Architecture serveur, sockets              |
| **Albine** | Serveur C        | Multitâche, tests C                        |
| **Iyore**  | Blockchain + BDD | Structures des blocs, schéma SQL           |


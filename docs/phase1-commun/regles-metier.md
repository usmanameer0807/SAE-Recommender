# 📄 DOCUMENT 3 — `regles-metier.md`

# Règles métier — SAE-Recommender

> **Projet :** SAÉ BUT2 — S3 2026-2027
> **Thème :** Langages de programmation


---

## 📑 Sommaire

1. [Valeur d'une carte (VA)](#1-valeur-dune-carte-va)
2. [Critère de proximité (battle)](#2-critère-de-proximité-battle)
3. [Légitimation](#3-légitimation)
4. [Battle](#4-battle)
5. [Vote pondéré](#5-vote-pondéré)
6. [Revendication](#6-revendication)
7. [Authentification](#7-authentification)
8. [Cycle de vie d'une carte](#8-cycle-de-vie-dune-carte)
9. [Client bot (optionnel)](#9-client-bot-optionnel)
10. [Partage ciblé (optionnel)](#10-partage-ciblé-optionnel)
11. [Codes d'erreur](#11-codes-derreur)
12. [Récapitulatif des choix](#12-récapitulatif-des-choix)

---

## 1. Valeur d'une carte (VA)

### 1.1 Règle

La **VA (Valeur d'Appréciation)** représente la valeur d'une carte au sein de l'application.

| Action                  |                                     Impact sur la VA |
| :---------------------- | ---------------------------------------------------: |
| 1 recommandation active |                                            **+1 VA** |
| 1 authentification      |                              **+10 VA** — bonus fixe |
| Victoire en battle      | **Transfert de 50 %** des recommandations du perdant |
| Défaite en battle       |                **Perte de 50 %** des recommandations |

### 1.2 Formule

La valeur d'une carte est calculée à partir du nombre de recommandations actives et des authentifications :

```text
VA(carte) = nb_recommandations_actives + (10 × nb_authentifications)
```

### 1.3 Justification

* Mesure l'impact global de l'utilisateur.
* Encourage la création de cartes de qualité.
* Permet un calcul simple et compréhensible.

---

## 2. Critère de proximité (battle)

### 2.1 Règle

Deux cartes peuvent s'affronter dans une **battle** si elles possèdent le même champ `paradigm`.

### 2.2 Exemples

| Carte 1          | Carte 2                | Battle autorisée ? |
| :--------------- | :--------------------- | :----------------: |
| Java (`OBJECT`)  | C++ (`OBJECT`)         |        ✅ Oui       |
| Python (`MULTI`) | JavaScript (`MULTI`)   |        ✅ Oui       |
| Java (`OBJECT`)  | Haskell (`FUNCTIONAL`) |        ❌ Non       |

### 2.3 Justification

* Permet de comparer des langages comparables.
* Évite les battles incohérentes.
* Correspond à une logique naturelle pour le domaine des langages de programmation.

---

## 3. Légitimation

### 3.1 Conditions

Un utilisateur peut demander la **légitimation** s'il remplit **au moins une** des conditions suivantes :

| Option | Condition                                           |
| :----: | :-------------------------------------------------- |
|  **A** | Avoir émis au moins **5 recommandations valides**   |
|  **B** | Être validé par le **créateur initial** de la carte |

### 3.2 Droits accordés

Une fois légitimé, l'utilisateur obtient les droits suivants :

| Droit            | Description                      |
| :--------------- | :------------------------------- |
| **Authentifier** | Ajouter **+10 VA** à une carte   |
| **Revendiquer**  | Devenir propriétaire d'une carte |

### 3.3 Statuts

| Statut     | Signification         |
| :--------- | :-------------------- |
| `PENDING`  | Demande en attente    |
| `GRANTED`  | Légitimation accordée |
| `REJECTED` | Légitimation refusée  |

### 3.4 Justification

* Évite le spam de demandes de légitimation.
* Offre une alternative simple pour la simulation.
* Correspond au processus défini dans le cahier des charges.
* Aucune vérification d'identité réelle n'est effectuée.

---

## 4. Battle

### 4.1 Conditions de lancement

Une battle peut être lancée uniquement si toutes les conditions suivantes sont respectées :

| Condition         | Valeur                           |
| :---------------- | :------------------------------- |
| Nombre de cartes  | Exactement **2**                 |
| Statut requis     | `ACTIVE`                         |
| Paradigme         | Identique                        |
| VA minimum        | **5 VA**                         |
| Battle simultanée | **1 seule par carte**            |
| Durée             | **60 secondes**                  |
| Lanceur           | Doit posséder **1 des 2 cartes** |

### 4.2 Règles de vote

| Règle           | Valeur                                           |
| :-------------- | :----------------------------------------------- |
| Votants         | Tous sauf les **2 propriétaires**                |
| Nombre de votes | **1 par utilisateur**                            |
| Pondération     | Nombre de recommandations émises (**minimum 1**) |
| Signature       | SHA-256                                          |
| Vote blanc      | Interdit                                         |
| Égalité         | La carte ayant la **VA la plus élevée** gagne    |

### 4.3 Résolution de la battle

| Étape | Action                                                          |
| ----: | :-------------------------------------------------------------- |
| **1** | Déterminer le gagnant                                           |
| **2** | Transférer **50 %** des recommandations du perdant              |
| **3** | Incrémenter `winCount` du gagnant                               |
| **4** | Si la VA du perdant atteint **0**, passer la carte à `INACTIVE` |
| **5** | Enregistrer un bloc dans la blockchain                          |

### 4.4 Justification

* Le transfert de **50 %** constitue un compromis.
* Le transfert crée un enjeu lors de la battle.
* La pondération valorise les utilisateurs actifs.
* Une durée de **60 secondes** est suffisante pour permettre le vote.

---

## 5. Vote pondéré

### 5.1 Règle

Le poids d'un vote correspond au **nombre de recommandations émises par l'utilisateur**.

| Utilisateur | Recommandations émises |   Poids du vote |
| :---------- | ---------------------: | --------------: |
| `usman`     |                     12 |          **12** |
| `alice`     |                      5 |           **5** |
| `bob`       |                      0 | **1** — minimum |

> **Règle :** le poids minimum d'un vote est fixé à **1**, même si l'utilisateur n'a encore émis aucune recommandation.

### 5.2 Justification

* Valorise les utilisateurs actifs.
* Évite que les votes des comptes sans activité aient tous le même poids.
* Garantit un poids minimum de **1** pour les nouveaux utilisateurs.

---

## 6. Revendication

### 6.1 Conditions

| Condition    | Détail                                          |
| :----------- | :---------------------------------------------- |
| Demandeur    | `isLegitimate = true`                           |
| Cible        | Carte appartenant à un utilisateur non légitime |
| Délai        | **10 blocs** de contestation                    |
| Contestation | Le propriétaire actuel peut contester           |

### 6.2 Résultat

En cas de revendication acceptée :

* Changement de propriétaire.
* Enregistrement d'un bloc `ACTION_CLAIM_CARD`.
* Aucun dédommagement financier.

### 6.3 Justification

* Permet à un utilisateur légitime de reprendre le contrôle d'une carte.
* Le délai laisse une possibilité de contestation au propriétaire actuel.
* Aucune transaction monétaire n'est nécessaire.

---

## 7. Authentification

### 7.1 Conditions

| Condition      | Détail                          |
| :------------- | :------------------------------ |
| Acteur         | Utilisateur légitime            |
| Cible          | Carte `ACTIVE` non authentifiée |
| Effet          | **+10 VA**                      |
| Nouveau statut | `AUTHENTIFIED`                  |

### 7.2 Effets

| Effet            | Description                                              |
| :--------------- | :------------------------------------------------------- |
| **Bonus**        | **+10 VA**                                               |
| **Verrouillage** | Les informations ne sont plus modifiables                |
| **Badge**        | Affichage du badge **« Certifiée »**                     |
| **Traçabilité**  | Enregistrement de `authenticatedBy` et `authenticatedAt` |

### 7.3 Justification

* Ajoute de la valeur à une carte vérifiée.
* Offre un bonus significatif sans être excessif.
* Protège les informations validées.
* Constitue un processus simulé.

---

## 8. Cycle de vie d'une carte

### 8.1 Diagramme

```text
             ┌──────────┐
             │  CREATE  │
             │   CARD   │
             └────┬─────┘
                  │
                  ▼
             ┌──────────┐
             │  ACTIVE  │
             └────┬─────┘
                  │
        ┌─────────┼──────────┐
        │         │          │
        ▼         ▼          ▼
   RECOMMEND  AUTHENTICATE  BATTLE
        │         │          │
        │         ▼          │
        │    AUTHENTIFIED    │
        │                    │
        │              ┌─────┴─────┐
        │              │           │
        │              ▼           ▼
        │          VICTOIRE     DÉFAITE
        │              │           │
        │              ▼           ▼
        │           ACTIVE     VA = 0 ?
        │                          │
        │                          ▼
        │                      INACTIVE
        │                          │
        │                    Réactivation
        │                          │
        └──────────────────────────┘
```

### 8.2 Transitions

| De          | Vers           | Condition                   |
| :---------- | :------------- | :-------------------------- |
| `[*]`       | `ACTIVE`       | `CREATE_CARD`               |
| `ACTIVE`    | `ACTIVE`       | `RECOMMEND` — **+1 VA**     |
| `ACTIVE`    | `AUTHENTIFIED` | `AUTHENTICATE` — **+10 VA** |
| `ACTIVE`    | `IN_BATTLE`    | `START_BATTLE`              |
| `IN_BATTLE` | `ACTIVE`       | Victoire                    |
| `IN_BATTLE` | `INACTIVE`     | Défaite + **VA = 0**        |
| `ACTIVE`    | `INACTIVE`     | Demande légitime            |
| `INACTIVE`  | `ACTIVE`       | Réactivation                |

### 8.3 Règles d'inactivation

Une carte devient `INACTIVE` dans les cas suivants :

* Elle perd une battle et sa VA tombe à **0**.
* Un utilisateur légitime demande son inactivation.

#### Une carte `INACTIVE`

| Action                               | Autorisée ? |
| :----------------------------------- | :---------: |
| Recommander la carte                 |      ❌      |
| Participer à une battle              |      ❌      |
| Conserver la carte dans l'historique |      ✅      |
| Réactiver la carte                   |      ✅      |

### 8.4 Justification

* Permet de nettoyer les cartes devenues inutiles.
* Conserve l'historique des cartes.
* Permet une réactivation ultérieure.

---

## 9. Client bot (optionnel)

### 9.1 Caractéristiques

| Caractéristique | Valeur                                  |
| :-------------- | :-------------------------------------- |
| Type            | Java sans GUI                           |
| Identification  | `isBot = true`                          |
| Comportement    | Crée des cartes, recommande et vote     |
| Impact VA       | Pas de VA artificielle                  |
| Limites         | Ne peut pas revendiquer ni authentifier |

### 9.2 Distinction bot / humain

La distinction entre un bot et un utilisateur humain repose sur plusieurs éléments :

* Champ `isBot` dans la BDD.
* Préfixe `[BOT]` dans les logs.
* Affichage avec une couleur différente dans l'interface.

### 9.3 Justification

* Facilite les tests.
* Aide à la démonstration.
* N'affecte pas artificiellement la VA.
* Respecte le principe prévu dans le cahier des charges.

---

## 10. Partage ciblé (optionnel)

### 10.1 Règle

Un utilisateur peut partager une carte avec un autre utilisateur.

### 10.2 Différence avec une recommandation

| Mécanisme          | Effet                                          |
| :----------------- | :--------------------------------------------- |
| **Recommandation** | Augmente la VA                                 |
| **Partage ciblé**  | Transmet l'information à un utilisateur précis |

### 10.3 Champs

| Champ      | Description               |
| :--------- | :------------------------ |
| `sharedBy` | Utilisateur qui partage   |
| `sharedTo` | Destinataire              |
| `sharedAt` | Date du partage           |
| `accepted` | `true` / `false` / `null` |

### 10.4 Justification

* Fonctionnalité optionnelle.
* Permet de découvrir de nouvelles cartes.
* Permet d'envoyer une notification au destinataire.

---

## 11. Codes d'erreur

| Code                    | Signification         |
| :---------------------- | :-------------------- |
| `INVALID_DATA`          | Champs invalides      |
| `USERNAME_TAKEN`        | Pseudo pris           |
| `CARD_NOT_FOUND`        | Carte inexistante     |
| `CARD_NOT_ACTIVE`       | Carte inactive        |
| `DUPLICATE_CARD`        | Carte existante       |
| `ALREADY_RECOMMENDED`   | Déjà recommandée      |
| `NOT_RECOMMENDED`       | Rien à répudier       |
| `BATTLE_NOT_FOUND`      | Battle inexistante    |
| `BATTLE_ALREADY_ACTIVE` | Carte en battle       |
| `ALREADY_VOTED`         | Déjà voté             |
| `NOT_LEGITIMATE`        | Non légitime          |
| `THRESHOLD_NOT_REACHED` | Seuil non atteint     |
| `CARDS_NOT_COMPATIBLE`  | Paradigmes différents |
| `VA_TOO_LOW`            | VA < 5                |
| `ALREADY_AUTHENTICATED` | Déjà authentifiée     |
| `SERVER_BUSY`           | Serveur plein         |
| `INTERNAL_ERROR`        | Erreur interne        |

---

## 12. Récapitulatif des choix

|  # | Choix               | Valeur                            | Justification                     |
| -: | :------------------ | :-------------------------------- | :-------------------------------- |
|  1 | Nature des cartes   | Langages                          | Formation informatique            |
|  2 | Proximité battle    | Même `paradigm`                   | Comparaison pertinente            |
|  3 | VA recommandation   | **+1**                            | Simple et mesurable               |
|  4 | VA authentification | **+10**                           | Bonus significatif                |
|  5 | VA utilisateur      | Somme des VA des cartes           | Mesure de l'impact global         |
|  6 | Légitimation        | **5 recommandations OU créateur** | Évite le spam                     |
|  7 | Battle              | **2 cartes, VA ≥ 5**              | Comparaison équitable             |
|  8 | Durée battle        | **60 secondes**                   | Suffisant pour voter              |
|  9 | Vote                | **1 par utilisateur, pondéré**    | Valorise l'activité               |
| 10 | Transfert battle    | **50 % des recommandations**      | Enjeu sans ruine                  |
| 11 | Inactivation        | **VA = 0**                        | Nettoyage naturel                 |
| 12 | Revendication       | **Délai de 10 blocs**             | Laisse une chance au propriétaire |
| 13 | Authentification    | **+10 VA**                        | Garantie de qualité               |
| 14 | Client bot          | **Optionnel**                     | Aide à la démonstration           |
| 15 | Partage ciblé       | **Optionnel**                     | Fonctionnalité supplémentaire     |

---


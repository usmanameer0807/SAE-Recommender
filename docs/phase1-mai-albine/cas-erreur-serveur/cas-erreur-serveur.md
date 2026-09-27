# Cas d'erreur côté serveur

**Projet :** SAÉ BUT2 S3 2026-2027
**Thème :** Langages de programmation
**Responsables :** Mai + Albine
**Partie :** Serveur C + Sockets

---

## 1. Objectif

Ce document liste les cas d'erreur que le serveur C doit gérer.

---

## 2. Format des erreurs

Toutes les erreurs suivent le format :

{"status":"ERROR","code":"CODE","message":"Message lisible"}

---

## 3. Liste des codes d'erreur serveur

Le code INVALID_DATA signifie que les champs sont invalides.

Le code USERNAME_TAKEN signifie que le pseudo est déjà utilisé.

Le code CARD_NOT_FOUND signifie que la carte est inexistante.

Le code CARD_NOT_ACTIVE signifie que la carte est inactive.

Le code DUPLICATE_CARD signifie que la carte existe déjà.

Le code ALREADY_RECOMMENDED signifie que la carte a déjà été recommandée.

Le code NOT_RECOMMENDED signifie qu'il n'y a aucune recommandation à répudier.

Le code BATTLE_NOT_FOUND signifie que la battle est inexistante.

Le code BATTLE_ALREADY_ACTIVE signifie que la carte est déjà en battle.

Le code ALREADY_VOTED signifie que l'utilisateur a déjà voté.

Le code NOT_LEGITIMATE signifie que l'utilisateur n'est pas légitime.

Le code THRESHOLD_NOT_REACHED signifie que le seuil n'est pas atteint.

Le code CARDS_NOT_COMPATIBLE signifie que les paradigmes sont différents.

Le code VA_TOO_LOW signifie que la VA est inférieure à 5.

Le code ALREADY_AUTHENTICATED signifie que la carte est déjà authentifiée.

Le code SERVER_BUSY signifie que le serveur est plein.

Le code INTERNAL_ERROR signifie qu'une erreur interne est survenue.

---

## 4. Gestion côté serveur

Le serveur vérifie chaque action avant de la valider.

Si une vérification échoue, il renvoie une erreur sans miner de bloc.

Il n'écrit rien en base de données en cas d'erreur.

---

## 5. Validation

| Rôle | Nom | Statut |
|------|-----|--------|
| Serveur C | Mai | ⏳ |
| Serveur C | Albine | ⏳ |
| Client Java | Usman | ⏳ |

---

**Fin du document.**

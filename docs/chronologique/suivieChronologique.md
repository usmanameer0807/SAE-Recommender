cd ~/SAE-main/SAE-Recommender/docs/phase1 && \
cat > suivi-chronologique.md << 'EOF'
# Suivi chronologique — Phase 1 SAE-Recommender

**Projet :** SAÉ BUT2 S3 2026-2027
**Thème :** Langages de programmation
**Date de début :** 15 septembre 2026
**Date de fin :** 2 octobre 2026
**Durée totale :** 18 jours

---

## 1. Vue d'ensemble

| Semaine | Dates | Tâches | Statut |
|---------|-------|--------|--------|
| S1 | 15-21 sept | Vocabulaire + Répartition + Règles + Architecture | ✅ |
| S2 | 22-28 sept | Protocole + Cas erreur + Spec + Diagrammes | ✅ |
| S3 | 29 sept-2 oct | Validation + Push GitLab | ⏳ |

---

## 2. Tableau principal — Livrables COMMUNS

| # | Fichier / Diagramme | Type | Début | Fin | Auteur | Statut |
|---|---------------------|------|-------|-----|--------|--------|
| 1 | `vocabulaire-commun.md` | MD | 15/09 | 17/09 | Usman | ✅ |
| 2 | `repartition-roles.md` | MD | 17/09 | 18/09 | Usman | ✅ |
| 3 | `regles-metier.md` | MD | 18/09 | 20/09 | Usman | ✅ |
| 4 | `protocole-applicatif.md` | MD | 20/09 | 23/09 | Usman | ✅ |
| 5 | `cas-erreur.md` | MD | 23/09 | 24/09 | Usman | ✅ |
| 6 | `specification-technique.md` | MD | 24/09 | 27/09 | Usman | ✅ |
| 7 | `mapping-donnees.md` | MD | 26/09 | 27/09 | Usman | ⏳ |
| 8 | `00-architecture-globale.puml` | PUML | 15/09 | 15/09 | Tous | ✅ |
| 9 | `01-architecture-serveur.puml` | PUML | 18/09 | 18/09 | Mai | ✅ |
| 10 | `02-architecture-client.puml` | PUML | 18/09 | 18/09 | Usman | ✅ |
| 11 | `03-classes-client.puml` | PUML | 19/09 | 19/09 | Usman | ✅ |
| 12 | `04-classes-serveur.puml` | PUML | 19/09 | 19/09 | Mai | ✅ |
| 13 | `05-schema-bdd.puml` | PUML | 20/09 | 20/09 | Iyore | ✅ |
| 14 | `06-cas-utilisation.puml` | PUML | 20/09 | 20/09 | Usman | ✅ |
| 15 | `07-seq-login.puml` | PUML | 21/09 | 21/09 | Tous | ✅ |
| 16 | `08-seq-create-card.puml` | PUML | 21/09 | 21/09 | Tous | ✅ |
| 17 | `09-seq-recommend.puml` | PUML | 22/09 | 22/09 | Tous | ✅ |
| 18 | `10-seq-battle.puml` | PUML | 22/09 | 22/09 | Tous | ✅ |
| 19 | `11-seq-legitimation.puml` | PUML | 23/09 | 23/09 | Tous | ✅ |
| 20 | `12-seq-authentification.puml` | PUML | 23/09 | 23/09 | Tous | ✅ |
| 21 | `13-seq-revendication.puml` | PUML | 24/09 | 24/09 | Tous | ✅ |
| 22 | `14-seq-disconnect.puml` | PUML | 24/09 | 24/09 | Tous | ✅ |

---

## 3. Tableau — Partie USMAN + OMAR (Client Java)

| # | Fichier / Diagramme | Type | Début | Fin | Statut |
|---|---------------------|------|-------|-----|--------|
| 1 | `00-architecture-client.puml` | PUML | 22/09 | 22/09 | ✅ |
| 2 | `01-diagramme-cas-utilisation.puml` | PUML | 22/09 | 22/09 | ✅ |
| 3 | `02-diagramme-classes.puml` | PUML | 22/09 | 22/09 | ✅ |
| 4 | `03-sequence-login.puml` | PUML | 23/09 | 23/09 | ✅ |
| 5 | `04-sequence-create-card.puml` | PUML | 23/09 | 23/09 | ✅ |
| 6 | `05-sequence-recommend.puml` | PUML | 23/09 | 23/09 | ✅ |
| 7 | `06-sequence-repudiate.puml` | PUML | 24/09 | 24/09 | ✅ |
| 8 | `07-sequence-battle.puml` | PUML | 24/09 | 24/09 | ✅ |
| 9 | `08-sequence-vote.puml` | PUML | 24/09 | 24/09 | ✅ |
| 10 | `09-sequence-legitimation.puml` | PUML | 25/09 | 25/09 | ✅ |
| 11 | `10-sequence-authentification.puml` | PUML | 25/09 | 25/09 | ✅ |
| 12 | `11-sequence-revendication.puml` | PUML | 25/09 | 25/09 | ✅ |
| 13 | `12-sequence-disconnect.puml` | PUML | 25/09 | 25/09 | ✅ |
| 14 | `13-navigation-javafx.puml` | PUML | 25/09 | 25/09 | ✅ |
| 15 | `14-maquette-login.puml` | PUML | 25/09 | 25/09 | ✅ |
| 16 | `15-maquette-main.puml` | PUML | 25/09 | 25/09 | ✅ |
| 17 | `16-maquette-cards.puml` | PUML | 25/09 | 25/09 | ✅ |
| 18 | `17-maquette-create-card.puml` | PUML | 25/09 | 25/09 | ✅ |
| 19 | `18-maquette-battles.puml` | PUML | 25/09 | 25/09 | ✅ |
| 20 | `19-maquette-profile.puml` | PUML | 25/09 | 25/09 | ✅ |
| 21 | `organisation-donnees-client.md` | MD | 24/09 | 24/09 | ✅ |
| 22 | `classes-client.md` | MD | 25/09 | 25/09 | ✅ |
| 23 | `cas-erreur-client.md` | MD | 25/09 | 25/09 | ⏳ |
| 24 | `partie-client.md` | MD | 26/09 | 26/09 | ⏳ |

---

## 4. Tableau — Partie MAI + ALBINE (Serveur C)

| # | Fichier / Diagramme | Type | Début | Fin | Statut |
|---|---------------------|------|-------|-----|--------|
| 1 | `00-architecture-serveur.puml` | PUML | 26/09 | 26/09 | ✅ |
| 2 | `01-classes-serveur.puml` | PUML | 26/09 | 26/09 | ✅ |
| 3 | `02-sequence-login-serveur.puml` | PUML | 26/09 | 26/09 | ✅ |
| 4 | `03-sequence-create-card-serveur.puml` | PUML | 26/09 | 26/09 | ✅ |
| 5 | `04-sequence-recommend-serveur.puml` | PUML | 26/09 | 26/09 | ✅ |
| 6 | `05-sequence-repudiate-serveur.puml` | PUML | 26/09 | 26/09 | ✅ |
| 7 | `06-sequence-battle-serveur.puml` | PUML | 26/09 | 26/09 | ✅ |
| 8 | `07-sequence-vote-serveur.puml` | PUML | 26/09 | 26/09 | ✅ |
| 9 | `08-sequence-battle-result-serveur.puml` | PUML | 26/09 | 26/09 | ✅ |
| 10 | `09-sequence-legitimation-serveur.puml` | PUML | 26/09 | 26/09 | ✅ |
| 11 | `10-sequence-authentification-serveur.puml` | PUML | 26/09 | 26/09 | ✅ |
| 12 | `11-sequence-disconnect-serveur.puml` | PUML | 26/09 | 26/09 | ✅ |
| 13 | `organisation-donnees-serveur.md` | MD | 26/09 | 26/09 | ✅ |
| 14 | `cas-erreur-serveur.md` | MD | 26/09 | 26/09 | ✅ |
| 15 | `validation-protocole.md` | MD | 26/09 | 26/09 | ✅ |

---

## 5. Tableau — Partie IYORE (Blockchain + BDD)

| # | Fichier / Diagramme | Type | Début | Fin | Statut |
|---|---------------------|------|-------|-----|--------|
| 1 | `00-blockchain.puml` | PUML | 26/09 | 26/09 | ✅ |
| 2 | `01-schema-bdd.puml` | PUML | 26/09 | 26/09 | ✅ |
| 3 | `02-sequence-minage.puml` | PUML | 26/09 | 26/09 | ✅ |
| 4 | `03-sequence-verification.puml` | PUML | 26/09 | 26/09 | ✅ |
| 5 | `04-blockchain-etats.puml` | PUML | 26/09 | 26/09 | ✅ |
| 6 | `structures-blockchain.md` | MD | 26/09 | 26/09 | ✅ |
| 7 | `schema-bdd.md` | MD | 26/09 | 26/09 | ✅ |
| 8 | `schema.sql` | SQL | 26/09 | 26/09 | ✅ |
| 9 | `init.sql` | SQL | 26/09 | 26/09 | ✅ |
| 10 | `documentation-blockchain.md` | MD | 26/09 | 26/09 | ✅ |

---

## 6. Tableau de synthèse par binôme

| Binôme | Livrables | PUML | MD | SQL | Statut |
|--------|-----------|------|-----|-----|--------|
| Commun | 22 | 15 | 7 | 0 | ✅ 95% |
| Usman + Omar | 24 | 20 | 4 | 0 | ✅ 90% |
| Mai + Albine | 15 | 12 | 3 | 0 | ✅ 100% |
| Iyore | 10 | 5 | 3 | 2 | ✅ 100% |
| TOTAL | 71 | 52 | 17 | 2 | ✅ 96% |

---

## 7. Chronologie globale

### Semaine 1 (15-21 septembre)

| Jour | Date | Tâche | Responsable |
|------|------|-------|-------------|
| Lun | 15/09 | Début Phase 1 | Tous |
| Lun | 15/09 | `vocabulaire-commun.md` | Usman |
| Lun | 15/09 | `00-architecture-globale.puml` | Tous |
| Mar | 16/09 | `vocabulaire-commun.md` (suite) | Usman |
| Mer | 17/09 | `vocabulaire-commun.md` (fin) | Usman |
| Mer | 17/09 | `repartition-roles.md` | Usman |
| Jeu | 18/09 | `repartition-roles.md` (fin) | Usman |
| Jeu | 18/09 | `regles-metier.md` | Usman |
| Jeu | 18/09 | `01-architecture-serveur.puml` | Mai |
| Jeu | 18/09 | `02-architecture-client.puml` | Usman |
| Ven | 19/09 | `regles-metier.md` (suite) | Usman |
| Ven | 19/09 | `03-classes-client.puml` | Usman |
| Ven | 19/09 | `04-classes-serveur.puml` | Mai |
| Sam | 20/09 | `regles-metier.md` (fin) | Usman |
| Sam | 20/09 | `protocole-applicatif.md` | Usman |
| Sam | 20/09 | `05-schema-bdd.puml` | Iyore |
| Sam | 20/09 | `06-cas-utilisation.puml` | Usman |
| Dim | 21/09 | `protocole-applicatif.md` (suite) | Usman |
| Dim | 21/09 | `07-seq-login.puml` | Tous |
| Dim | 21/09 | `08-seq-create-card.puml` | Tous |

### Semaine 2 (22-28 septembre)

| Jour | Date | Tâche | Responsable |
|------|------|-------|-------------|
| Lun | 22/09 | `protocole-applicatif.md` (fin) | Usman |
| Lun | 22/09 | `09-seq-recommend.puml` | Tous |
| Lun | 22/09 | `10-seq-battle.puml` | Tous |
| Lun | 22/09 | `00-architecture-client.puml` | Usman |
| Lun | 22/09 | `01-diagramme-cas-utilisation.puml` | Usman |
| Lun | 22/09 | `02-diagramme-classes.puml` | Usman |
| Mar | 23/09 | `cas-erreur.md` | Usman |
| Mar | 23/09 | `11-seq-legitimation.puml` | Tous |
| Mar | 23/09 | `12-seq-authentification.puml` | Tous |
| Mar | 23/09 | `03-sequence-login.puml` | Usman |
| Mar | 23/09 | `04-sequence-create-card.puml` | Usman |
| Mar | 23/09 | `05-sequence-recommend.puml` | Usman |
| Mer | 24/09 | `cas-erreur.md` (fin) | Usman |
| Mer | 24/09 | `specification-technique.md` | Usman |
| Mer | 24/09 | `13-seq-revendication.puml` | Tous |
| Mer | 24/09 | `14-seq-disconnect.puml` | Tous |
| Mer | 24/09 | `06-sequence-repudiate.puml` | Usman |
| Mer | 24/09 | `07-sequence-battle.puml` | Usman |
| Mer | 24/09 | `08-sequence-vote.puml` | Usman |
| Mer | 24/09 | `organisation-donnees-client.md` | Usman |
| Jeu | 25/09 | `specification-technique.md` (suite) | Usman |
| Jeu | 25/09 | `09-sequence-legitimation.puml` | Usman |
| Jeu | 25/09 | `10-sequence-authentification.puml` | Usman |
| Jeu | 25/09 | `11-sequence-revendication.puml` | Usman |
| Jeu | 25/09 | `12-sequence-disconnect.puml` | Usman |
| Jeu | 25/09 | `13-navigation-javafx.puml` | Usman |
| Jeu | 25/09 | `14-maquette-login.puml` | Usman |
| Jeu | 25/09 | `15-maquette-main.puml` | Usman |
| Jeu | 25/09 | `16-maquette-cards.puml` | Usman |
| Jeu | 25/09 | `17-maquette-create-card.puml` | Usman |
| Jeu | 25/09 | `18-maquette-battles.puml` | Usman |
| Jeu | 25/09 | `19-maquette-profile.puml` | Usman |
| Jeu | 25/09 | `classes-client.md` | Usman |
| Ven | 26/09 | `specification-technique.md` (fin) | Usman |
| Ven | 26/09 | `mapping-donnees.md` | Usman |
| Ven | 26/09 | Tous les fichiers Mai + Albine | Mai + Albine |
| Ven | 26/09 | Tous les fichiers Iyore | Iyore |
| Ven | 26/09 | `cas-erreur-client.md` | Usman |
| Ven | 26/09 | `partie-client.md` | Usman |
| Sam | 27/09 | `mapping-donnees.md` (fin) | Usman |
| Dim | 28/09 | Diagrammes PlantUML (génération) | Tous |

### Semaine 3 (29 septembre - 2 octobre)

| Jour | Date | Tâche | Responsable |
|------|------|-------|-------------|
| Lun | 29/09 | Validation par le groupe | Tous |
| Mar | 30/09 | Corrections | Tous |
| Mer | 1/10 | Push GitLab | Tous |
| Jeu | 2/10 | DEADLINE PHASE 1 | Tous |

---

## 8. Commandes Git

### Pour la partie Commun

```bash
cd ~/SAE-main/SAE-Recommender && \
git add docs/phase1/ && \
git commit -m "Phase 1 : documents communs et diagrammes" && \
git push origin main

# Tableau de bord Shiny – Collecte de données à Lomé

Cette application Shiny permet de suivre en temps réel la progression d'une collecte de données sur le terrain à Lomé.

## 📦 Structure

- `app.R` : Application Shiny complète.
- Dépendances : `shiny`, `tidyverse`, `lubridate`.

## 🚀 Déploiement

### 1. Installation des packages

```r
install.packages(c("shiny", "tidyverse", "lubridate", "rsconnect"))
```

### 2. Connexion à shinyapps.io

Créer un compte gratuit sur [shinyapps.io](https://www.shinyapps.io) et récupérer votre token dans votre tableau de bord.

```r
rsconnect::setAccountInfo(name='VOTRE_NOM', token='VOTRE_TOKEN', secret='VOTRE_SECRET')
```

### 3. Déployer l'application

```r
rsconnect::deployApp()
```

Le lien public sera affiché dans la console après le déploiement.

## 👥 Auteurs

- Projet développé pour le suivi des enquêtes à Lomé.

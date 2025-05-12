# MeteoApp V3 - Application Météo Flutter

## 📱 Présentation du Projet

MeteoApp V3 est une application météo moderne développée avec Flutter, suivant le pattern MVC (Model-View-Controller). L'application utilise l'API OpenWeatherMap pour fournir des données météorologiques précises et à jour.

## 🎯 Fonctionnalités Principales

- Interface utilisateur moderne et intuitive
- Affichage de la météo actuelle et prévisions sur 5 jours
- Géolocalisation pour obtenir la météo de votre position
- Recherche de villes
- Sauvegarde des villes favorites
- Mode hors ligne avec persistance des données
- Composants graphiques personnalisés (graphiques de température, calendrier)
- Menu de navigation intuitif
- Gestion des tâches en arrière-plan pour les mises à jour

## 🏗️ Architecture MVC

L'application suit une architecture MVC stricte :
- **Models** (`lib/models/`) : Gestion des données et logique métier
- **Views** (`lib/views/`) : Interface utilisateur et composants
- **Controllers** (`lib/controllers/`) : Logique de contrôle et gestion d'état

## 🛠️ Technologies Utilisées

- Flutter (dernière version stable)
- OpenWeatherMap API
- SQLite pour la persistance
- Provider pour la gestion d'état
- Dio pour les appels HTTP
- Geolocator pour la géolocalisation

## 📋 Prérequis

- Flutter SDK (dernière version stable)
- Dart SDK
- Un éditeur de code (de préférence VS Code avec Cursor Pro)
- Une clé API OpenWeatherMap
- Git

## 🚀 Installation et Lancement

1. Clonez le repository :
```bash
git clone https://github.com/xLucasGitHubx/MeteoApp.git
cd meteoappv3
```
je conseille de nommer le dossier parent meteoappv3 pour être sur que ça marche

2. Installez les dépendances :
```bash
flutter pub get
```

3. Configurez votre clé API :
   - Créez un fichier `.env` à la racine du projet
   - Ajoutez votre clé API : `OPENWEATHERMAP_API_KEY=votre_clé_api` sous le nom OWM_API_KEY

4. Lancez l'application :
```bash
flutter run
```

## 📱 Compétences Démontrées

### Compétence 1 : Développement Mobile Avancé
- Gestion des activités et fragments via le système de navigation Flutter
- Interface utilisateur moderne avec Material Design 3
- Gestion appropriée des permissions (localisation, stockage)

### Compétence 2 : Interface Utilisateur
- Implémentation de listes avec des widgets personnalisés
- Gestion avancée des événements tactiles
- Composants graphiques personnalisés (graphiques météo, calendrier)
- Menu de navigation intuitif

### Compétence 3 : Services Web et API
- Intégration de l'API OpenWeatherMap
- Persistance des données avec SQLite
- Tâches en arrière-plan pour les mises à jour météo
- Utilisation des API de géolocalisation

## 📝 Structure du Projet

```
lib/
├── models/         # Modèles de données
├── views/          # Interfaces utilisateur
├── controllers/    # Logique de contrôle
├── services/       # Services (API, DB)
├── utils/          # Utilitaires
└── main.dart       # Point d'entrée
```

## 🤝 Contribution

Ce projet a été développé dans le cadre d'un cours de développement mobile. Les contributions sont les bienvenues !

Lucas Madjinda , Junior Chimene , Zakaria Deragh

##
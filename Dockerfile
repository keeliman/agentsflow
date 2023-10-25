# Utilisez une image Node.js officielle comme image de base
FROM node:16

# Définissez le répertoire de travail dans le conteneur pour la partie frontend
WORKDIR /app

# Copiez le fichier package.json et package-lock.json (si disponible) dans le conteneur
COPY package*.json ./

# Installez les dépendances du projet
RUN npm install

# Installer les dépendances nécessaires pour Poetry
RUN apt-get update && apt-get install -y curl python3-pip

# Installer Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - --version 1.1.8

# Ajoutez le chemin de Poetry à la variable d'environnement PATH
ENV PATH="$PATH:/root/.local/bin"

# Copiez le reste des fichiers du projet dans le conteneur
COPY . .

# Assurez-vous que le répertoire public du frontend est copié
COPY ./apps/frontend/public /app/apps/frontend/public

# Construisez l'application frontend
RUN npx nx build frontend

# Exposez le port que votre application utilise
EXPOSE 4200

# Commande pour exécuter l'application
CMD ["npm", "run", "agentsflow:dev"]


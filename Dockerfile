# Étape 1: Utilisez une image de node avec la version 20.16.0 pour construire l'application
FROM node:20.16.0 AS build

# Définissez le répertoire de travail
WORKDIR /app

# Copiez les fichiers package.json et package-lock.json dans le conteneur
COPY package*.json ./

# Installez les dépendances
RUN npm install

# Copiez le reste des fichiers de l'application
COPY . .

# Construisez l'application pour la production
RUN npm run build

# Étape 2: Utilisez une image de serveur web pour servir l'application
FROM nginx:alpine

# Copiez les fichiers construits à partir de l'étape précédente dans le répertoire nginx
COPY --from=build /app/build /usr/share/nginx/html

# Exposez le port sur lequel le serveur va écouter
EXPOSE 80

# Commande pour démarrer nginx
CMD ["nginx", "-g", "daemon off;"]

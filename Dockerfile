FROM composer
ARG SSH_KEY
WORKDIR /app
RUN ["git", "clone", "https://github.com/maastrichtlawtech/graph-quiz.git", "."]
RUN ["composer", "install"]
RUN ["apk", "update"]
RUN ["apk", "add", "npm"]
RUN apk add git openssh-client
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN echo $SSH_KEY | base64 -d
RUN ssh-agent sh -c 'echo $SSH_KEY | base64 -d | ssh-add - ; npm install'
RUN cp .env.example .env
RUN php artisan key:generate
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql
EXPOSE 80
CMD php artisan migrate:fresh --seed && php artisan serve
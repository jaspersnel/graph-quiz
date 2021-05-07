FROM composer
ARG SSH_KEY
WORKDIR /app
RUN ["git", "clone", "https://github.com/maastrichtlawtech/graph-quiz.git", "."]
RUN ["composer", "install"]
RUN ["apk", "update"]
RUN ["apk", "add", "npm"]
RUN apk add git openssh-client
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN ssh-agent sh -c 'echo $SSH_KEY | base64 -d | ssh-add - ; npm install'
RUN cp .env.example .env
RUN php artisan key:generate
EXPOSE 80
CMD php artisan migrate:fresh --seed && php artisan serve
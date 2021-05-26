FROM composer

VOLUME [ "/app/storage/" ]

WORKDIR /app

RUN ["git", "clone", "https://github.com/maastrichtlawtech/graph-quiz.git", "."]

RUN ["composer", "install"]

RUN ["apk", "update"]
RUN ["apk", "add", "npm"]

RUN apk add git openssh-client
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN --mount=type=ssh,id=github npm install

RUN docker-php-ext-install pdo pdo_mysql

EXPOSE 8000

CMD php artisan key:generate && php artisan migrate && php artisan cache:clear && php artisan serve --host=0.0.0.0 --port=8000

all: up

.env:
	cat template.env \
		| xargs -I {} bash -c 'echo "{}$$(head -c 20 /dev/urandom | base32)"' \
		| tee .env

up: .env
	docker compose up -d

down: .env
	docker compose down

# vim: set ft=make :

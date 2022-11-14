-include .env

ENV=MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) \
		MYSQL_PASSWORD=$(MYSQL_PASSWORD)

SSH_TARGET=$(SSH_USERNAME)@$(REMOTE_IP)
SSH_EXEC=ssh -t $(SSH_TARGET)

apply:
	scp -r ./src/* $(SSH_TARGET):/etc/nixos
	$(SSH_EXEC) $(ENV) sudo nixos-rebuild switch

init:
	scp -r ./src/init.sh $(SSH_TARGET):/home/$(SSH_USERNAME)/init.sh
	$(SSH_EXEC) chmod +x /home/$(SSH_USERNAME)/init.sh
	$(SSH_EXEC) /home/$(SSH_USERNAME)/init.sh
	$(SSH_EXEC) rm /home/$(SSH_USERNAME)/init.sh

REMOTE_IP=192.168.122.49
SSH_USERNAME=tristan

SSH_TARGET=$(SSH_USERNAME)@$(REMOTE_IP)
SSH_EXEC=ssh -t $(SSH_TARGET)

apply:
	scp -r ./src/* $(SSH_TARGET):/etc/nixos
	$(SSH_EXEC) sudo nixos-rebuild switch

init:
	ssh-copy-id $(SSH_TARGET)
	scp -r ./src/init.sh $(SSH_TARGET):/home/$(SSH_USERNAME)/init.sh
	$(SSH_EXEC) chmod +x /home/$(SSH_USERNAME)/init.sh
	$(SSH_EXEC) /home/$(SSH_USERNAME)/init.sh
	$(SSH_EXEC) rm /home/$(SSH_USERNAME)/init.sh

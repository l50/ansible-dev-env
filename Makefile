build:
	bash scripts/create_ssh_keypair.sh
	docker-compose up -d --force-recreate --build
	
	@echo "Testing connectivity to the managed node"
	docker exec -it control-node bash -c "cd /etc/ansible && ansible all -m ping"

destroy:
	docker-compose down -v
	rm managed-ubuntu/files/ssh/authorized_keys
	rm managed-centos/files/ssh/authorized_keys
	rm control/files/ssh/ansible_dev_env
	rm control/files/ssh/config
.PHONY: all up down clean fclean re
DB_DIR := /home/damin/data/mysql
WP_DIR := /home/damin/data/wordpress

all:
	make up

up:
	@mkdir -p $(DB_DIR)
	@echo "Directory $(DB_DIR) is ready."
	@mkdir -p $(WP_DIR)
	@echo "Directory $(WP_DIR) is ready."
	@sudo chmod -R 755 /home/damin/data/mysql
	@sudo chmod -R 755 /home/damin/data/wordpress
	@sudo grep -qxF "127.0.0.1 damin.42.fr" /etc/hosts || echo "127.0.0.1 damin.42.fr" | sudo tee -a /etc/hosts
	@echo "127.0.0.1 damin.42.fr has been added to /etc/hosts."
	docker compose -f ./srcs/docker-compose.yml up --build
	docker compose -f ./srcs/docker-compose.yml logs

down:
	@echo "Stopping all containers..."
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker ps -qa | xargs -I {} sudo pkill -f {}
	@echo "Removing all containers..."
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@echo "Removing all images..."
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@echo "Pruning unused networks..."
	@docker network prune -f

clean:
	@echo "Stopping all containers..."
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker ps -qa | xargs -I {} sudo pkill -f {}
	@echo "Removing all containers..."
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@echo "Removing all images..."
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@echo "Removing all volumes..."
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@echo "Pruning unused networks..."
	@docker network prune -f
	@docker compose -f ./srcs/docker-compose.yml down -v
	@-rm -rf $(DB_DIR) $(WP_DIR)

re:
	make clean
	make up

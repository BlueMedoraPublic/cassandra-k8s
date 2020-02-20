build:
	docker build . -t bmedora/cassandra-k8s-bindplane:latest

release: docker-login build push

push:
	docker push bmedora/cassandra-k8s-bindplane:latest

docker-login:
	@docker login -u bmedora -p$$(vault read -field=password secret/dockerhub/bmedora)


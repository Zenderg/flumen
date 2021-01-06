DIR=/flumen/vagrant/infra/traefik

helm repo add traefik https://containous.github.io/traefik-helm-chart
helm repo update
helm upgrade --install traefik -f "$DIR/values.yaml" --set service.spec.externalIPs[0]=$1 traefik/traefik

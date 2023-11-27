resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
}

resource "helm_release" "argo-rollouts" {
  name             = "argo-rollouts"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-rollouts"
  namespace        = "argocd"
  create_namespace = true
  values = [
    <<-EOT
dashboard:
  enabled: true
  service:
    type: ClusterIP
EOT
  ]
}

output "argocd-admin" {
  value = <<EOF
##run the following command to get argocd initial admin password##
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

##run the following command to access argocd
minikube service argocd-server -n argocd

##run the following command to access argo rollouts##
minikube service argo-rollouts-dashboard -n argocd

##run the following command to enable ingress-nginx##
minikube addons enable ingress

##command to run minikube tunnel##
minikube tunnel

##dont forget to add proper hostname on /etc/hosts##
EOF
}



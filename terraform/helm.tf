resource "helm_release" "nvidia-drivers" {
  name       = "nvidia-driver"
  chart      = "./helm/nvidia-chart"
}
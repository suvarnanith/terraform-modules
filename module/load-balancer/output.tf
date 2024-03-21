output "lb-id" {
  value = [for l in azurerm_lb.lb : l.id]
  description = "The load balancer created"
  
}
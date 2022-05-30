output "sp_id" {
    value = azuread_service_principal.this.id
}

output "sp_secret_id" {
    value = azuread_service_principal_password.this.key_id
}

output "sp_secret_value" {
    value = azuread_service_principal_password.this.value
}

output "sp_object_id" {
    value = azuread_service_principal.this.object_id
}

output "ad_group_id" { 
    value = azuread_group.this.id
}
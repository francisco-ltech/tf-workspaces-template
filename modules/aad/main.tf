data "azuread_client_config" "current" {}

resource "azuread_application" "this" {
  display_name = var.aad_display_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "this" {
  application_id               = azuread_application.this.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "this" {
  service_principal_id = azuread_service_principal.this.id
  end_date             = "2299-12-31T00:00:00Z"
}

resource "azuread_group" "this" {
  display_name     = "Service Principals"
  security_enabled = true
  
  owners           = [
    data.azuread_client_config.current.object_id,
  ]

  members          = [
    data.azuread_client_config.current.object_id,
    azuread_service_principal.this.object_id
  ]

  depends_on = [
    azuread_application.this
  ]
}
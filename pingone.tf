data "pingone_licenses" "internal_license" {
  organization_id = var.organization_id
  # If the license ID is empty, grab the license ID from the TF environment. If the license ID is present, we don't really care, we'll use var.license_id elsewhere. 
  scim_filter     = var.license_id != "" ? "(status eq \"active\")" : "(status eq \"active\") and (envId eq \"${var.pingone_environment_id}\")"
}

resource "pingone_environment" "repro_environment" {         
  name        = var.environment_name_master
  type        = var.environment_type
  license_id  = var.license_id != "" ? var.license_id : data.pingone_licenses.internal_license.ids[0]

  services = [
    {
      type = "SSO"
    }
  ]
}

resource "pingone_identity_provider" "microsoft" {
  environment_id = pingone_environment.repro_environment.id
  name    = "Microsoft"
  enabled = true

  microsoft = {
    client_id     = "client-id"
    client_secret = "client-secret"
  }

  # OIDC does seem to function properly
    # openid_connect = {
    #   authorization_endpoint = "https://az-endpoint.com"
    #   client_id = "client-id"
    #   client_secret = "client-secret"
    #   issuer = "https://issuer.com"
    #   jwks_endpoint = "https://jwks-endpoint.com"
    #   scopes = [ "openid" ]
    #   token_endpoint = "https://token-endpoint.com"
    # }

}

# This one needs to be forcibly removed from the state before deleting
resource "pingone_identity_provider_attribute" "microsoft_upn" {
  environment_id       = pingone_environment.repro_environment.id
  identity_provider_id = pingone_identity_provider.microsoft.id

  name   = "username"
  value  = "$${providerAttributes.userPrincipalName}"
}

# This one appears to be chill
resource "pingone_identity_provider_attribute" "microsoft_email" {
  environment_id       = pingone_environment.repro_environment.id
  identity_provider_id = pingone_identity_provider.microsoft.id

  name   = "email"
  update = "EMPTY_ONLY"
  value  = "$${providerAttributes.email}"
}

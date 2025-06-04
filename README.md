# PingOne Terraform External Identity Provider Username Attribute Mapping Issue Reproduction
P.T.E.I.P.U.A.M.I.R. for short (TAY-poo-ah-meer)

#### Repro steps:
Clone this repo.

Update the terraform.tfvars with your environment's information

```
terraform apply --auto-approve
```

Observe that the environment, External IDP, and attribute mapping are complete without issue:
```
Plan: 4 to add, 0 to change, 0 to destroy.
pingone_environment.repro_environment: Creating...
pingone_environment.repro_environment: Creation complete after 0s [id=e766421e-f825-493e-9e25-ae40bd020590]
pingone_identity_provider.microsoft: Creating...
pingone_identity_provider.microsoft: Creation complete after 0s [id=b738f367-e828-4f76-9ab8-1ed4e843ecf7]
pingone_identity_provider_attribute.microsoft_email: Creating...
pingone_identity_provider_attribute.microsoft_upn: Creating...
pingone_identity_provider_attribute.microsoft_email: Creation complete after 0s [id=a34fb87f-2db1-404d-ba98-65995db31991]
pingone_identity_provider_attribute.microsoft_upn: Creation complete after 0s [id=8af4182c-84f3-430f-99a5-62773f2ab229]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

Attempt to destroy the environment.
```
terraform destroy --auto-approve
```

Observe that it errors out:
```
Plan: 0 to add, 0 to change, 4 to destroy.
pingone_identity_provider_attribute.microsoft_upn: Destroying... [id=8af4182c-84f3-430f-99a5-62773f2ab229]
pingone_identity_provider_attribute.microsoft_email: Destroying... [id=a34fb87f-2db1-404d-ba98-65995db31991]
pingone_identity_provider_attribute.microsoft_email: Destruction complete after 0s
╷
│ Error: Invalid parameter value - Unmappable identity provider type
│ 
│ The identity provider ID provided (b738f367-e828-4f76-9ab8-1ed4e843ecf7) relates to an unknown type.  Attributes cannot be mapped to this identity provider.
╵
```

Remove the offending `pingone_identity_provider_attribute`
```
terraform state rm pingone_identity_provider_attribute.microsoft_upn
```

Attempt to destory it again
```
terraform destroy --auto-approve
```

Observe that it destroys successfully now:
```
Plan: 0 to add, 0 to change, 2 to destroy.
pingone_identity_provider.microsoft: Destroying... [id=b738f367-e828-4f76-9ab8-1ed4e843ecf7]
pingone_identity_provider.microsoft: Destruction complete after 0s
pingone_environment.repro_environment: Destroying... [id=e766421e-f825-493e-9e25-ae40bd020590]
pingone_environment.repro_environment: Destruction complete after 2s

Destroy complete! Resources: 2 destroyed.
```

#### Alternative Repro Steps:
Could be considered the happy path right now. 
These steps are what happens if you remove the offending attribute mapping before the initial destroy attempt.

Clone this repo.

Update the terraform.tfvars with your environment's information

```
terraform apply --auto-approve
```

Observe that the environment, External IDP, and attribute mapping are complete without issue:
```
Plan: 4 to add, 0 to change, 0 to destroy.
pingone_environment.repro_environment: Creating...
pingone_environment.repro_environment: Creation complete after 0s [id=e766421e-f825-493e-9e25-ae40bd020590]
pingone_identity_provider.microsoft: Creating...
pingone_identity_provider.microsoft: Creation complete after 0s [id=b738f367-e828-4f76-9ab8-1ed4e843ecf7]
pingone_identity_provider_attribute.microsoft_email: Creating...
pingone_identity_provider_attribute.microsoft_upn: Creating...
pingone_identity_provider_attribute.microsoft_email: Creation complete after 0s [id=a34fb87f-2db1-404d-ba98-65995db31991]
pingone_identity_provider_attribute.microsoft_upn: Creation complete after 0s [id=8af4182c-84f3-430f-99a5-62773f2ab229]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

Remove the offending `pingone_identity_provider_attribute`
```
terraform state rm pingone_identity_provider_attribute.microsoft_upn
```

Attempt to destory it again
```
terraform destroy --auto-approve
```

Observe that it destroys successfully:
```
Plan: 0 to add, 0 to change, 3 to destroy.
pingone_identity_provider_attribute.microsoft_email: Destroying... [id=809a25c7-aa5c-46a6-be2e-fd1f93d42b70]
pingone_identity_provider_attribute.microsoft_email: Destruction complete after 0s
pingone_identity_provider.microsoft: Destroying... [id=c8555876-8e3d-4ea5-a8f3-4e727bb81b08]
pingone_identity_provider.microsoft: Destruction complete after 0s
pingone_environment.repro_environment: Destroying... [id=6d14758e-2ad8-4eb4-bcc6-e5bafe1501fe]
pingone_environment.repro_environment: Destruction complete after 2s

Destroy complete! Resources: 3 destroyed.
```
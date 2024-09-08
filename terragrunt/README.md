# Terragrunt

## Késako ?

Terragrunt is a command-line tool that simplifies and optimizes the use of Terraform by making it easier to manage complex, modular configurations. It helps reduce code duplication, handle multiple environments, and enforce best practices for managing Terraform state and infrastructure as code.

It's a wrapper around Terraform (OpenToFu), which makes up for the shortcomings of Terraform workspace.


## Test

```bash
## At the root of the project
make clean-env
make start-localstack
make setup-tf-backend
make create-test-secret

## Moving to an environment application directory (terragrunt/environments/<ENV>/aws-app)
terragrunt init # Optional because as part of the plan 
terragrunt plan
terragrunt apply
```

## Resources

- [Keep your Terragrunt Architecture DRY][terragrunt-dry-architecture]
- [Migration de projets Terraform vers Terragrunt. (Jérôme Marchand)][migration-tf-to-tg-yt]
- [Avec Terragrunt, ne répétez plus vos variables Terraform 358 fois][zwindler-terragrunt-blog-post]

<!-- Links -->
[terragrunt-dry-architecture]: https://terragrunt.gruntwork.io/docs/features/keep-your-terragrunt-architecture-dry/
[migration-tf-to-tg-yt]: https://youtu.be/_5mBwYd9w-0?si=9UTIJ-_Dcp-TzB2z
[zwindler-terragrunt-blog-post]: https://blog.zwindler.fr/2022/08/29/terragrunt-ne-repetez-plus-vos-variables-terraform/
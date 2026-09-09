## AWS Infrastructure

This repository provisions the AWS and Amazon EKS foundations for the GitOps platform. Terraform composes the network, cluster, IAM, storage and Karpenter modules, then installs the ArgoCD chart and creates the namespaces used by the workload and platform GitOps repositories.

See the [umbrella IaC guide](https://github.com/YOUR_GITHUB_ORG/aws-eks-gitops-argocd-terraform/blob/main/IaC/README.md) for the wider platform architecture and the [platform GitOps repository](https://github.com/YOUR_GITHUB_ORG/platform-gitops) for the in-cluster controllers and CustomResourceDefinitions that depend on this infrastructure.

## Prerequisites

- Terraform `~> 1.16.1`.
- AWS CLI credentials with permission to provision the target account and configure EKS.
- Access to the S3 backend configured in [`backend.tf`](backend.tf).
- `kubectl` for post-provisioning cluster access and health checks.
- The production values in [`envs/prod.tfvars`](envs/prod.tfvars), or an equivalent environment file containing all variables declared in [`variables.tf`](variables.tf).

The AWS provider uses `var.aws_region`. An example environment can target `${AWS_REGION}`, create cluster `${EKS_CLUSTER_NAME}` on EKS `1.36` and use the availability zones configured for that environment.

Terraform state must be stored in an S3 bucket such as `${TF_STATE_BUCKET}` under an environment-specific key and region. The backend uses Terraform's S3 lock file support. Configure your own backend before running initialization or apply, and do not publish backend names or state contents.

## Architecture

The root module coordinates these components:

| Module or resource | Responsibility |
|--------------------|----------------|
| `modules/ipam` and `modules/vpc` | Allocate the VPC address space and create the AWS network using the configured IPAM pool, netmask and availability zones |
| `modules/eks` | Create the EKS cluster, add-ons, Fargate profiles and cluster access configuration |
| `modules/irsa` | Create IAM roles for Kubernetes service accounts used by platform and workload components |
| `modules/s3` | Provide S3 storage used by platform data and logging integrations |
| `modules/karpenter` | Install Karpenter dependencies and connect them to the cluster VPC and CloudFormation resources |
| `helm_release.argocd` | Install ArgoCD into `kube-system` from the `argo-cd` chart |
| Kubernetes namespace resources | Create the team, platform and observability namespaces from `namespace_list` |

The environment namespace list should include the team, platform and observability namespaces required by the deployment, in addition to the existing `kube-system` namespace. ArgoCD is configured to manage applications across the namespaces supplied through Terraform variables and to allow ApplicationSets from the configured namespace scope.

The ArgoCD deployment uses chart version `10.3.0`, two controller replicas, dynamic cluster distribution, server autoscaling and the Argo Rollouts extension. Karpenter receives the cluster name, VPC ID, VPC CIDR and the `karpenter-cloudformation.yaml` dependency file from the root configuration.

## Local Workflow

Initialize and validate the Terraform configuration before planning:

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan -var-file=envs/prod.tfvars -out=prod.tfplan
```

Review the plan before applying it. Apply a reviewed saved plan or use the same variable file for a direct local apply when the environment permits it:

```bash
terraform apply prod.tfplan
```

After the cluster is created, the root configuration updates the local kubeconfig with the configured EKS cluster name and restarts CoreDNS in `kube-system` as part of its bootstrap resources. Confirm AWS credentials, Kubernetes access and the target state before running an apply.

## GitHub Actions

Pull requests run [`.github/workflows/ci-lint.yml`](.github/workflows/ci-lint.yml). The workflow assumes an IAM role such as `${GITHUB_ACTIONS_ROLE}` with GitHub OIDC, installs Terraform `~1.16.1`, runs Gitleaks, checks formatting, initializes and validates Terraform, runs Checkov and creates a plan using `envs/prod.tfvars`. The resulting plan is uploaded as an artifact named after the pull request head SHA.

After a pull request is merged to `main`, [`.github/workflows/cd-pipeline.yml`](.github/workflows/cd-pipeline.yml) assumes the configured GitHub Actions IAM role, downloads the successful plan artifact and applies that exact plan. This keeps the reviewed plan separate from the apply operation and avoids generating a new plan during deployment.

## Related Repositories

- [Application source repositories](https://github.com/YOUR_GITHUB_ORG/aws-eks-gitops-argocd-terraform/blob/main/App/README.md) build the images consumed by the cluster.
- [Workload GitOps repositories](https://github.com/YOUR_GITHUB_ORG/aws-eks-gitops-argocd-terraform/blob/main/GitOps/README.md) deploy application charts through ArgoCD.
- [Platform GitOps](https://github.com/YOUR_GITHUB_ORG/platform-gitops) installs the shared controllers, CRDs and platform services on the Terraform-provisioned cluster.

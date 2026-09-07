
resource "aws_iam_role" "irsa-role" {
  name = "${var.irsa_role_prefix}-irsa-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = var.iam_oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${split("provider/", var.iam_oidc_provider_arn)[1]}:sub" : "system:serviceaccount:${var.k8s_namespace}:${var.k8s_service_account}",
            "${split("provider/", var.iam_oidc_provider_arn)[1]}:aud" : "sts.amazonaws.com"
          }
        }
      },
    ]
  })
}

resource "aws_iam_policy" "irsa-policy" {
  count  = endswith(var.irsa_iam_policy_name, ".json") ? 1 : 0
  policy = file("${path.root}/templates/iam/${var.irsa_iam_policy_name}")
}

resource "aws_iam_role_policy_attachment" "irsa-policy" {
  count      = var.irsa_iam_policy_name != "" ? 1 : 0
  role       = aws_iam_role.irsa-role.name
  policy_arn = endswith(var.irsa_iam_policy_name, ".json") ? aws_iam_policy.irsa-policy[0].arn : var.irsa_iam_policy_name
}

resource "aws_iam_role_policy_attachment" "irsa-policies" {
  for_each   = { for idx, arn in var.irsa_iam_policy_list : idx => arn } ##Terraform needs to know how much items are in the list ahead of time. This sets the key to index and value to arn.
  role       = aws_iam_role.irsa-role.name
  policy_arn = each.value
}
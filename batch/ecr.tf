resource "aws_ecr_repository" "psp_ecr_repo" {
  name = "psp_ecr_repo"
}


resource "aws_ecr_lifecycle_policy" "psp_ecr_life_policy" {

  repository = aws_ecr_repository.psp_ecr_repo.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 30 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF

}
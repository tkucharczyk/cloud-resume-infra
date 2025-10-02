resource "aws_iam_role" "visit_counter_role" {
  name = "visit-counter-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "visit_counter_policy" {
  name = "visit-counter-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "logs:CreateLogGroup",
        Resource = "arn:aws:logs:eu-central-1:381492029034:*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:eu-central-1:381492029034:log-group:/aws/lambda/pageVisitCounter:*"
      },
      {
        Sid    = "VisualEditor0",
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem"
        ],
        Resource = "arn:aws:dynamodb:eu-central-1:381492029034:table/PageVisits"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "visit_counter_policy_attach" {
  role       = aws_iam_role.visit_counter_role.name
  policy_arn = aws_iam_policy.visit_counter_policy.arn
}

resource "aws_lambda_function" "visit_counter" {
  function_name = "pageVisitCounter"
  filename      = "visitCounter.zip"
  handler       = "visitCounter.lambda_handler"
  runtime       = "python3.13"

  role             = aws_iam_role.visit_counter_role.arn
  source_code_hash = filebase64sha256("visitCounter.zip")

  timeout     = 3
  memory_size = 128
}
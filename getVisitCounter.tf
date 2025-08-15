resource "aws_iam_role" "get_visit_counter_role" {
  name = "get_visit-counter-role"

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

resource "aws_iam_policy" "get_visit_counter_policy" {
  name = "get_visit-counter-policy"

  policy = jsonencode({
 "Version": "2012-10-17",
 "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:eu-central-1:381492029034:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:eu-central-1:381492029034:log-group:/aws/lambda/getVisitCounter:*"
            ]
        },
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:GetItem",
                "dynamodb:UpdateItem"
            ],
            "Resource": "arn:aws:dynamodb:eu-central-1:381492029034:table/PageVisits"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "get_visit_counter_policy_attach" {
  role       = aws_iam_role.get_visit_counter_role.name
  policy_arn = aws_iam_policy.get_visit_counter_policy.arn
}

resource "aws_lambda_function" "get_visit_counter" {
  function_name = "getVisitCounter"
  filename      = "getVisitCounter.zip"
  handler       = "getVisitCounter.lambda_handler"
  runtime       = "python3.13"

  role               = aws_iam_role.visit_counter_role.arn
  source_code_hash   = filebase64sha256("getVisitCounter.zip")

  timeout            = 3
  memory_size        = 128
}
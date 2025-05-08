resource "aws_dynamodb_table" "page_visits" {
  name           = "PageVisits"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "PageID"
  
  attribute {
    name = "PageID"
    type = "S"
  }


}
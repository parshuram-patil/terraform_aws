resource "aws_cloudwatch_event_rule" "psp_trigger_every_5_minute_rule" {
  name = "psp-schedular-triggered-every-5-minutes"
  description = "This schedular will be triggered every 5 minutes"
  schedule_expression = "rate(5 minutes)"
}

//resource "aws_cloudwatch_event_target" "psp_batch_job_target" {
//  arn = aws_batch_job_queue.psp_on_demand_batch_queue.arn
//  rule = aws_cloudwatch_event_rule.psp_trigger_every_5_minute_rule.name
//  role_arn = aws_iam_role.psp_batch_job_schedular_role.arn
//  batch_target {
//    job_definition = aws_batch_job_definition.psp_on_demand_batch_job_definition.arn
//    job_name = "psp-job-by-schedular"
//  }
//}

resource "aws_cloudwatch_event_target" "psp_batch_trigger_lambda_target" {
  rule = aws_cloudwatch_event_rule.psp_trigger_every_5_minute_rule.name
  arn = aws_lambda_function.psp_trigger_batch_job_lambda.arn
}
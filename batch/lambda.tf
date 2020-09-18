resource "aws_lambda_function" "psp_trigger_batch_job_lambda" {
  function_name = "psp-trigger-batch-job-lambda"
  description = "GO Lambda to trigger Batch Job"
  handler = "triggerBatchJob"
  role = aws_iam_role.psp_trigger_batch_job_lambda_role.arn
  runtime = "go1.x"
  filename = "triggerBatchJob.zip"
  memory_size   = "512"
  environment {
    variables = {
      JOB_DEFINATION = aws_batch_job_definition.psp_on_demand_batch_job_definition.name
      JOB_QUEUE = aws_batch_job_queue.psp_on_demand_batch_queue.name
    }
  }
}

resource "aws_lambda_permission" "psp_trrigger_lambda_from_cloudwatch_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.psp_trigger_batch_job_lambda.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.psp_trigger_every_5_minute_rule.arn
}
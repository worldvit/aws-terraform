# Cloud Watch Alarm to trigger the above scaling policy when CPU Utilization is above 80%
# Also send the notificaiton email to users present in SNS Topic Subscription
resource "aws_cloudwatch_metric_alarm" "app1_asg_cwa_cpu" {
  alarm_name          = "App1-ASG-CWA-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_description = "This metric monitors ec2 cpu utilization and triggers the ASG Scaling policy to scale-out if CPU is above 80%"

  ok_actions          = [var.myasg_sns_topic.arn]  
  alarm_actions     = [
    var.cpu_high.arn,
    var.myasg_sns_topic.arn
    ]
}

# Define CloudWatch Alarms for ALB
# Alert if HTTP 4xx errors are more than threshold value
resource "aws_cloudwatch_metric_alarm" "alb_4xx_errors" {
  alarm_name          = "App1-ALB-HTTP-4xx-errors"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = "2" # "2"
  evaluation_periods  = "3" # "3"
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "120"
  statistic           = "Sum"
  threshold           = "5"  # Update real-world value like 100, 200 etc
  treat_missing_data  = "missing"  
  dimensions = {
    LoadBalancer = var.aws_lb_web_id
  }
  alarm_description = "This metric monitors ALB HTTP 4xx errors and if they are above 100 in specified interval, it is going to send a notification email"
  ok_actions          = [var.myasg_sns_topic.arn]  
  alarm_actions     = [var.myasg_sns_topic.arn]
}

resource "aws_cloudwatch_dashboard" "cw_dashboard" {
  dashboard_name = "KdigitalDashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type        = "metric"
        x           = 0
        y           = 0
        width       = 12
        height      = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", var.aws_lb_web_id],
            ["AWS/EC2", "NetworkIn", "InstanceId", var.aws_lb_web_id],
            ["AWS/EC2", "NetworkOut", "InstanceId", var.aws_lb_web_id],
          ],
          view = "timeSeries"
          stacked = false
          region  = "us-west-2"
          title   = "EC2 Metrics"
        }
      }
    ]
  })
}

/*
===========================================================
https://terraformguru.com/terraform-real-world-on-aws-ec2/
===========================================================
*/
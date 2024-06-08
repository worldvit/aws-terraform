//======================
# Autoscaling Notifications
## SNS - Topic
resource "aws_sns_topic" "myasg_sns_topic" {
  name = "myasg-sns-topic"
}

## SNS - Subscription
resource "aws_sns_topic_subscription" "myasg_sns_topic_subscription" {
  topic_arn = aws_sns_topic.myasg_sns_topic.arn
  protocol  = "email"
  endpoint  = "xxxx.kim@gmail.com"
}

## Create Autoscaling Notification Resource
resource "aws_autoscaling_notification" "myasg_notifications" {
  group_names = [var.asg_name]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = aws_sns_topic.myasg_sns_topic.arn
}

//================================
## Create Scheduled Actions
### Create Scheduled Action-1: Increase capacity during business hours
resource "aws_autoscaling_schedule" "increase_capacity_9am" {
  scheduled_action_name  = "increase-capacity-9am"
  min_size               = 2
  max_size               = 8
  desired_capacity       = 4
# Time should be provided in UTC Timezone (09AM UTC)
#   start_time             = "2023-07-16T09:00:00Z"
  recurrence             = "00 09 * * 1-5"
  autoscaling_group_name = var.asg_name
}
### Create Scheduled Action-2: Decrease capacity during business hours
resource "aws_autoscaling_schedule" "decrease_capacity_6pm" {
  scheduled_action_name  = "decrease-capacity-6pm"
  min_size               = 2
  max_size               = 4
  desired_capacity       = 4
# Time should be provided in UTC Timezone (9AM UTC)
#   start_time             = "2023-07-16T18:00:00Z"
  recurrence             = "00 18 * * 1-5"
  autoscaling_group_name = var.asg_name
}

output "myasg_sns_topic" {
  value = aws_sns_topic.myasg_sns_topic
}
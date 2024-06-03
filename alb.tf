resource "aws_lb" "alb-obligatorio" {
  name               = "alb-obligatorio"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.obligatorio-sg.id]
  subnets            = [aws_subnet.obligatorio-tf-subnet-a.id, aws_subnet.obligatorio-tf-subnet-b.id]

  enable_deletion_protection = true

  tags = {
    Environment = "dev"
  }
}
// Listener

resource "aws_lb_listener" "my_alb_listener" {
  load_balancer_arn = aws_lb.alb-obligatorio.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {

    type             = "forward"
    target_group_arn = aws_lb_target_group.targetA.id
  }

}

// Target groups

resource "aws_lb_target_group" "targetA" { // Target Group A
  name     = "target-group-a"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.obligatorio-vpc.id

}
resource "aws_lb_target_group_attachment" "attachment-A" {

  target_group_arn = aws_lb_target_group.targetA.arn
  target_id        = aws_instance.webapp-server01.id
  port             = 80

}
resource "aws_lb_target_group_attachment" "attachment-B" {

  target_group_arn = aws_lb_target_group.targetA.arn
  target_id        = aws_instance.webapp-server02.id
  port             = 80

}
//ALB, se crea el loadbalancer de tipo aplicacion y se le asignan las redes y SG.
resource "aws_lb" "alb-obligatorio" {
  name               = "alb-obligatorio"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.obligatorio-sg.id]
  subnets            = [aws_subnet.obligatorio-tf-subnet-a.id, aws_subnet.obligatorio-tf-subnet-b.id]

  enable_deletion_protection = false

  tags = {
    Environment = "Prod"
  }
}
// Listener escucha en el puerto 80 y reenvia el trafico al target group

resource "aws_lb_listener" "my_alb_listener" {
  load_balancer_arn = aws_lb.alb-obligatorio.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {

    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }

}

// Target groups, obtiene las instancias desde el ASG

resource "aws_lb_target_group" "target_group" { // Target Group
  name     = "target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.obligatorio-vpc.id

  stickiness {
    type          = "lb_cookie"
    cookie_duration = 3600 # Duración de la cookie en segundos
  }

 }

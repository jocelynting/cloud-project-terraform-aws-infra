resource "aws_instance" "webapp_instance" {
  ami           = var.webapp_ami_id
  count         = 3
  instance_type = "t2.micro"
  key_name      = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_monitoring_profile.name

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.webapp_sg.id]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "Start time: $(date)"
    cd /opt/webapp
    
    echo "Creating .env file..."
    echo "DB_HOST=${aws_instance.database_instance.private_ip}" > .env
    echo "DB_USER=${var.database_username}" >> .env
    echo "DB_PASSWORD=${var.database_password}" >> .env
    echo "DB_NAME=${var.db_name}" >> .env
    echo "SECRET_KEY=${var.webapp_secret_key}" >> .env

    sudo chown csye6225:csye6225 /opt/webapp/.env
    sudo chmod 600 /opt/webapp/.env
    sudo systemctl restart webapp.service
  EOF
  )

  depends_on = [aws_instance.database_instance]
  tags = {
    Name = "Assignment10-WebAppInstance"
  }
}

resource "aws_instance" "database_instance" {
  ami           = var.mysql_ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_monitoring_profile.name

  subnet_id                   = aws_subnet.private_subnet.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.db_sg.id]
  tags = {
    Name = "Assignment10-DatabaseInstance"
  }
}

resource "null_resource" "run_webapp_tests" {
  depends_on = [aws_route53_record.api_cname]

  provisioner "local-exec" {
    command = <<EOT
      bash -c '
        URL="http://api.jocelynting.me/v1/healthcheck"
        MAX_RETRIES=30  
        RETRY_INTERVAL=5 

        echo "Checking endpoint: $URL"

        for i in $(seq 1 $MAX_RETRIES); do
          HTTP_CODE=$(curl -o /dev/null -s -w "%%{http_code}" "$URL")

          echo "Attempt $i: HTTP Status $HTTP_CODE"

          if [ "$HTTP_CODE" -eq 200 ]; then
            echo "Endpoint is healthy! Exiting..."
            exit 0
          fi

          echo "Waiting $RETRY_INTERVAL seconds before retrying..."
          sleep $RETRY_INTERVAL
        done

        echo "Max retries reached. Endpoint did not return 200. Exiting with failure."
        exit 1
      '
    EOT
  }
}
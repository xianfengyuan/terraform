resource "aws_iam_instance_profile" "nat_profile" {
  count = var.enable_nat_iam_setup

  name = "${var.name}-nat_ha_profile"
  role = element(coalescelist(aws_iam_role.role.*.name, [""]), 0)
}

resource "aws_iam_role" "role" {
  count = var.enable_nat_iam_setup

  name = "${var.name}-nat_ha_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {"AWS": "*"},
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

}

resource "aws_iam_role_policy" "modify_routes" {
  count = var.enable_nat_iam_setup

  name = "nat_ha_modify_routes"
  role = element(coalescelist(aws_iam_role.role.*.id, [""]), 0)

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Action": [
                "ec2:ReplaceRoute",
                "ec2:CreateRoute",
                "ec2:DeleteRoute",
                "ec2:DescribeRouteTables",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeInstanceAttribute"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF

}


data "template_file" "init-script" {
  template = file("scripts/init.cfg")
  vars = {
    REGION = var.AWS_REGION
  }
}

data "template_file" "shell-script" {
  template = file("scripts/volumes.sh")
  vars = {
   DRIVES = replace(join(",", [var.EBS_DEVICE_NAME_1, var.EBS_DEVICE_NAME_2]), ",", " ")
  }
}

data "template_cloudinit_config" "cloudinit-example" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.init-script.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script.rendered
  }
}

data "template_file" "ps-script" {
  template = <<EOF
  <powershell>
      ${file("scripts/drive.ps1")}
      setup-volume "${replace(join(",", [var.EBS_DEVICE_NAME_1, var.EBS_DEVICE_NAME_2]), ",", " ")}"
  </powershell>
EOF
}

data "template_cloudinit_config" "cloudinit-win" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.ps-script.rendered
  }
}
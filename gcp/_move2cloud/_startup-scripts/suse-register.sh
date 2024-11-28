#!/bin/bash
sudo gcemetadata --query instance \
  --identity https://smt-gce.susecloud.net \
  --identity-format full \
  --xml > /tmp/register.xml

sudo SUSEConnect --url https://smt-gce.susecloud.net \
  --instance-data /tmp/register.xml

#!/bin/sh

## https://www.redhat.com/sysadmin/customize-user-environments
profile_dot_d_()
{
  ## for root user:
  echo "if [ -f /etc/profile ]; then
    source /etc/profile
fi" >> /root/.bashrc
  source /root.bashrc

  #for non-root user:
    echo "if [ -d /etc/profile.d ]; then
  for i in /etc/profile.d/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi" >> /home/user/.bashrc
}
profile_dot_d_

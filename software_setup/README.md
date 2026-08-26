# Overview

The computers available in the Zdouc Lab come with a pre-installed set of [programs](setup_script.sh).

These can be accessed by logging in with the `student` account


## For admins

*Nota bene: assumes a fresh Ubuntu install*

### Step-by-step install instructions


- Login with admin account, create new user `student`, set password. Do not give sudo rights.

- Download and run the installer script
```commandline
wget https://raw.githubusercontent.com/zdouc-lab/onboarding/refs/heads/main/software_setup/setup_script.sh
chmod +x ./setup_script.sh
sudo ./setup_script.sh
```

- Via docker, install MITE and FERMO offline
- Verify that the `student` account is in the sudoers file and that it can run docker programs
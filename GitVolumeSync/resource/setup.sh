#!/usr/bin/env sh

# ==============================================================
#  このスクリプトは GitVolumeSync の初期化と初期設定を行います。
# ==============================================================
ALLDONE=true

echo `date` 'Begin setup.' | tee ${PATH_FILE_LOG_ERROR}

#  Data Volume
# ------------------------------------------------------------------------------

# Check if data volume's path is set
if [ -z "${PATH_DIR_DATA}" ]; then
    echo '- Missing: Directory path to clone git.' \
        | tee -a ${PATH_FILE_LOG_ERROR}
    ALLDONE=false
fi


# Check if data volume is mounted
if [ ! -d ${PATH_DIR_DATA} ]; then
    echo '- Directory "/data" does NOT exist. Need to mount a data volume.' \
        | tee -a ${PATH_FILE_LOG_ERROR}
    ALLDONE=false
fi


#  Git settings
# ------------------------------------------------------------------------------

# Check if URL of GitHub repository is set
if [ -z "${GIT_URL}" ]; then
    echo '- Missing: URL of GitHub repository to clone.' \
        | tee -a ${PATH_FILE_LOG_ERROR}
    ALLDONE=false
fi


# Check if name to git commit is set
if [ -z "${GIT_NAME}" ]; then
    echo '- Missing: Name to commit.' \
        | tee -a ${PATH_FILE_LOG_ERROR}
    ALLDONE=false
fi


# Check if mail address to git commit is set
if [ -z "${GIT_MAIL}" ]; then
    echo '- Missing: Email to commit.' \
        | tee -a ${PATH_FILE_LOG_ERROR}
    ALLDONE=false
fi

#  SSH settings
# ------------------------------------------------------------------------------
# Needs to omit password input request.

# Check if SSH volume is mounted
if [ ! -d /root/.ssh ]; then
    echo '- Directory "/root/.ssh" does NOT exist. Need to mount a volume.' \
        | tee -a ${PATH_FILE_LOG_ERROR}
    ALLDONE=false
fi

# Check if SSH private key exists.
if [ ! -f /root/.ssh/id_rsa ]; then
    echo '- Missing: Private key "id_rsa" for SSH at /root/.ssh' \
        | tee -a ${PATH_FILE_LOG_ERROR}
    ALLDONE=false
fi


# Check if SSH public key exists
if [ ! -f /root/.ssh/id_rsa.pub ]; then
    echo '- Missing: Public key "id_rsa.pub" for SSH at /root/.ssh' \
        | tee -a ${PATH_FILE_LOG_ERROR}
    ALLDONE=false
fi


#  Execute
# ------------------------------------------------------------------------------

if [ ${ALLDONE} = false ]; then
    echo 'Exiting setup ... Missing MUST variable(s).'
    echo "Log: ${PATH_FILE_LOG_ERROR}"
    exit $LINENO
fi
echo 'MUST variables OK'
echo


echo -n '- Changing owner of SSH files ...'
chown 0:0 /root/.ssh/*
if [ $? -ne 0 ]; then
    echo 'Error while changing owner to root'
    exit $LINENO
fi
echo 'OK'


echo -n '- Changing mode of public SSH file to 0744 ...'
chmod 0644 /root/.ssh/id_rsa.pub
if [ $? -ne 0 ]; then
    echo 'Error while changing mode to 0744. /root/.ssh/id_rsa.pub'
    exit $LINENO
fi
echo 'OK'


echo -n '- Changing mode of private SSH file to 0600 ...'
chmod 0600 /root/.ssh/id_rsa
if [ $? -ne 0 ]; then
    echo 'Error while changing mode to 0600. /root/.ssh/id_rsa'
    exit $LINENO
fi
echo 'OK'


# Create git configuration file
echo -n '- Creating configuration file for git ... '
cat <<EOL > /root/.gitconfig
[user]
    email = ${GIT_MAIL}
    name = ${GIT_NAME}
[url "git@github.com:"]
	pushinsteadof = https://github.com/
EOL
if [ $? -ne 0 ]; then
    echo 'NG'
    echo '- Fail: Can NOT create .gitconfig file.' \
        | tee -a ${PATH_FILE_LOG_ERROR}
    exit $LINENO
fi
echo 'OK'


# Create ssh configuration file
echo -n '- Creating configuration file for SSh ...'
cat <<EOL > /root/.ssh/config
host github.com
    StrictHostKeyChecking no
EOL
if [ $? -ne 0 ]; then
    echo 'NG'
    echo '- Fail: Can NOT create ~/.ssh/config file.' \
        | tee -a ${PATH_FILE_LOG_ERROR}
    exit $LINENO
fi
echo 'OK'

# First cloning from GitHub to data_git directory (mounted volume)
if [ ! -d ${PATH_DIR_DATA}/.git ]; then
    echo -n "- "
    git clone ${GIT_URL} ${PATH_DIR_DATA}
    if [ $? -ne 0 ]; then
        echo 'NG'
        echo '- Fail: Can NOT clone.' \
            | tee -a ${PATH_FILE_LOG_ERROR}
        exit $LINENO
    fi
    echo 'OK'
fi


# Mark all necessary settings done.
if [ ${ALLDONE} = true ]; then
    touch /alldone
    exit 0
else 
    exit $LINENO
fi


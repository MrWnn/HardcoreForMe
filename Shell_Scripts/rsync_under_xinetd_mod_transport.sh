#!/bin/bash

Set_Value()
{
    PACAGE_PATH=/${absolute_path_of}/${your_local_resource_placed}/
    TARGET_IP=${somewhere_you_want_to_sent_to}
    TARGET_MODULE=${rsync_module_on_TARGET_IP}
    RSYNC_USER=${TARGET_IP_rsync_user}
    RSYNC_KEY=${TARGET_IP_rsync_password_file_name}
    RSYNC_PASS=${TARGET_IP_rsync_password}
    RSYNC_PORT=${TARGET_IP_rsync_port}
    FILE_NAME_PATTERN=${file_name_pattern}
}



Check_Condition()
{
    if [[ ! -e ${PACAGE_PATH} ]]
        then 
            echo -e "\n ${PACAGE_PATH} 不存在 \n"
            exit 
    elif [[ `ls ${PACAGE_PATH} |grep qx|wc -l` == 0 ]]
        then
            echo -e "\n ${PACAGE_PATH}下不存在带qx的包，请检查！\n"
            exit
    elif [[ `ping ${TARGET_IP} -w 1|grep 100\%|wc -l` == 1 ]]
        then
            echo -e "\n ${TARGET_IP} 无法 ping通，请检查！\n"
            exit
    fi

}

Check_Key()
{
    if [[ ! -e /etc/${RSYNC_KEY} ]]
        then
            echo create_key...
            touch /etc/${RSYNC_KEY}
            chmod 600 /etc/${RSYNC_KEY}
            echo "${RSYNC_PASS}" >> /etc/${RSYNC_KEY}
    elif [[ `cat /etc/${RSYNC_KEY}` != "${RSYNC_PASS}" ]]
        then
            : > /etc/${RSYNC_KEY}
            chmod 600 /etc/${RSYNC_KEY}
            echo "${RSYNC_PASS}" >> /etc/${RSYNC_KEY}
    else
        echo "rsync pass exist"
    fi
}

Set_Value
Check_Condition
Check_Key

/usr/bin/rsync --port=${RSYNC_PORT}  -rlptDvzHS --progress  \
    --password-file=/etc/${RSYNC_KEY} \
    --include \*${FILE_NAME_PATTERN}\* \
    --exclude \* \
    $PACAGE_PATH/* ${RSYNC_USER}@${TARGET_IP}::${TARGET_MODULE}
    


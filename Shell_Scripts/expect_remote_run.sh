set timeout 60
#set username [lindex $argv 0]  
set password [lindex $argv 0]  
set hostname [lindex $argv 1]  
spawn [command you want to execute by ssh but need enter yes yes yes]
expect {
            #first connect, no public key in ~/.ssh/known_hosts
            "Are you sure you want to continue connecting (yes/no)?" {
            send "yes\r"
            expect "password:"
                send "$password\r"
                exp_continue
            #expect "#"
            #    send "df -h\r"
            #expect "#"
            #    send "exit\r"
                interact
            }
            #already has public key in ~/.ssh/known_hosts
            "password:" {
                send "$password\r"
                exp_continue
            #expect "#"
            #    send "df -h\r"
            #expect "#"
            #    send "exit\r"
                interact
            }
            "Now try logging into the machine" {
                #it has authorized, do nothing!
            }
        }

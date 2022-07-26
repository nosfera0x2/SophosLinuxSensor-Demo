#!/bin/bash

#Add your unique Sophos Central ID to /etc/sophos/runtimedetections-rules.yaml as customer_id
#located in Sophos Central in Account Details -> Sophos Support

sudo sed -i '3 c\customer_id: YOUR_SOPHOS_CENTRAL_ID' /etc/sophos/runtimedetections.yaml

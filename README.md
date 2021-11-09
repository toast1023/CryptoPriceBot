# CryptoPriceBot
Crypto Polling Bot built in Elixir using OTP concepts


Supervisor tree structure: 

                <CryptBot.Supervisor>
                /                   \
          <Alert.Server>     <Alert.AlertSupervisor>
                             /           |          \
                     <ticker pid>    <ticker pid>   <ticker pid>
  
  Alert.AlertSupervisor runs on a DynamicSupervisor as it starts with no children and are instead started on demand. When the client calls for a notification on a specific crpto coin, then AlertSupervisor starts a new GenServer(NewAlert) which holds the ticker and the desired price of the coin. NewAlert then polls the API continuously every 20 seconds to check the price of the coin, then prints a message and exits if the desired price is reaced. 
  
  Alert.Server basically serves as an interface for users to communicate with. 
  Some current commands: 
        
  ```CrytoBot.Alert.Server.add("ticker", price)```
  
  
  

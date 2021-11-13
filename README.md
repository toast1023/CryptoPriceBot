# CryptoPriceBot
Crypto Polling Bot built in Elixir using OTP concepts

##Project structure
Supervisor tree structure: 

                <CryptoBot.Supervisor>
                /                   \
               /                      \
          <Alert.Server>     <Alert.AlertSupervisor>
                             /           |          \
                            /            |            \
                     <ticker pid>    <ticker pid>   <ticker pid>
  
  CryptoBot.Supervisor handles Alert.Server and Alert.AlertSupervisor.
  
  Alert.AlertSupervisor runs on a DynamicSupervisor as it starts with no children and are instead started on demand. When the client calls for a notification on a specific crpto coin, then AlertSupervisor starts a new GenServer(NewAlert) which holds the ticker and the desired price of the coin. NewAlert then polls the API continuously every 20 seconds to check the price of the coin, then prints a message and exits if the desired price is reaced. 
  
  Alert.Server basically serves as an interface for users to communicate with. 
  
  ##Basic Commands
  Some current commands: 
        
  ```CrytoBot.Alert.Server.add("ticker", price)```
  
  Such as  ```CrytoBot.Alert.Server.add("btc", 70000)``` or ```CrytoBot.Alert.Server.add("eth", 4000)```
  
  This adds a notification for the specified ticker at the specified price point. 
  
   ```CrytoBot.Alert.Server.list```
  
  This lists the current notifications along with their ID number. 
  
   ```CrytoBot.Alert.Server.remove(id)```
   
   This removes a notification based on ID (which can be seen with the list command)
   
   
   
## TODO
- error handling
  - restart server
  - when restart list still retains pids
  - more elegant way of showing price has reached
- pseudo portfolio
  - ability to "buy"
  - ability to "sell"
  - view and track your individual stocks
  - generate your personlized graph (look for graph library)
- frontend page
  - Phoenix?
  - React?
- Connect database
  - PostgreSQL

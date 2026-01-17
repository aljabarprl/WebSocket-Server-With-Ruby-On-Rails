# WebSocket Server  

## Simple Server to Client interaction

#### 1. Code Redeem Feature
##### When player's typed `SUMMER2016` on chat, Server will running command to give xp 3000 on sender.
#### 2. Dashboard Website
##### You can monitor who claims the redeem code on the Dashboard website.
#### 3. Server Broadcast
##### On the dashboard website you can send announcement messages from the server to the minecraft client.
#### 4. Database
##### The data will be stored at simple database using sqlite.
##
##### Run the server:
###### Activated Tailwindcss Watch
```bash
rails tailwindcss:watch
```
###### Then run
```bash
rails s -p 3001
```
###### Or set your own port:
```bash
rails s -p `your port`
```
###### Website port:
```bash
3001
```
###### Puma WsServer port:
```bash
8000
```
##
##### You can customize the port and command at:
```bash
/config/initializers/minecraft_server.rb
```
##### You can customize website styling at:
```bash
/app/views/layouts/application.html.erb
```
##

##### Client Side:
###### in chat type this command:
```bash
/connect your_ip:8000
```
###### or:
```bash
/wsserver your_ip:8000
```

## Tech used:
![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)

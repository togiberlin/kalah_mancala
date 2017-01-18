# Mancala Game
This repo contains a game called Mancala. It's also called Kalaha. The game rules can be found [here](https://en.wikipedia.org/wiki/Kalah). This game was created using the XML stack.

## Setup (Windows)
Download the Windows installer from [here](http://basex.org/products/download/all-downloads/).
Run the installer. After installation, double-click on the BaseX Server icon.

Then, check your browser on port 8984:
```
http://localhost:8984/dba/
```

Username and password are:
```
Username: admin
Password: admin
```

## Setup (Mac OS X)
If you haven't installed [Homebrew](https://www.quora.com/What-is-Homebrew-for-OS-X) yet, open your Terminal and enter:
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

After successful Homebrew installation, install now BaseX. 
To install the BaseX XML database, run this command:
```
brew install basex
```

Then, download the [zip-distribution of BaseX](http://basex.org/products/download/all-downloads/) and unzip it.
Now, copy and paste the entire content of ```/webapp/*``` to this path: ```/Users/Your_User_Name/BaseXWeb/```

Run the BaseX HTTP server from your Terminal:
```
basexhttp
```

Check your browser on port 8984:
```
http://localhost:8984/dba/
```

Username and password are:
```
Username: admin
Password: admin
```

## Authors
* Joonas Palm
* Togi Dashnyam
* Alexandros Tsakpinis
* Nick Schneider
* Lovre Petrovic
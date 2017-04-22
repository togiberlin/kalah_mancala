# Mancala Game
[Mancala](https://en.wikipedia.org/wiki/Mancala) is a generic term for pit and pebble games. There are many Mancala variations, which have differing rulesets. [Kalah](https://en.wikipedia.org/wiki/Kalah) is the North American (and most popular variation) of this game. We used this version as basis for our web application.

## Technology Stack
This game was created using the XML stack, which consists of technologies such as:

- HTML/CSS.
- [XML](https://en.wikipedia.org/wiki/XML). XML is a markup language, mainly used to exchange data between web servers and/or mobile devices - similar to e.g. JSON. But unlike JSON, it is possible to use namespaces and enforce a strict schema. Popular in the banking and corporate world. You can also use XML to store information in a database. In our application, XML is represents the model.
- [XSLT](https://en.wikipedia.org/wiki/XSLT). XSLT is a transformation language for XML. It basically creates custom XML, HTML or SVG based on the current state of the XML database. Example: if the ```<gameover>``` node inside the XML database is marked as ```true```, show a 'game over' text label with player's scores. In our application, XSLT represents the view.
- [SVG](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics): stands for Scalable Vector Graphics. It means that no matter how much you zoom in, you will never see a drop in image quality. SVG is based on XML. In our application, we embedded SVG into the XSLT file.
- [XQuery](https://en.wikipedia.org/wiki/XQuery). XQuery is a querying language for XML documents. It is possible to perform _complex_ queries using the FLWOR syntax (for, let, where, order by, return). In our application, XQuery represents the controller.
- [XPath](https://en.wikipedia.org/wiki/XPath). XPath is a subset of XQuery. You use it to make _simple_ queries to XML or HTML files. In our application, we use it to quickly get specific values from the XML database.
- [BaseX](http://basex.org/). BaseX is a standard XML database.
- [RestXQ](http://docs.basex.org/wiki/RESTXQ). We use it as a router and to construct RESTful services.

## Setup (Windows)
To create your own XML database, download the BaseX Windows installer from [here](http://basex.org/products/download/all-downloads/).
Run the installer. After installation, double-click on the BaseX Server icon.

Then, check your browser on port 8984:
```
http://localhost:8984/dba/
```

Enter username and password to access the BaseX database administration GUI:
```
Username: admin
Password: admin
```

Then, create a new database and name it ```KalahMancala```. Add into your new database the XML file ```GameInstanceCollection.xml```. You can find this file inside the ```basex-db``` folder. Your XML database is now configured.

Now, copy and paste all files to ```C:\Program Files (x86)\BaseX\webapp\```so that your file structure looks like this:
```
-webapp\
--static\
---kalahMancala\
----css\*
----img\*
----js\*
----vendor\*
----gameScreenStyle.css
----woodPattern.jpg
--WEB-INF\
---kalahMancala\
----checkSpecialCases.xquery
----common.sq
----controller.sq
----MancalaTransformator.xsl
----moveSeeds.xquery
----startScreen.html
```

The ```static\kalahMancala``` folder is for all assets, such as css, images, JavaScript etc.
The ```WEB-INF\kalahMancala``` folder is for all XQuery, XSLT and HTML files.

Because we are using XSLT 2.0 and not 1.0, the system XSLT-Processor is not sufficient. You need to add a Saxon v9 XSLT-Processor to your library.
Download ```Saxon PE 9.7.0.14``` or higher [from here](http://www.saxonica.com/download/download_page.xml).
After unzipping, open your Terminal and move to the unzipped directory ```SaxonPE9-7-0-14J\```.

Now, copy and paste the ```saxon9pe.jar``` to your BaseX ```C:\Program Files (x86)\BaseX\lib\``` folder.

To play the game, make sure that ```basexhttp``` is running and enter this into your browser:
```
http://localhost:8984/gxf/kalahMancala
```

## Setup (Mac OS X)
If you haven't installed [Homebrew](https://www.quora.com/What-is-Homebrew-for-OS-X) yet, open your Terminal and enter:
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

After successful Homebrew installation, install now BaseX, the most common XML database. 
To install the BaseX XML database, run this command:
```
brew install basex
```

Then, download the [zip-distribution of BaseX](http://basex.org/products/download/all-downloads/) and unzip it.
Now, copy and paste the folder ```dba```, which can be found here ```downloads/basex/webapp/dba``` to this path: ```/Users/Your_User_Name/BaseXWeb/dba```

Run the BaseX HTTP server from your Terminal:
```
basexhttp
```

Check your browser on port 8984:
```
http://localhost:8984/dba/
```

Enter username and password to access the BaseX database administration GUI:
```
Username: admin
Password: admin
```

Then, create a new database and name it ```KalahMancala```. Add into your new database the XML file ```GameInstanceCollection.xml```. You can find this file inside the ```basex-db``` folder. Your XML database is now configured.

Now, copy and paste all files to ```~/BaseXWeb```so that your file structure looks like this:
```
-BaseXWeb/
--static/
---kalahMancala/
----css/*
----img/*
----js/*
----vendor/*
----gameScreenStyle.css
----woodPattern.jpg
--WEB-INF/
---kalahMancala/
----checkSpecialCases.xquery
----common.sq
----controller.sq
----MancalaTransformator.xsl
----moveSeeds.xquery
----startScreen.html
```

The ```static/kalahMancala``` folder is for all assets, such as css, images, JavaScript etc.
The ```WEB-INF/kalahMancala``` folder is for all XQuery, XSLT and HTML files.

Because we are using XSLT 2.0 and not 1.0, the system XSLT-Processor is not sufficient. You need to add a Saxon v9 XSLT-Processor to your library.
Download ```Saxon PE 9.7.0.14``` or higher [from here](http://www.saxonica.com/download/download_page.xml).
After unzipping, open your Terminal and move to the downloaded and unzipped directory ```Downloads/SaxonPE9-7-0-14J/```.

To copy the Saxon XSLT-Processor into your BaseX library folder, execute this command:
```
cp saxon9pe.jar /usr//local/Cellar/basex/8.5.3/libexec/lib/
```

To play the game,  make sure that ```basexhttp``` is running and enter this into your browser:
```
http://localhost:8984/gxf/kalahMancala
```
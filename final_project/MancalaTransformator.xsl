<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fun="https://github.com/togiberlin/xml_lab"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- XSLT transformator for the Kalah Mancala game -->
    
    <xsl:output method="html" encoding="UTF-8"/>
    
    <!-- Variables -->
    <xsl:variable name="xPosHouse" select="number(18.75)"/>
    <xsl:variable name="yPosHouse1" select="number(17.5)"/>
    <xsl:variable name="yPosHouse2" select="number(52.5)"/>
    <xsl:variable name="xOffsetHouses" select="number(12.5)"/>
    <xsl:variable name="xPosStore1" select="number(7)"/>
    <xsl:variable name="xPosStore2" select="number(93)"/>
    <xsl:variable name="yPosStore" select="number(35)"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Kalah Mancala</title>
            </head>
            <body>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="mancalaGame">
        <!-- Variables -->
        <xsl:variable name="turnOfPlayerOne" select="turnOfPlayerOne"/>
        <xsl:variable name="gameOver" select="gameOver"/>
        
        <svg xmlns="http://www.w3.org/2000/svg"
            width="100%" height="100%">
            
            <desc>The GUI playground for the Kalah Mancala game</desc>
            
            <!-- Define common elements -->
            <defs>
                <!-- Red glow, that marks the players turn -->
                <filter id="glow">
                    <feColorMatrix type="matrix" values=
                        "0 0 0 1 0
                        0 0 0 0 0
                        0 0 0 0 0
                        0 0 0 1 0"/>
                    <feGaussianBlur stdDeviation="6" result="coloredBlur"/>
                    <feMerge>
                        <feMergeNode in="coloredBlur"/>
                        <feMergeNode in="SourceGraphic"/>
                    </feMerge>
                </filter>
                
                <!-- Test whose turn it is -->
                <xsl:choose>
                    <xsl:when test="$turnOfPlayerOne = 0">
                        <!-- Store player 1 -->
                        <ellipse id="store-p1-template" rx="5.5%" ry="29%" stroke-width="5" />
                        <!-- Store player 2 -->
                        <ellipse id="store-p2-template" rx="5.5%" ry="29%" stroke-width="5" style="filter:url(#glow)" />
                        
                        <!-- House player 1 -->
                        <circle id="house-p1-template" cx="{$xPosHouse}%" cy="{$yPosHouse1}%" r="7%" stroke="orange" stroke-width="5" fill="lightyellow" />
                        <!-- House player 2 -->
                        <circle id="house-p2-template" cx="{$xPosHouse}%" cy="{$yPosHouse2}%" r="7%" stroke="blue" stroke-width="5" fill="lightblue" style="filter:url(#glow)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Store player 1 -->
                        <ellipse id="store-p1-template" rx="5.5%" ry="29%" stroke-width="5" style="filter:url(#glow)" />
                        <!-- Store player 2 -->
                        <ellipse id="store-p2-template" rx="5.5%" ry="29%" stroke-width="5" />
                        
                        <!-- House player 1 -->
                        <circle id="house-p1-template" cx="{$xPosHouse}%" cy="{$yPosHouse1}%" r="7%" stroke="orange" stroke-width="5" fill="lightyellow" style="filter:url(#glow)" />
                        <!-- House player 2 -->
                        <circle id="house-p2-template" cx="{$xPosHouse}%" cy="{$yPosHouse2}%" r="7%" stroke="blue" stroke-width="5" fill="lightblue" />
                    </xsl:otherwise>
                </xsl:choose>
                
                <!-- Button -->
                <rect id="button" y="32%" rx="20" ry="20" width="15%" height="6%" stroke="green" stroke-width="5" fill="lightgreen" />
                <!-- Seed -->
                <circle id="seed" r="1%" fill="black" />
            </defs>
            
            <!-- Background -->
            <svg>
                <rect rx="20" ry="20" width="100%" height="70%" fill="green" stroke="green" stroke-width="5" fill-opacity="0.3"/>
            </svg>
            
            <!-- Check if the game is over yet -->
            <xsl:choose>
                <xsl:when test="$gameOver = 0">
                    <svg>
                        <text x="50%" y="37%" font-size="50" fill="green" text-anchor="middle" >MANCALA</text>
                    </svg>
                    <g>
                        <use id="btn-newgame" xlink:href="#button" x="22.5%" />
                        <text x="30%" y="36%" font-size="25" fill="darkgreen" text-anchor="middle" >NEW GAME</text>
                    </g>
                    <g>
                        <use id="btn-help" xlink:href="#button" x="62.5%" />
                        <text x="70%" y="36%" font-size="25" fill="darkgreen" text-anchor="middle" >HELP</text>
                    </g>
                    
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="store1NumOfSeeds" select="player1/store1/numOfSeeds"/>
                    <xsl:variable name="store2NumOfSeeds" select="player2/store2/numOfSeeds"/>
                    <!-- Check who the winner is -->
                    <xsl:choose>
                        <xsl:when test="$store1NumOfSeeds &lt; $store2NumOfSeeds">
                            <svg>
                                <text x="50%" y="37%" font-size="50" fill="red" text-anchor="middle" >Awesome! Congratulations Player 2!</text>
                            </svg>
                        </xsl:when>
                        <xsl:when test="$store1NumOfSeeds = $store2NumOfSeeds">
                            <svg>
                                <text x="50%" y="37%" font-size="50" fill="red" text-anchor="middle" >Unbelievable! It's a tie!</text>
                            </svg>
                        </xsl:when>
                        <xsl:otherwise>
                            <svg>
                                <text x="50%" y="37%" font-size="50" fill="red" text-anchor="middle" >Awesome! Congratulations Player 1!</text>
                            </svg>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </svg>
    </xsl:template>
    
    <!-- Players -->
    <xsl:template match="player1">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="player2">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Stores -->
    <xsl:template match="store1">
        <xsl:variable name="numOfSeeds" select="numOfSeeds"/>
        <use id="store-p1" xlink:href="#store-p1-template" x="{$xPosStore1}%" y="{$yPosStore}%" stroke="orange" fill="lightyellow" />
        <xsl:sequence select="fun:initSeeds($numOfSeeds,$xPosStore1,$yPosStore)"/>
    </xsl:template>
    <xsl:template match="store2">
        <xsl:variable name="numOfSeeds" select="numOfSeeds"/>
        <use id="store-p2" xlink:href="#store-p2-template" x="{$xPosStore2}%" y="{$yPosStore}%" stroke="blue" fill="lightblue" />
        <xsl:sequence select="fun:initSeeds($numOfSeeds,$xPosStore2,$yPosStore)"/>
    </xsl:template>
    
    <!-- Houses of player 1 -->
    <xsl:template match="house1">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="house11">
        <xsl:variable name="numOfSeeds" select="numOfSeeds"/>
        <xsl:variable name="gameId" select="//mancalaGame/@id"/>
        <xsl:variable name="houseId" select="'house11'"/>
        <xsl:variable name="turnOfPlayerOne" select="//turnOfPlayerOne"/>
        <xsl:choose>
            <xsl:when test="$turnOfPlayerOne = 1">
                <a href="http://localhost:8984/gxf/move/{$gameId}/{$houseId}">
                    <svg>
                        <use id="house-p1-1" xlink:href="#house-p1-template" />
                    </svg>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <use id="house-p1-1" xlink:href="#house-p1-template" />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:sequence select="fun:initSeeds($numOfSeeds,$xPosHouse,$yPosHouse1)"/>
    </xsl:template>
    <xsl:template match="house12">
        <xsl:variable name="numOfSeeds" select="numOfSeeds"/>
        <xsl:variable name="gameId" select="//mancalaGame/@id"/>
        <xsl:variable name="houseId" select="'house12'"/>
        <xsl:variable name="turnOfPlayerOne" select="//turnOfPlayerOne"/>
        <xsl:choose>
            <xsl:when test="$turnOfPlayerOne = 1">
                <a href="http://localhost:8984/gxf/move/{$gameId}/{$houseId}">
                    <svg>
                        <use id="house-p1-2" xlink:href="#house-p1-template" x="{$xOffsetHouses}%" />
                    </svg>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <use id="house-p1-2" xlink:href="#house-p1-template" x="{$xOffsetHouses}%" />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:sequence select="fun:initSeeds($numOfSeeds,($xPosHouse + $xOffsetHouses),$yPosHouse1)"/>
    </xsl:template>
    <xsl:template match="house13">
        <xsl:variable name="numOfSeeds" select="numOfSeeds"/>
        <xsl:variable name="gameId" select="//mancalaGame/@id"/>
        <xsl:variable name="houseId" select="'house13'"/>
        <xsl:variable name="turnOfPlayerOne" select="//turnOfPlayerOne"/>
        <xsl:choose>
            <xsl:when test="$turnOfPlayerOne = 1">
                <a href="http://localhost:8984/gxf/move/{$gameId}/{$houseId}">
                    <svg>
                        <use id="house-p1-3" xlink:href="#house-p1-template" x="{$xOffsetHouses * 2}%"/>
                    </svg>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <use id="house-p1-3" xlink:href="#house-p1-template" x="{$xOffsetHouses * 2}%"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:sequence select="fun:initSeeds($numOfSeeds,($xPosHouse + $xOffsetHouses * 2),$yPosHouse1)"/>
    </xsl:template>
    <xsl:template match="house14">
        <xsl:variable name="numOfSeeds" select="numOfSeeds"/>
        <xsl:variable name="gameId" select="//mancalaGame/@id"/>
        <xsl:variable name="houseId" select="'house14'"/>
        <xsl:variable name="turnOfPlayerOne" select="//turnOfPlayerOne"/>
        <xsl:choose>
            <xsl:when test="$turnOfPlayerOne = 1">
                <a href="http://localhost:8984/gxf/move/{$gameId}/{$houseId}">
                    <svg>
                        <use id="house-p1-4" xlink:href="#house-p1-template" x="{$xOffsetHouses * 3}%" />
                    </svg>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <use id="house-p1-4" xlink:href="#house-p1-template" x="{$xOffsetHouses * 3}%" />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:sequence select="fun:initSeeds($numOfSeeds,($xPosHouse + $xOffsetHouses * 3),$yPosHouse1)"/>
    </xsl:template>
    <xsl:template match="house15">
        <xsl:variable name="numOfSeeds" select="numOfSeeds"/>
        <xsl:variable name="gameId" select="//mancalaGame/@id"/>
        <xsl:variable name="houseId" select="'house15'"/>
        <xsl:variable name="turnOfPlayerOne" select="//turnOfPlayerOne"/>
        <xsl:choose>
            <xsl:when test="$turnOfPlayerOne = 1">
                <a href="http://localhost:8984/gxf/move/{$gameId}/{$houseId}">
                    <svg>
                        <use id="house-p1-5" xlink:href="#house-p1-template" x="{$xOffsetHouses * 4}%" />
                    </svg>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <use id="house-p1-5" xlink:href="#house-p1-template" x="{$xOffsetHouses * 4}%" />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:sequence select="fun:initSeeds($numOfSeeds,($xPosHouse + $xOffsetHouses * 4),$yPosHouse1)"/>
    </xsl:template>
    <xsl:template match="house16">
        <xsl:variable name="numOfSeeds" select="numOfSeeds"/>
        <xsl:variable name="gameId" select="//mancalaGame/@id"/>
        <xsl:variable name="houseId" select="'house16'"/>
        <xsl:variable name="turnOfPlayerOne" select="//turnOfPlayerOne"/>
        <xsl:choose>
            <xsl:when test="$turnOfPlayerOne = 1">
                <a href="http://localhost:8984/gxf/move/{$gameId}/{$houseId}">
                    <svg>
                        <use id="house-p1-6" xlink:href="#house-p1-template" x="{$xOffsetHouses * 5}%" />
                    </svg>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <use id="house-p1-6" xlink:href="#house-p1-template" x="{$xOffsetHouses * 5}%" />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:sequence select="fun:initSeeds($numOfSeeds,($xPosHouse + $xOffsetHouses * 5),$yPosHouse1)"/>
    </xsl:template>
    
    <!-- Houses of player 2 -->
    <xsl:template match="house2">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="house21">
        <xsl:variable name="numOfSeeds" select="numOfSeeds"/>
        <xsl:variable name="gameId" select="//mancalaGame/@id"/>
        <xsl:variable name="houseId" select="'house21'"/>
        <xsl:variable name="turnOfPlayerOne" select="//turnOfPlayerOne"/>
        <xsl:choose>
            <xsl:when test="$turnOfPlayerOne = 0">
                <a href="http://localhost:8984/gxf/move/{$gameId}/{$houseId}">
                    <svg>
                        <use id="house-p2-1" xlink:href="#house-p2-template" />
                    </svg>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <use id="house-p2-1" xlink:href="#house-p2-template" />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:sequence select="fun:initSeeds($numOfSeeds,$xPosHouse,$yPosHouse2)" />
    </xsl:template>
    <xsl:template match="house22">
        <xsl:variable name="numOfSeeds" select="numOfSeeds"/>
        <xsl:variable name="gameId" select="//mancalaGame/@id"/>
        <xsl:variable name="houseId" select="'house22'"/>
        <xsl:variable name="turnOfPlayerOne" select="//turnOfPlayerOne"/>
        <xsl:choose>
            <xsl:when test="$turnOfPlayerOne = 0">
                <a href="http://localhost:8984/gxf/move/{$gameId}/{$houseId}">
                    <svg>
                        <use id="house-p2-2" xlink:href="#house-p2-template" x="{$xOffsetHouses}%" />
                    </svg>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <use id="house-p2-2" xlink:href="#house-p2-template" x="{$xOffsetHouses}%" />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:sequence select="fun:initSeeds($numOfSeeds,($xPosHouse + $xOffsetHouses),$yPosHouse2)"/>
    </xsl:template>
    <xsl:template match="house23">
        <xsl:variable name="numOfSeeds" select="numOfSeeds"/>
        <xsl:variable name="gameId" select="//mancalaGame/@id"/>
        <xsl:variable name="houseId" select="'house23'"/>
        <xsl:variable name="turnOfPlayerOne" select="//turnOfPlayerOne"/>
        <xsl:choose>
            <xsl:when test="$turnOfPlayerOne = 0">
                <a href="http://localhost:8984/gxf/move/{$gameId}/{$houseId}">
                    <svg>
                        <use id="house-p2-3" xlink:href="#house-p2-template" x="{$xOffsetHouses * 2}%" />
                    </svg>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <use id="house-p2-3" xlink:href="#house-p2-template" x="{$xOffsetHouses * 2}%" />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:sequence select="fun:initSeeds($numOfSeeds,($xPosHouse + $xOffsetHouses * 2),$yPosHouse2)"/>
    </xsl:template>
    <xsl:template match="house24">
        <xsl:variable name="numOfSeeds" select="numOfSeeds"/>
        <xsl:variable name="gameId" select="//mancalaGame/@id"/>
        <xsl:variable name="houseId" select="'house24'"/>
        <xsl:variable name="turnOfPlayerOne" select="//turnOfPlayerOne"/>
        <xsl:choose>
            <xsl:when test="$turnOfPlayerOne = 0">
                    <a href="http://localhost:8984/gxf/move/{$gameId}/{$houseId}">
                        <svg>
                            <use id="house-p2-4" xlink:href="#house-p2-template" x="{$xOffsetHouses * 3}%" />
                        </svg>
                    </a>
            </xsl:when>
            <xsl:otherwise>
                <use id="house-p2-4" xlink:href="#house-p2-template" x="{$xOffsetHouses * 3}%" />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:sequence select="fun:initSeeds($numOfSeeds,($xPosHouse + $xOffsetHouses * 3),$yPosHouse2)"/>
    </xsl:template>
    <xsl:template match="house25">
        <xsl:variable name="numOfSeeds" select="numOfSeeds"/>
        <xsl:variable name="gameId" select="//mancalaGame/@id"/>
        <xsl:variable name="houseId" select="'house25'"/>
        <xsl:variable name="turnOfPlayerOne" select="//turnOfPlayerOne"/>
        <xsl:choose>
            <xsl:when test="$turnOfPlayerOne = 0">
                <a href="http://localhost:8984/gxf/move/{$gameId}/{$houseId}">
                    <svg>
                        <use id="house-p2-5" xlink:href="#house-p2-template" x="{$xOffsetHouses * 4}%" />
                    </svg>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <use id="house-p2-5" xlink:href="#house-p2-template" x="{$xOffsetHouses * 4}%" />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:sequence select="fun:initSeeds($numOfSeeds,($xPosHouse + $xOffsetHouses * 4),$yPosHouse2)"/>
    </xsl:template>
    <xsl:template match="house26">
        <xsl:variable name="numOfSeeds" select="numOfSeeds"/>
        <xsl:variable name="gameId" select="//mancalaGame/@id"/>
        <xsl:variable name="houseId" select="'house26'"/>
        <xsl:variable name="turnOfPlayerOne" select="//turnOfPlayerOne"/>
        <xsl:choose>
            <xsl:when test="$turnOfPlayerOne = 0">
                <a href="http://localhost:8984/gxf/move/{$gameId}/{$houseId}">
                    <svg>
                        <use id="house-p2-6" xlink:href="#house-p2-template" x="{$xOffsetHouses * 5}%" />
                    </svg>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <use id="house-p2-6" xlink:href="#house-p2-template" x="{$xOffsetHouses * 5}%" />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:sequence select="fun:initSeeds($numOfSeeds,($xPosHouse + $xOffsetHouses * 5),$yPosHouse2)"/>
    </xsl:template>
    
    <!-- Get the corresponding representation of the seeds -->
    <xsl:function name="fun:initSeeds">
        <xsl:param name="numOfSeeds"/>
        <xsl:param name="xPos"/>
        <xsl:param name="yPos"/>
        <xsl:choose>
            <xsl:when test="$numOfSeeds = 0"/>
            <xsl:when test="$numOfSeeds = 1">
                <use x="{$xPos}%" y="{$yPos}%" xlink:href="#seed"/>
            </xsl:when>
            <xsl:when test="$numOfSeeds = 2">
                <use x="{$xPos - 2}%" y="{$yPos}%" xlink:href="#seed"/>
                <use x="{$xPos + 2}%" y="{$yPos}%" xlink:href="#seed"/>
            </xsl:when>
            <xsl:when test="$numOfSeeds = 3">
                <use x="{$xPos - 2}%" y="{$yPos - 3}%" xlink:href="#seed"/>
                <use x="{$xPos}%" y="{$yPos}%" xlink:href="#seed"/>
                <use x="{$xPos + 2}%" y="{$yPos + 3}%" xlink:href="#seed"/>
            </xsl:when>
            <xsl:when test="$numOfSeeds = 4">
                <use x="{$xPos - 2}%" y="{$yPos + 3.5}%" xlink:href="#seed"/>
                <use x="{$xPos + 2}%" y="{$yPos + 3.5}%" xlink:href="#seed"/>
                <use x="{$xPos - 2}%" y="{$yPos - 3.5}%" xlink:href="#seed"/>
                <use x="{$xPos + 2}%" y="{$yPos - 3.5}%" xlink:href="#seed"/>
            </xsl:when>
            <xsl:when test="$numOfSeeds = 5">
                <use x="{$xPos - 2}%" y="{$yPos + 3.5}%" xlink:href="#seed"/>
                <use x="{$xPos + 2}%" y="{$yPos + 3.5}%" xlink:href="#seed"/>
                <use x="{$xPos}%" y="{$yPos}%" xlink:href="#seed"/>
                <use x="{$xPos - 2}%" y="{$yPos - 3.5}%" xlink:href="#seed"/>
                <use x="{$xPos + 2}%" y="{$yPos - 3.5}%" xlink:href="#seed"/>
            </xsl:when>
            <xsl:when test="$numOfSeeds = 6">
                <use x="{$xPos - 2}%" y="{$yPos + 4.5}%" xlink:href="#seed"/>
                <use x="{$xPos + 2}%" y="{$yPos + 4.5}%" xlink:href="#seed"/>
                <use x="{$xPos - 2}%" y="{$yPos}%" xlink:href="#seed"/>
                <use x="{$xPos + 2}%" y="{$yPos}%" xlink:href="#seed"/>
                <use x="{$xPos - 2}%" y="{$yPos - 4.5}%" xlink:href="#seed"/>
                <use x="{$xPos + 2}%" y="{$yPos - 4.5}%" xlink:href="#seed"/>
            </xsl:when>
            <xsl:otherwise>
                <text x="{$xPos}%" y="{$yPos + 1.5}%" font-size="50" fill="red" text-anchor="middle" ><xsl:value-of select="$numOfSeeds"/></text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>
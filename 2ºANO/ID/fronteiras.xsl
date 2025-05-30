<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes" />

  <xsl:template match="/">
    <html>
      <head>
        <title>Fronteiras</title>
      </head>
      <body>
        <h1>Fronteiras de <xsl:value-of select="paises/paisDados[1]/@nome"/></h1>
        <ul>
          <xsl:for-each select="paises/paisDados[1]/fronteiras/pais_fronteira">
            <li><xsl:value-of select="." /></li>
          </xsl:for-each>
        </ul>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>

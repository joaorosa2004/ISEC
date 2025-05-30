<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Países e Densidade Populacional</title>
      </head>
      <body>
        <h1>Países e Respetiva Densidade Populacional</h1>
        <table border="1" cellpadding="5" cellspacing="0">
          <tr>
            <th>País</th>
            <th>Densidade Populacional</th>
          </tr>
          <xsl:for-each select="paises/paisDados">
            <tr>
              <td><xsl:value-of select="@nome"/></td>
              <td><xsl:value-of select="densidade"/></td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>

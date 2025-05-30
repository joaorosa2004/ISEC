<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Países e Bandeiras</title>
        <style>
          table {
            border-collapse: collapse;
            width: 80%;
          }
          th, td {
            border: 1px solid #aaa;
            padding: 8px;
            text-align: left;
          }
          img {
            height: 40px;
            border: 1px solid #000; /* borda preta nas imagens */
          }
        </style>
      </head>
      <body>
        <h1>Lista de Países e Bandeiras</h1>
        <table>
          <tr>
            <th>País</th>
            <th>Bandeira</th>
          </tr>
          <xsl:apply-templates select="paises/paisDados"/>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="paisDados">
    <tr>
      <td><xsl:value-of select="@nome"/></td>
      <td>
        <img>
          <xsl:attribute name="src">
            <xsl:value-of select="concat('https:', bandeira)"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:value-of select="@nome"/> Bandeira
          </xsl:attribute>
        </img>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version='2.0'>


<xsl:output saxon:next-in-chain="db2data-p2.xsl"/>

<xsl:template match="*[status/@mode='deleted']"/>

<!-- ==================================================================== -->

<!-- Add sptype attribute to all service profile. This is done be able to differentiate serviceprofiles,
     which is part of the Base Standards Profile and those which are COI (e.g. FMN or the archive) -->

<xsl:template match="serviceprofile">
  <xsl:variable name="myid" select="@id"/>
  <serviceprofile>
    <xsl:attribute name="sptype">
      <xsl:choose>
        <!-- Does the BSP refere to this serviceprofile? -->
        <xsl:when test="/standards//profile[@id='bsp']//refprofile[@refid=$myid]">
          <xsl:text>bsp</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>coi</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </serviceprofile>
</xsl:template>

<xsl:template match="standards">
  <standards>
    <xsl:apply-templates/>
    <responsibleparties>
      <xsl:apply-templates select="organisations/orgkey" mode="mirror"/>
    </responsibleparties>
  </standards>
</xsl:template>

<xsl:template match="orgkey" mode="mirror">
  <rpkey key="{@key}" short="{@short}" long="{@long}"/>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>

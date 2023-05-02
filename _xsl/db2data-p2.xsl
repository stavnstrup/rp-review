<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version='2.0'>


<xsl:output indent="yes" saxon:next-in-chain="db2data-p3.xsl"/>


<xsl:template match="orgkey">
  <xsl:variable name="mykey" select="@key"/>
  <xsl:if test="(count(/standards//document[@orgid=$mykey])+count(/standards//profilespec[@orgid=$mykey]))>0">
    <orgkey>
      <xsl:apply-templates select="@*"/>
    </orgkey>
  </xsl:if>
</xsl:template>

<xsl:template match="rpkey">
  <xsl:variable name="mykey" select="@key"/>
  <xsl:if test="count(/standards//responsibleparty[@rpref=$mykey])>0">
    <rpkey>
      <xsl:apply-templates select="@*"/>
    </rpkey>
  </xsl:if>
</xsl:template>

<xsl:template match="node">
  <xsl:variable name="myid" select="@id"/>
  <node>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
    <!-- Which standards in the best practiceprofile is referencing this node -->
    <xsl:apply-templates select="/standards//serviceprofile[@sptype='bsp']//refstandard[../../reftaxonomy/@refid=$myid]" mode="counting">
      <xsl:sort select="@refid"/>
    </xsl:apply-templates>
  </node>
</xsl:template>

<xsl:template match="refstandard" mode="counting">
  <refstandard refid="{@refid}" obligation="{../@obligation}" lifecycle="{../@lifecycle}"/>
</xsl:template>



<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>

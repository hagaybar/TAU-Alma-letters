<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">



<xsl:template name="head">
<table cellspacing="0" cellpadding="5" border="0">
	<xsl:attribute name="style">
		<xsl:call-template name="headerTableStyleCss" /> <!-- style.xsl -->
	</xsl:attribute>
	<!-- LOGO INSERT -->
	<tr>
	<xsl:attribute name="style">
		<xsl:call-template name="headerLogoStyleCss" /> <!-- style.xsl -->
	</xsl:attribute>
		<td colspan="2">
		<div id="mailHeader">
              <div id="logoContainer" class="alignLeft">
                    <img src="cid:logo.jpg" alt="logo"/>
               </div>
		</div>
		</td>
	</tr>
<!-- END OF LOGO INSERT -->
	<tr>

  <xsl:for-each select="notification_data/general_data">
	 <td>
		<h1><xsl:value-of select="letter_name"/></h1>
	</td>
	<td align="right">
		<xsl:value-of select="current_date"/>
	</td>
  </xsl:for-each>

</tr>
</table>


</xsl:template>

<xsl:template name="headFulItemChangeDateLetter">
<table cellspacing="0" cellpadding="5" border="0">
	<xsl:attribute name="style">
		<xsl:call-template name="headerTableStyleCss" /> <!-- style.xsl -->
	</xsl:attribute>
	<!-- LOGO INSERT -->
	<tr>
	<xsl:attribute name="style">
		<xsl:call-template name="headerLogoStyleCss" /> <!-- style.xsl -->
	</xsl:attribute>
		<td colspan="2">
		<div id="mailHeader">
              <div id="logoContainer" class="alignLeft">
                    <img src="cid:logo.jpg" alt="logo"/>
               </div>
		</div>
		</td>
	</tr>
<!-- END OF LOGO INSERT -->
	<tr>
	
	<xsl:variable name="letterSubject">
		<xsl:choose>
			<xsl:when test="/notification_data/receivers/receiver/preferred_language = 'he'">
				<xsl:if test="/notification_data/message='RECALL_ONLY'">
					<xsl:text>הפריט שברשותך מוזמן</xsl:text>
				</xsl:if>
				<xsl:if test="/notification_data/message='RECALL_CANCEL_NO_CHANGE'">
					<xsl:text>הפריט שברשותך אינו מוזמן יותר</xsl:text>
				</xsl:if>
				<xsl:if test="/notification_data/message!='RECALL_CANCEL_NO_CHANGE' and /notification_data/message!='RECALL_ONLY'">
					<xsl:text>הודעה על פריט/ים מושאל/ים שברשותך</xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="/notification_data/message='RECALL_ONLY'">
					<xsl:text>An item you borrowed is recalled</xsl:text>
				</xsl:if>
				<xsl:if test="/notification_data/message='RECALL_CANCEL_NO_CHANGE'">
					<xsl:text>The recall that has been placed on your borrowed item has been canceled</xsl:text>
				</xsl:if>
				<xsl:if test="/notification_data/message!='RECALL_CANCEL_NO_CHANGE' and /notification_data/message!='RECALL_ONLY'">
					<xsl:text>Notice regarding item(s) you borrowed</xsl:text>
				</xsl:if>
			</xsl:otherwise>	
		</xsl:choose>
	</xsl:variable>


	<td>
		<h1><xsl:value-of select="$letterSubject"/></h1>
	</td>
	<td align="right">
		<xsl:value-of select="current_date"/>
	</td>
  

</tr>
</table>


</xsl:template>
</xsl:stylesheet>
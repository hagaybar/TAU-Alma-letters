<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="recordTitle">
			<div class="recordTitle">
				<span class="spacer_after_1em"><xsl:value-of select="notification_data/phys_item_display/title"/></span>
			</div>
			<xsl:if test="notification_data/phys_item_display/author !=''">
				<div class="">
					<span class="spacer_after_1em">
						<span class="recordAuthor">@@by@@ <xsl:value-of select="notification_data/phys_item_display/author"/></span>
					</span>
				</div>
			</xsl:if>
			<xsl:if test="notification_data/phys_item_display/issue_level_description !=''">
				<div class="">
					<span class="spacer_after_1em">
						<span class="volumeIssue">@@description@@ <xsl:value-of select="notification_data/phys_item_display/issue_level_description"/></span>
					</span>
				</div>
			</xsl:if>

</xsl:template>


<xsl:variable name="title_header">
	<xsl:choose>
		<xsl:when test="/notification_data/receivers/receiver/user/user_preferred_language = 'he'">
			<xsl:text>כותר</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Title</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="description_header">
	<xsl:choose>
		<xsl:when test="/notification_data/receivers/receiver/user/user_preferred_language = 'he'">
			<xsl:text>תיאור</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Description</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:template name="recordTitleExtendedTable">
	<table cellpadding="5" class="listing">
	
		<xsl:attribute name="style">
			<xsl:call-template name="mainTableStyleCss" />
		</xsl:attribute>
		
		<tr align="center" bgcolor="#f5f5f5">
			<th><xsl:value-of select="$title_header"/></th>
				<xsl:if test="notification_data/phys_item_display/issue_level_description !=''">
					<th><xsl:value-of select="$description_header"/></th>
				</xsl:if>
		</tr>
		<tr>
			<td><xsl:value-of select="notification_data/phys_item_display/title_abcnph"/></td>
			<xsl:if test="notification_data/phys_item_display/issue_level_description !=''">
				<td><xsl:value-of select="notification_data/phys_item_display/issue_level_description"/></td>
			</xsl:if>
		</tr>
		
	</table> 

</xsl:template>
</xsl:stylesheet>


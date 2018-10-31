<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<xsl:template name="salutation">

</xsl:template>
<xsl:template name="lastFooter">
	<table>
	<xsl:attribute name="style">
		<xsl:call-template name="footerTableStyleCss" /> <!-- style.xsl -->
	</xsl:attribute>
	<tr>
	<xsl:for-each select="notification_data/organization_unit">

		<xsl:attribute name="style">
			<xsl:call-template name="listStyleCss" /> <!-- style.xsl -->
		</xsl:attribute>
			<td align="center"><xsl:value-of select="name"/>&#160;<xsl:value-of select="line1"/>&#160;<xsl:value-of select="line2"/>&#160;<xsl:value-of select="city"/>&#160;<xsl:value-of select="postal_code"/>&#160;<xsl:value-of select="country"/></td>

	</xsl:for-each>
	</tr>
	</table>
</xsl:template>
<xsl:template name="contactUs">
	<table align="left">
	<tr>
	<td align="left">
	<a>
                        <xsl:attribute name="href">
                          @@email_contact_us@@
                        </xsl:attribute>
						@@contact_us@@
					</a>
	</td>
</tr>
	</table>
</xsl:template>
<xsl:template name="myAccount">
	<table align="right">
	<tr>
	<td align="right">
	<a>
                        <xsl:attribute name="href">
                          @@email_my_account@@
                        </xsl:attribute>
						@@my_account@@
					</a>
	</td>
</tr>
	</table>
</xsl:template>

<xsl:template name="libEmail">
	<!-- 'lib_id' contains the unique id of the library, for each loan listed in the letter--> 
	
	<xsl:variable name="lib_id" select="library_id" />
	
	<!-- 'circ_email' contains the library's email address, its value is determined according to the value of 'lib_id' (from which library the loan was made). -->
	
	<xsl:variable name="circ_email">
		<xsl:choose>
			<xsl:when test="$lib_id = '190896720004146'">
				<xsl:text>mailto:al1_circ@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190893010004146'">
				<xsl:text>mailto:ah1_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190886640004146'">
				<xsl:text>mailto:ac1_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190902540004146'">
				<xsl:text>mailto:as1_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190899330004146'">
				<xsl:text>mailto:am1_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190893290004146'">
				<xsl:text>mailto:sw1_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190887990004146'">
				<xsl:text>mailto:mus_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190887250004146'">
				<xsl:text>mailto:arc_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190887530004146'">
				<xsl:text>mailto:adr_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190905630004146'">
				<xsl:text>mailto:art1_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190899660004146'">
				<xsl:text>mailto:cmd_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190906170004146'">
				<xsl:text>mailto:sli1_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190905810004146'">
				<xsl:text>mailto:drc1_circ_email@tau.ac.il</xsl:text>
			</xsl:when>																	
			<xsl:when test="$lib_id = '190888270004146'">
				<xsl:text>mailto:geo_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190906530004146'">
				<xsl:text>mailto:hjp1_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190886920004146'">
				<xsl:text>mailto:illc_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190905990004146'">
				<xsl:text>mailto:edu1_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190905090004146'">
				<xsl:text>mailto:asm1_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190897000004146'">
				<xsl:text>mailto:illl_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190887810004146'">
				<xsl:text>mailto:meh_circ_email@tau.ac.il</xsl:text>
			</xsl:when>																	
			<xsl:when test="$lib_id = '12900830000231'">
				<xsl:text>mailto:rs1_circ_email@tau.ac.il</xsl:text>
			</xsl:when>																	
			<xsl:when test="$lib_id = '190893520004146'">
				<xsl:text>mailto:illh_circ_email@tau.ac.il</xsl:text>
			</xsl:when>																	
			<xsl:when test="$lib_id = '190905270004146'">
				<xsl:text>mailto:day1_circ_email@tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="$lib_id = '190905450004146'">
				<xsl:text>mailto:wie1_circ_email@tau.ac.il</xsl:text>
			</xsl:when>																	
			<xsl:when test="$lib_id = '190906350004146'">
				<xsl:text>mailto:zif1_circ_email@tau.ac.il</xsl:text>
			</xsl:when>																	
			<xsl:otherwise>
				<xsl:text>mailto:no_email@tau.ac.il</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
</xsl:template>


</xsl:stylesheet>
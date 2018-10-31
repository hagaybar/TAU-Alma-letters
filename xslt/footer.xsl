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


<!-- a barcode lable in hebrew and english -->

<xsl:template name="barcode">
	<xsl:choose>
		<xsl:when test="/notification_data/receivers/receiver/user/user_preferred_language = 'he'">
			<xsl:text>ברקוד</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Barcode</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- a do-not-reply message in hebrew and english -->
	<!-- maybe this will work -->

<xsl:template name="donotreply">
	<table>
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="/notification_data/receivers/receiver/user/user_preferred_language = 'he'">
						<xsl:text>הודעה זו נשלחה דרך מערכת אוטומטית שאינה מקבלת הודעות, אין להשיב לכתובת ממנה נשלחה ההודעה.</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>This message was sent from a notification-only address that cannot accept incoming e-mail. Please do not reply to this message.</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</table>
</xsl:template>


<!-- this template add the rs dept. email to a letter, based on the library from which the letter is sent from. -->
<xsl:template name="rs_dept_details"> 

<!-- 'lib_id' contains the unique id of the library, for each loan listed in the letter --> 				
	<xsl:variable name="lib_id" select="/notification_data/library/org_scope/library_id" />

<!-- 'lib_id' contains the unique id of the library, for each loan listed in the letter --> 				

	
	
<!-- 'rs_email' contains the library's email address, its value is determined according to the value of 'lib_id' (from which library the loan was made). -->
	
	<xsl:choose>
		
		<xsl:when test="$lib_id = '190896720004146'"> <!-- law library -->
			<xsl:if test="/notification_data/languages/string='he'">
			<xsl:text>מדור השאלה בין-ספרייתית</xsl:text>
			<br></br>
			</xsl:if>
			
			<xsl:if test="/notification_data/languages/string='en'">
			<xsl:text>Inter-Library Loan Dept.</xsl:text>
			<br></br>
			</xsl:if>
			<a href="mailto:hanal@post.tau.ac.il">hanal@post.tau.ac.il</a>
			<br></br>
			<xsl:text>03-6406177</xsl:text>
		</xsl:when>
		
		<xsl:when test="$lib_id = '190893010004146'"> <!-- social sciences library -->
			<xsl:if test="/notification_data/languages/string='he'">
			<xsl:text>מדור השאלה בין-ספרייתית</xsl:text>
			<br></br>
			</xsl:if>
			
			<xsl:if test="/notification_data/languages/string='en'">
			<xsl:text>Inter-Library Loan Dept.</xsl:text>
			<br></br>
			</xsl:if>
			<a href="mailto:SMLILL@tauex.tau.ac.il">SMLILL@tauex.tau.ac.il</a>
			<br></br>
			<xsl:text>03-6405504 ; 03-6407066 </xsl:text>
		</xsl:when>
		
		<xsl:when test="$lib_id = '190902540004146'"> <!-- exact sciences library -->
			<xsl:if test="/notification_data/languages/string='he'">
			<xsl:text>מדור השאלה בין-ספרייתית</xsl:text>
			<br></br>
			</xsl:if>
			
			<xsl:if test="/notification_data/languages/string='en'">
			<xsl:text>Inter-Library Loan Dept.</xsl:text>
			<br></br>
			</xsl:if>
			<a href="mailto:tusill@tauex.tau.ac">tusill@tauex.tau.ac</a>
			<br></br>
			<xsl:text>03-6406269</xsl:text>
		</xsl:when>
		
		<xsl:when test="$lib_id = '190899330004146'"> <!-- life sciences library -->
			<xsl:if test="/notification_data/languages/string='he'">
			<xsl:text>מדור השאלה בין-ספרייתית</xsl:text>
			<br></br>
			</xsl:if>
			
			<xsl:if test="/notification_data/languages/string='en'">
			<xsl:text>Inter-Library Loan Dept.</xsl:text>
			<br></br>
			</xsl:if>
			<a href="mailto:illmail@tauex.tau.ac">illmail@tauex.tau.ac</a>
			<br></br>
			<xsl:text>03-6407966; 03-6409752</xsl:text>
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>

</xsl:stylesheet>
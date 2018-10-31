<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- 'lib_id' contains the unique id of the library , the logic of this variable is as follows:
- check the letter type
- for each of the defined letter types, get the library_id value from the relevant XML element.
- If no value library_id is found in the element - output in var: 'empty_id_element'
- If the letter type is not defined in the condition - output in var: 'letter_not_defined'
 -->
<xsl:variable name="letter_type">
	<xsl:value-of select="/notification_data/general_data/letter_type" />
</xsl:variable>
 
<xsl:variable name="lib_id">
	<xsl:choose>
 		
		<xsl:when test="$letter_type = 'FulPlaceOnHoldShelfLetter'">
			<xsl:if test="/notification_data/organization_unit/org_scope/library_id != ''">
				<xsl:value-of select="/notification_data/organization_unit/org_scope/library_id" />
			</xsl:if>
			<xsl:if test="/notification_data/organization_unit/org_scope/library_id = ''">
				<xsl:text>empty_id_element</xsl:text>
			</xsl:if>			
		</xsl:when>
		
		<xsl:when test="$letter_type = 'GeneralMessageEmailLetter'">
			<xsl:if test="/notification_data/library/org_scope/library_id != ''">
				<xsl:value-of select="/notification_data/library/org_scope/library_id"/>
			</xsl:if>
			<xsl:if test="/notification_data/library/org_scope/library_id = ''">
				<xsl:text>empty_id_element</xsl:text>
			</xsl:if>
		</xsl:when>
		
		<xsl:when test="$letter_type = 'QueryToPatronLetter'">
			<xsl:if test="/notification_data/library/org_scope/library_id != ''">
				<xsl:value-of select="/notification_data/library/org_scope/library_id"/>
			</xsl:if>
			<xsl:if test="/notification_data/library/org_scope/library_id = ''">
				<xsl:text>empty_id_element</xsl:text>
			</xsl:if>
		</xsl:when>
		
		<xsl:when test="$letter_type = 'ResourceSharingReceiveSlipLetter'">		
			<xsl:if test="/notification_data/library/org_scope/library_id != ''">
				<xsl:value-of select="/notification_data/library/org_scope/library_id"/>
			</xsl:if>
			<xsl:if test="/notification_data/library/org_scope/library_id = ''">
				<xsl:text>empty_id_element</xsl:text>
			</xsl:if>		
		</xsl:when>
		
		<xsl:when test="$letter_type = 'ResourceSharingReturnSlipLetter'">	
			<xsl:if test="/notification_data/library/org_scope/library_id != ''">
				<xsl:value-of select="/notification_data/library/org_scope/library_id"/>
			</xsl:if>
			<xsl:if test="/notification_data/library/org_scope/library_id = ''">
				<xsl:text>empty_id_element</xsl:text>
			</xsl:if>		
		</xsl:when>
		
		<xsl:when test="$letter_type = 'ResourceSharingShippingSlipLetter'">
			<xsl:if test="/notification_data/incoming_request/library_id != ''">
				<xsl:value-of select="/notification_data/incoming_request/library_id"/>
			</xsl:if>
			<xsl:if test="/notification_data/incoming_request/library_id = ''">
				<xsl:text>empty_id_element</xsl:text>
			</xsl:if>			
		</xsl:when>
		
		<xsl:otherwise>
			<xsl:text>letter_not_defined</xsl:text>
		</xsl:otherwise>
		
	</xsl:choose>
</xsl:variable>

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



<xsl:variable name="lib_name">
	<xsl:choose>
		<xsl:when test="notification_data/library/name != ''"> <!-- for GeneralMessageEmailLetter and Patron Query Type Letters --> -->
			<xsl:value-of select="notification_data/library/name" />
		</xsl:when>
		<xsl:when test="notification_data/organization_unit/name != ''"> <!-- for FulPlaceOnHoldShelfLetter -->
			<xsl:value-of select="notification_data/library/name" />
		</xsl:when>
	<xsl:otherwise>
	</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<!-- this template add the rs Department email to letters based on the library from which the letter is sent from
     this template currently work for letters of the following types: 

		GeneralMessageEmailLetter,
		Patron Query Type, 
		FulPlaceOnHoldShelfLetter  
-->
<xsl:template name="rs_dept_details"> 

<!-- detects where the perffered language is located and get the value-->
<xsl:variable name="language">
	<xsl:choose>
		<!-- the following condition is supposed to test if the element is empty; I assume that it returns FALSE also when the element does not exist need to test it -->
		<xsl:when test="/notification_data/receivers/receiver/preferred_language != ''">
			<xsl:value-of select="/notification_data/receivers/receiver/preferred_language"/> <!-- for GeneralMessageEmailLetter and Patron Query Type Letters -->
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="/notification_data/languages/string" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>
	
	
<!-- 'rs_email' contains the library's email address, its value is determined according to the value of 'lib_id' (from which library the loan was made). -->
	
	<xsl:choose>
		
		<xsl:when test="$lib_id = '190896720004146'"> <!-- law library -->
			<xsl:if test="$language='he'">
				<tr>
					<td>
						<b>מדור השאלה בינספרייתית</b>
					</td>
				</tr>
				<tr>
					<td>
						<b><xsl:value-of select="$lib_name" /></b>
					</td>
				</tr>
				<tr>
					<td>
						<b>טלפון: 03-6406177 | דוא"ל: <a href="mailto:hanal@post.tau.ac.il">hanal@post.tau.ac.il</a></b>
					</td>
				</tr>
				<br></br>
			</xsl:if>

			<xsl:if test="$language='en'">
				<tr>
					<td>
						<b>Interlibrary Loan Department</b>
					</td>
				</tr>
				<tr>
					<td>
						<b><xsl:value-of select="$lib_name" /></b>
					</td>
				</tr>
				<tr>
					<td>
						<b>Phone: 03-6406177 | Email: <a href="mailto:hanal@post.tau.ac.il">hanal@post.tau.ac.il</a></b>
					</td>
				</tr>
				<br></br>
			</xsl:if>
			
		</xsl:when>
		
		<xsl:when test="$lib_id = '190893010004146'"> <!-- social sciences library -->
			<xsl:if test="$language='he'">
			<tr>
					<td>
						<b>שירותי השאלה בינספרייתית ואספקת פרסומים</b>
					</td>
				</tr>
				<tr>
					<td>
						<b><xsl:value-of select="$lib_name" /></b>
					</td>
				</tr>
				<tr>
					<td>
						<b>טלפון: 03-6407066 ; 03-6405504 | פקס: 03-6407840 | דוא"ל: <a href="mailto:SMLILL@tauex.tau.ac.il">SMLILL@tauex.tau.ac.il</a></b>
					</td>
				</tr>
				<br></br>
			</xsl:if>

			<xsl:if test="$language='en'">
			
				<tr>
					<td>
						<b>Interlibrary Loan and Document Delivery Services</b>
					</td>
				</tr>
				<tr>
					<td>
						<b><xsl:value-of select="$lib_name" /></b>
					</td>
				</tr>
				<tr>
					<td>
						<b>Phone: 03-6407066 ; 03-6405504 | Fax: 03-6407840 | Email: <a href="mailto:SMLILL@tauex.tau.ac.il">SMLILL@tauex.tau.ac.il</a></b>
					</td>
				</tr>
				<br></br>
			</xsl:if>
			
		</xsl:when>
		
		<xsl:when test="$lib_id = '190902540004146'"> <!-- exact sciences library -->
			<xsl:if test="$language='he'">
				<tr>
					<td>
						<b>מדור השאלה בינספרייתית</b>
					</td>
				</tr>
				<tr>
					<td>
						<b><xsl:value-of select="$lib_name" /></b>
					</td>
				</tr>
				<tr>
					<td>
						<b>טלפון: 03-6409269 | דוא"ל: <a href="mailto:tusill@tauex.tau.ac.il">tusill@tauex.tau.ac.il</a></b>
					</td>
				</tr>
				<br></br>
			</xsl:if>			
			
			<xsl:if test="$language='en'">
				<tr>
					<td>
						<b>Interlibrary Loan Department</b>
					</td>
				</tr>
				<tr>
					<td>
						<b><xsl:value-of select="$lib_name" /></b>
					</td>
				</tr>
				<tr>
					<td>
						<b>Phone: 03-6409269 | Email: <a href="mailto:tusill@tauex.tau.ac.il">tusill@tauex.tau.ac.il</a></b>
					</td>
				</tr>
				<br></br>
			</xsl:if>
		</xsl:when>
		
		<xsl:when test="$lib_id = '190899330004146'"> <!-- life sciences library -->
			<xsl:if test="$language='he'">
				<tr>
					<td>
						<b>מדור השאלה בינספרייתית</b>
					</td>
				</tr>
				<tr>
					<td>
						<b><xsl:value-of select="$lib_name" /></b>
					</td>
				</tr>
				<tr>
					<td>
						<b>טלפון: 03-6407966; 03-6409752 | דוא"ל: <a href="mailto:illmail@tauex.tau.ac.il">illmail@tauex.tau.ac.il</a></b>
					</td>
				</tr>
				<br></br>
			</xsl:if>
						
			<xsl:if test="$language='en'">
				<tr>
					<td>
						<b>Interlibrary Loan Department</b>
					</td>
				</tr>
				<tr>
					<td>
						<b><xsl:value-of select="$lib_name" /></b>
					</td>
				</tr>
				<tr>
					<td>
						<b>Phone: 03-6407966; 03-6409752 | Email: <a href="mailto:illmail@tauex.tau.ac.il">illmail@tauex.tau.ac.il</a></b>
					</td>
				</tr>
				<br></br>
			</xsl:if>	
		</xsl:when>
		<xsl:when test="$lib_id = '12900830000231'"> <!-- Central Library (resource sharing) -->
			<xsl:if test="$language='he'">
				<tr>
					<td>
						<b>השאלה בינספרייתית</b>
					</td>
				</tr>
				<tr>
					<td>
						<b>הספרייה המרכזית ע&quot;ש סוראסקי</b>
					</td>
				</tr>
				<tr>
					<td>
						<b>טלפון: 972-3-6408746| דוא"ל: <a href="mailto:cenloan@tauex.tau.ac.il">cenloan@tauex.tau.ac.il</a></b>
					</td>
				</tr>
				<br></br>
			</xsl:if>
			<xsl:if test="$language='en'">
				<tr>
					<td>
						<b>Interlibrary Loan</b>
					</td>
				</tr>
				<tr>
					<td>
						<b>Sourasky Central Library</b>
					</td>
				</tr>
				<tr>
					<td>

						<b>Phone: 972-3-6408746 | Email: <a href="mailto:cenloan@tauex.tau.ac.il">cenloan@tauex.tau.ac.il</a></b>
					</td>
				</tr>
				<br></br>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>

<!-- the following template currently working for the GeneralMessageEmailLetter, not tested on other templates yet -->
<xsl:template name="rs_copyright">
	<xsl:choose>
		<xsl:when test = "/notification_data/languages/string != 'he'">
			<tr>
				<td><b>Please note: Articles/Chapters may be used for research and study purposes only.</b></td>
			</tr>
			<xsl:if test="$lib_id = '12900830000231'"> <!-- RS - cen. lib. -->
			<tr>
				<td><b>***The link will be accessible for TWO weeks only.***</b></td>
			</tr>
			</xsl:if>
		</xsl:when>

		<xsl:otherwise>
		<tr>
			<td><b>לתשומת לבך: השימוש בפריט זה מותר לצורכי מחקר ולימוד בלבד.</b></td>
		</tr>
		
			<xsl:if test="$lib_id = '12900830000231'"> <!-- RS - cen. lib. -->
				<tr>
				<td><b>***הקובץ יישאר זמין להורדה במשך שבועיים מיום שליחת הודעה זו***</b></td>
				</tr>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- a do-not-reply message in hebrew and english, does not apply to RS - cen. lib.-->

<xsl:template name="donotreply">
	<xsl:if test="$lib_id != '12900830000231'"> <!-- if not RS - cen. lib. -->
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
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
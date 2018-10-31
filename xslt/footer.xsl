<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="salutation">

	</xsl:template>

	<xsl:template name="lastFooter">
		<table>
			<xsl:attribute name="style">
				<xsl:call-template name="footerTableStyleCss" />
				<!-- style.xsl -->
			</xsl:attribute>
			<tr>
				<xsl:for-each select="notification_data/organization_unit">

					<xsl:attribute name="style">
						<xsl:call-template name="listStyleCss" />
						<!-- style.xsl -->
					</xsl:attribute>
					<td align="center">
						<xsl:value-of select="name"/>&#160;<xsl:value-of select="line1"/>&#160;<xsl:value-of select="line2"/>&#160;<xsl:value-of select="city"/>&#160;<xsl:value-of select="postal_code"/>&#160;<xsl:value-of select="country"/>
					</td>
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


	<!-- this template add the rs Department contact details when called, 3 params should be specified: lib_id, letter_language, lib_name -->

	<xsl:template name="rs_dept_details"> 
		<xsl:param name="lib_id" select= "/notification_data/library/org_scope/library_id" />
		<xsl:param name="letter_language" select = "/notification_data/languages/string" />
		<xsl:param name="lib_name" select = "notification_data/library/name" />


		<!-- 'rs_email' contains the library's email address, its value is determined according to the value of 'lib_id'. -->
		<xsl:variable name="rs_email">
			<xsl:choose>
				<xsl:when test="$lib_id = '190896720004146'">
					<!-- law library -->
					<xsl:text>hanal@post.tau.ac.il</xsl:text>
				</xsl:when>
				<xsl:when test="$lib_id = '190893010004146'">
					<!-- social sciences library -->
					<xsl:text>SMLILL@tauex.tau.ac.il</xsl:text>
				</xsl:when>
				<xsl:when test="$lib_id = '190902540004146'">
					<!-- exact sciences library -->
					<xsl:text>tusill@tauex.tau.ac.il</xsl:text>
				</xsl:when>
				<xsl:when test="$lib_id = '190899330004146'">
					<!-- life sciences library -->
					<xsl:text>illmail@tauex.tau.ac.il</xsl:text>
				</xsl:when>
				<xsl:when test="$lib_id = '12900830000231'">
					<!-- Central Library (resource sharing) -->
					<xsl:text>cenloan@tauex.tau.ac.il</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>lib_id undefined</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<!-- 'rs_desc' contains the library's RS description, its value is determined according to the values of 'lib_id' and letter_language. -->
		<xsl:variable name="rs_desc">
			<xsl:choose>

				<xsl:when test="not(contains('|190896720004146|190902540004146|190899330004146|190893010004146|12900830000231|', concat('|', $lib_id, '|')))">
					<!-- no valid lib_id is found -->
					<xsl:text>lib_id undefined</xsl:text>
				</xsl:when>

				<xsl:when test="not(contains('|he|en|', concat('|', $letter_language, '|')))">
					<!-- no valid letter_language is found -->
					<xsl:text>letter_language undefined</xsl:text>
				</xsl:when>

				<xsl:when test="contains('|190896720004146|190902540004146|190899330004146|', concat('|', $lib_id, '|'))">
					<!-- law library|exact sciences library|life sciences library -->
					<xsl:if test="$letter_language='he'">
						<xsl:text>מדור השאלה בינספרייתית</xsl:text>
					</xsl:if>
					<xsl:if test="$letter_language='en'">
						<xsl:text>Interlibrary Loan Department</xsl:text>
					</xsl:if>
				</xsl:when>

				<xsl:when test="$lib_id = '190893010004146'">
					<!-- social sciences library -->
					<xsl:if test="$letter_language='he'">
						<xsl:text>שירותי השאלה בינספרייתית ואספקת פרסומים</xsl:text>
					</xsl:if>
					<xsl:if test="$letter_language='en'">
						<xsl:text>Interlibrary Loan and Document Delivery Services</xsl:text>
					</xsl:if>
				</xsl:when>

				<xsl:when test="$lib_id = '12900830000231'">
					<!-- Central Library (resource sharing) -->
					<xsl:choose>
						<xsl:when test="$letter_language = 'he'">
							<xsl:text>השאלה בינספרייתית</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Interlibrary Loan</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>lib_desc error</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<!-- 'rs_phone' contains the library's RS phone numbers, its value is determined according to the values of 'lib_id' and letter_language. -->
		<xsl:variable name="rs_phone">
			<xsl:choose>
				<xsl:when test="$letter_language='he'">
					<!-- hebrew -->
					<xsl:choose>
						<xsl:when test="$lib_id = '190896720004146'">
							<!-- law library -->
							<xsl:text>טלפון: 03-6406177</xsl:text>
						</xsl:when>

						<xsl:when test="$lib_id = '190893010004146'">
							<!-- social sciences library -->
							<xsl:text>טלפון: 03-6407066 ; 03-6405504 | פקס: 03-6407840</xsl:text>
						</xsl:when>

						<xsl:when test="$lib_id = '190902540004146'">
							<!-- exact sciences library -->
							<xsl:text>טלפון: 03-6409269</xsl:text>
						</xsl:when>
						<xsl:when test="$lib_id = '190899330004146'">
							<!-- life sciences library -->
							<xsl:text>טלפון: 03-6407966; 03-6409752</xsl:text>

						</xsl:when>

						<xsl:when test="$lib_id = '12900830000231'">
							<!-- Central Library (resource sharing) -->
							<xsl:text>טלפון: 972-3-6408746</xsl:text>
						</xsl:when>

					</xsl:choose>
				</xsl:when>			

				<xsl:when test="$letter_language='en'">
					<!-- english -->
					<xsl:choose>
						<xsl:when test="$lib_id = '190896720004146'">
							<!-- law library -->
							<xsl:text>Phone: 03-6406177</xsl:text>
						</xsl:when>

						<xsl:when test="$lib_id = '190893010004146'">
							<!-- social sciences library -->
							<xsl:text>Phone: 03-6407066 ; 03-6405504 | Fax: 03-6407840</xsl:text>

						</xsl:when>

						<xsl:when test="$lib_id = '190902540004146'">
							<!-- exact sciences library -->
							<xsl:text>Phone: 03-6409269</xsl:text>
						</xsl:when>
						<xsl:when test="$lib_id = '190899330004146'">
							<!-- life sciences library -->
							<xsl:text>Phone: 03-6407966; 03-6409752</xsl:text>
						</xsl:when>

						<xsl:when test="$lib_id = '12900830000231'">
							<!-- Central Library (resource sharing) -->
							<xsl:text>Phone: 972-3-6408746</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!-- display part -->	
		<tr>
			<td>
				<b>
					<xsl:value-of select="$rs_desc" />
				</b>
			</td>
		</tr>
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="$lib_id = '12900830000231'">
						<!-- Central Library (resource sharing) -->
						<xsl:choose>
							<xsl:when test="$letter_language = 'he'">
								<b>הספרייה המרכזית ע&quot;ש סוראסקי</b>
							</xsl:when>
							<xsl:otherwise>
								<b>Sourasky Central Library</b>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<!-- All other libraries -->
						<b>
							<xsl:value-of select="$lib_name" />
						</b>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>
				<b>
					<xsl:value-of select="$rs_phone" /> | 
					<xsl:choose>
						<xsl:when test="$letter_language = 'he'">
						דוא"ל:
						</xsl:when>
						<xsl:otherwise>
						Email:
						</xsl:otherwise>
					</xsl:choose>
					
					<a href="mailto:{$rs_email}">
						<xsl:value-of select="$rs_email"/>
					</a>
				</b>

			</td>
		</tr>

	</xsl:template>

	<!-- the following template currently working for the GeneralMessageEmailLetter, not tested on other templates yet -->
	<xsl:template name="rs_copyright">
		<xsl:param name="lib_id" select= "/notification_data/library/org_scope/library_id" />
		<xsl:choose>
			<xsl:when test = "/notification_data/languages/string != 'he'">
				<tr>
					<td>
						<b>Please note: Articles/Chapters may be used for research and study purposes only.</b>
					</td>
				</tr>
				<xsl:if test="$lib_id = '12900830000231'">
					<!-- RS - cen. lib. -->
					<tr>
						<td>
							<b>***The link will be accessible for TWO weeks only.***</b>
						</td>
					</tr>
				</xsl:if>
			</xsl:when>

			<xsl:otherwise>
				<tr>
					<td>
						<b>לתשומת לבך: השימוש בפריט זה מותר לצורכי מחקר ולימוד בלבד.</b>
					</td>
				</tr>

				<xsl:if test="$lib_id = '12900830000231'">
					<!-- RS - cen. lib. -->
					<tr>
						<td>
							<b>***הקובץ יישאר זמין להורדה במשך שבועיים מיום שליחת הודעה זו***</b>
						</td>
					</tr>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- a do-not-reply message in hebrew and english, does not apply to RS - cen. lib.-->

	<xsl:template name="donotreply">
		<xsl:param name="lib_id" select= "/notification_data/library/org_scope/library_id" />
		<xsl:param name="letter_language" select = "/notification_data/receivers/receiver/user/user_preferred_language" />
		<xsl:choose>
			<xsl:when test="$lib_id = '12900830000231'">
			<!-- if RS - cen. lib. do nothing -->
			</xsl:when>
			<xsl:otherwise>
						<!-- if not RS - cen. lib. -->
				<table>
					<tr>
						<td>
							<xsl:choose>
								<xsl:when test="$letter_language != ''">
									<xsl:if test="$letter_language = 'he'">
										<xsl:text>הודעה זו נשלחה דרך מערכת אוטומטית שאינה מקבלת הודעות, אין להשיב לכתובת ממנה נשלחה ההודעה.</xsl:text>
									</xsl:if>
									<xsl:if test="$letter_language = 'en'">
										<xsl:text>This message was sent from a notification-only address that cannot accept incoming e-mail. Please do not reply to this message.</xsl:text>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>This message was sent from a notification-only address that cannot accept incoming e-mail. Please do not reply to this message.</xsl:text>
								</xsl:otherwise>
							</xsl:choose>					
						</td>
					</tr>
				</table>
			
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
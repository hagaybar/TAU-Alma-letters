<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- Static content store for additional_text labels -->
	<xsl:variable name="additional_texts">
	<texts>
		<!-- text_01 (Wiener Library only) -->
		<text label="text_01" lang="he" lib="190905450004146">בדלפק ההשאלה בספריה המרכזית</text>
		<text label="text_01" lang="en" lib="190905450004146">from the circulation desk at the Central Library</text>

		<!-- text_02 (generic encouragement) -->
		<text label="text_02" lang="he">קראו ספרים, עשו חיים</text>
		<text label="text_02" lang="en">Read Books. Live Better</text>

		<!-- text_03 (fines notice) -->
		<text label="text_03" lang="he">במידה וקיים קנס על איחור בהחזרה, ניתן לראותו </text>
		<text label="text_03" lang="en">Accrued fines - if exist - are displyed in your </text>

		<!-- text_04 (library card) -->
		<text label="text_04" lang="he">בכרטיס הקורא</text>
		<text label="text_04" lang="en">library card.</text>

		<!-- text_05 (barcode) -->
		<text label="text_04" lang="he">ברקוד</text>
		<text label="text_04" lang="en">barcode</text>
	</texts>
	</xsl:variable>


	<!-- Template to render additional_text content from static XML block -->
	<xsl:template name="additional_text_lookup">
	<xsl:param name="label"/>
	<xsl:param name="letter_language"/>
	<xsl:param name="lib_id"/>

	<!-- Try to find a match with label, lang, and exact lib -->
	<xsl:variable name="matchLib" select="$additional_texts/text[@label = $label and @lang = $letter_language and @lib = $lib_id]"/>

	<!-- If no exact lib match, fallback to lang+label -->
	<xsl:variable name="matchGeneric" select="$additional_texts/text[@label = $label and @lang = $letter_language and not(@lib)]"/>

	<xsl:choose>
		<xsl:when test="$matchLib">
		<u><b><xsl:value-of select="$matchLib"/></b></u>
		</xsl:when>
		<xsl:when test="$matchGeneric">
		<u><b><xsl:value-of select="$matchGeneric"/></b></u>
		</xsl:when>
		<xsl:otherwise>
		<!-- Optional debug message -->
		<xsl:message terminate="no">[No additional_text match for label='<xsl:value-of select="$label"/>']</xsl:message>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>


	<xsl:template name="salutation"/>
	<xsl:template name="lastFooter">
		<table>
			<xsl:attribute name="style">
				<xsl:call-template name="footerTableStyleCss"/>
				<!-- style.xsl -->
			</xsl:attribute>
			<tr>
				<xsl:for-each select="notification_data/organization_unit">
					<xsl:attribute name="style">
						<xsl:call-template name="listStyleCss"/>
						<!-- style.xsl -->
					</xsl:attribute>
					<td align="center">
						<xsl:value-of select="name"/> <xsl:value-of select="line1"/> <xsl:value-of select="line2"/> <xsl:value-of select="city"/> <xsl:value-of select="postal_code"/> <xsl:value-of select="country"/>
					</td>
				</xsl:for-each>
			</tr>
		</table>
	</xsl:template>
	<!-- For cases when lastFooter should appear empty-->
	<xsl:template name="empty_lastFooter">
		<table>
			<xsl:attribute name="style">
				<xsl:call-template name="footerTableStyleCss"/>
				<!-- style.xsl -->
			</xsl:attribute>
			<tr>
				<xsl:for-each select="notification_data/organization_unit">
					<xsl:attribute name="style">
						<xsl:call-template name="listStyleCss"/>
						<!-- style.xsl -->
					</xsl:attribute>
					<td align="center">
						<br/>
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
	<!-- The following is a general template for adding text to letters
         it has various built-in pramaters (library id, letter language, etc) and more can be added if needed.
         It is important to notice the 'label' parameter, **mandatory** - in order to add a text to a letter.
         
         More details: 
         =============
         When we call this template, we do the following: 
         <xsl:call-template name="additional_text">
         <xsl:with-param name="label" select="label_name" />
         [some more optional parameters come here]
         </xsl:call-template>
         
         When calling the template, the value given to "label" will be used to determine what type of text is added to the letter.
         For example: 'text_01' label is used for FulPlaceOnHoldShelfLetter when it is sent by the Wiener Library - to notify the users that books would be waiting for them at another library
         Additional label types can be added in the same way. Recommended naming convention: 'text_x' where x is a number not used by previous labels (each label must have unique name)
         
         It would be best to utilize only this template for adding text to letters (when the built-in alma letter labels are not enough).
         
    -->
	<xsl:template name="additional_text">
		<xsl:param name="label"/>
		<!-- when calling the template, supply a value to this parameter! otherwise no output :-) -->
		<xsl:param name="lib_id" select="/notification_data/organization_unit/org_scope/library_id"/>
		<xsl:param name="letter_language" select="/notification_data/receivers/receiver/preferred_language"/>
		<xsl:param name="lib_name" select="/notification_data/organization_unit/name"/>
		<xsl:choose>
			<xsl:when test="not($label = '')">
				<xsl:choose>
					<!-- used for FulPlaceOnHoldShelfLetter sent by the Wiener Library -->
					<xsl:when test="$label = 'text_01'">
						<xsl:if test="$letter_language = 'he' and $lib_id='190905450004146'">
							<!-- Hebrew letter -->
							<u>
								<b>
									<xsl:text> בדלפק ההשאלה בספריה המרכזית</xsl:text>
								</b>
							</u>
						</xsl:if>
						<xsl:if test="not($letter_language = 'he') and $lib_id='190905450004146'">
							<u>
								<b>
									<xsl:text> from the circulation desk at the Central Library</xsl:text>
								</b>
							</u>
							<!-- English letter -->
						</xsl:if>
					</xsl:when>
					<xsl:when test="$label = 'text_02'">
						<xsl:if test="$letter_language = 'he'">
							<!-- Hebrew letter -->
							<u>
								<b>
									<xsl:text>קראו ספרים, עשו חיים</xsl:text>
								</b>
							</u>
						</xsl:if>
						<xsl:if test="not($letter_language = 'he')">
							<u>
								<b>
									<xsl:text>Read Books. Live Better</xsl:text>
								</b>
							</u>
							<!-- English letter -->
						</xsl:if>
					</xsl:when>
					<xsl:when test="$label = 'text_03'">
						<xsl:if test="$letter_language = 'he'">
							<!-- Hebrew letter -->
							<u>
								<b>
									<xsl:text>במידה וקיים קנס על איחור בהחזרה, ניתן לראותו </xsl:text>
								</b>
							</u>
						</xsl:if>
						<xsl:if test="not($letter_language = 'he')">
							<u>
								<b>
									<xsl:text>Accrued fines - if exist - are displyed in your </xsl:text>
								</b>
							</u>
							<!-- English letter -->
						</xsl:if>
					</xsl:when>
					<xsl:when test="$label = 'text_04'">
						<xsl:if test="$letter_language = 'he'">
							<!-- Hebrew letter -->
							<u>
								<b>
									<xsl:text>בכרטיס הקורא</xsl:text>
								</b>
							</u>
						</xsl:if>
						<xsl:if test="not($letter_language = 'he')">
							<u>
								<b>
									<xsl:text>library card.</xsl:text>
								</b>
							</u>
							<!-- English letter -->
						</xsl:if>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<!-- a barcode label in hebrew and english -->
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
	<!-- *********** RS CONTACT DETAILS - REVISED TEMPLATE *********** -->
	<xsl:template name="rs_details_display">
		<xsl:param name="library"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="/notification_data/languages/string != ''">
					<xsl:value-of select="/notification_data/languages/string"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text/>
					<!-- use for debugging when lib_id undefined -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="email">
			<xsl:choose>
				<xsl:when test="$library= 'AL1'">
					<!-- law library -->
					<xsl:text>lawill@tauex.tau.ac.il</xsl:text>
				</xsl:when>
				<xsl:when test="$library= 'AH1'">
					<!-- social sciences library -->
					<xsl:text>SMLILL@tauex.tau.ac.il</xsl:text>
				</xsl:when>
				<xsl:when test="$library= 'AS1'">
					<!-- exact sciences library -->
					<xsl:text>tusill@tauex.tau.ac.il</xsl:text>
				</xsl:when>
				<xsl:when test="$library= 'AM1'">
					<!-- life sciences library -->
					<xsl:text>illmail@tauex.tau.ac.il</xsl:text>
				</xsl:when>
				<xsl:when test="$library= 'AC1'">
					<!-- Central Library (resource sharing) -->
					<xsl:text>cenloan@tauex.tau.ac.il</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>no library found</xsl:text>
					<!-- use for debugging when lib_id undefined -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="rs_desc">
			<xsl:choose>
				<xsl:when test="not(contains('|he|en|', concat('|', $language, '|')))">
					<!-- no valid letter_language is found -->
					<xsl:text/>
					<!-- use for debugging when letter_language undefined -->
				</xsl:when>
				<xsl:when test="($library= 'AL1') or ($library= 'AS1') or ($library= 'AM1')">
					<!-- law library|exact sciences library|life sciences library -->
					<xsl:if test="$language='he'">
						<xsl:text>מדור השאלה בינספרייתית</xsl:text>
					</xsl:if>
					<xsl:if test="$language='en'">
						<xsl:text>Interlibrary Loan Department</xsl:text>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$library= 'AH1'">
					<!-- social sciences library -->
					<xsl:if test="$language='he'">
						<xsl:text>שירותי השאלה בינספרייתית ואספקת פרסומים</xsl:text>
					</xsl:if>
					<xsl:if test="$language='en'">
						<xsl:text>Interlibrary Loan and Document Delivery Services</xsl:text>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$library= 'AC1'">
					<!-- Central Library (resource sharing) -->
					<xsl:choose>
						<xsl:when test="$language = 'he'">
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
		<xsl:variable name="rs_phone">
			<xsl:choose>
				<xsl:when test="$language='he'">
					<xsl:choose>
						<xsl:when test="$library= 'AL1'">
							<!-- law library -->
							<xsl:text>טלפון: 03-6406172 ; 03-6406232</xsl:text>
						</xsl:when>
						<xsl:when test="$library= 'AH1'">
							<!-- social sciences library -->
							<xsl:text>טלפון: 03-6407066 ; 03-6405501 | פקס: 03-6407840</xsl:text>
						</xsl:when>
						<xsl:when test="$library= 'AS1'">
							<!-- exact sciences library -->
							<xsl:text>טלפון: 03-6409269</xsl:text>
						</xsl:when>
						<xsl:when test="$library= 'AM1'">
							<!-- life sciences library -->
							<xsl:text>טלפון: 03-6407966; 03-6409752</xsl:text>
						</xsl:when>
						<xsl:when test="$library= 'AC1'">
							<!-- Central Library (resource sharing) -->
							<xsl:text>טלפון: 972-3-6408746</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$language='en'">
					<xsl:choose>
						<xsl:when test="$library= 'AL1'">
							<!-- law library -->
							<xsl:text>Phone: 03-6406172 ; 03-6406232</xsl:text>
						</xsl:when>
						<xsl:when test="$library= 'AH1'">
							<!-- social sciences library -->
							<xsl:text>Phone: 03-6407066 ; 03-6405501 | Fax: 03-6407840</xsl:text>
						</xsl:when>
						<xsl:when test="$library= 'AS1'">
							<!-- exact sciences library -->
							<xsl:text>Phone: 03-6409269</xsl:text>
						</xsl:when>
						<xsl:when test="$library= 'AM1'">
							<!-- life sciences library -->
							<xsl:text>Phone: 03-6407966; 03-6409752</xsl:text>
						</xsl:when>
						<xsl:when test="$library= 'AC1'">
							<!-- Central Library (resource sharing) -->
							<xsl:text>Phone: 972-3-6408746</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!-- display part -->
		<table>
			<tr>
				<td>
					<b>
						<xsl:value-of select="$rs_desc"/>
					</b>
				</td>
			</tr>
			<tr>
				<td>
					<xsl:choose>
						<xsl:when test="$library = 'AC1'">
							<!-- Central Library (resource sharing) -->
							<xsl:choose>
								<xsl:when test="$language = 'he'">
									<b>הספרייה המרכזית ע"ש סוראסקי</b>
								</xsl:when>
								<xsl:otherwise>
									<b>Sourasky Central Library</b>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="contains('|AL1|AS1|AH1|AM1|', concat('|', $library, '|'))">
							<!-- All other libraries -->
							<xsl:choose>
								<xsl:when test="$language = 'he'">
									<xsl:choose>
										<xsl:when test="$library = 'AL1'">
											<b>הספרייה למשפטים ע&quot;ש דוד י. לייט</b>
										</xsl:when>
										<xsl:when test="$library = 'AH1'">
											<b>הספרייה למדעי החברה, לניהול ולחינוך</b>
										</xsl:when>
										<xsl:when test="$library = 'AS1'">
											<b>הספרייה למדעים מדויקים ולהנדסה</b>
										</xsl:when>
										<xsl:when test="$library = 'AM1'">
											<b>הספרייה למדעי החיים ולרפואה</b>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="$language = 'en'">
									<xsl:choose>
										<xsl:when test="$library = 'AL1'">
											<b>The David J. Light Law Library</b>
										</xsl:when>
										<xsl:when test="$library = 'AH1'">
											<b>Social Sciences, Management and Education Library</b>
										</xsl:when>
										<xsl:when test="$library = 'AS1'">
											<b>Exact Sciences and Engineering Library</b>
										</xsl:when>
										<xsl:when test="$library = 'AM1'">
											<b>Life Sciences and Medicine Library</b>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<!--  could not find lib_id or lib_code -->
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td>
					<b>
						<xsl:value-of select="$rs_phone"/> |
						<xsl:choose>
							<xsl:when test="$language = 'he'">
								דוא"ל:
							</xsl:when>
							<xsl:otherwise>
								Email:
							</xsl:otherwise>
						</xsl:choose>
						<a href="mailto:{$email}">
							<xsl:value-of select="$email"/>
						</a>
					</b>
				</td>
			</tr>
		</table>
		<br/>
	</xsl:template>
	<xsl:template name="rs_details">
		<xsl:variable name="lib_id">
			<xsl:choose>
				<xsl:when test="/notification_data/library/org_scope/library_id != ''">
					<!-- relevent for letters:..... -->
					<xsl:value-of select="/notification_data/library/org_scope/library_id"/>
				</xsl:when>
				<xsl:when test="/notification_data/incoming_request/library_id != ''">
					<!-- relevent for letters:..... -->
					<xsl:value-of select="/notification_data/incoming_request/library_id"/>
				</xsl:when>
				<xsl:when test="/notification_data/receivers/receiver/user/library_code != ''">
					<xsl:value-of select="/notification_data/receivers/receiver/user/library_code"/>
				</xsl:when>
				<xsl:when test="/notification_data/organization_unit/org_scope/library_id != ''">
					<xsl:value-of select="/notification_data/organization_unit/org_scope/library_id"/>
				</xsl:when>
				<!-- relevent for letters: FulDigitizationDocumentDeliveryNotificationLetter -->
				<xsl:when test="/notification_data/receivers/receiver/user/library_code_original_value != ''">
					<xsl:value-of select="/notification_data/receivers/receiver/user/library_code_original_value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text/>
					<!-- use for debugging when lib_id undefined -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="($lib_id = '190893010004146') or (contains($lib_id, 'AH1'))">
			<xsl:call-template name="rs_details_display">
				<xsl:with-param name="library" select="'AH1'"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="($lib_id = '190896720004146') or (contains($lib_id, 'AL1'))">
			<xsl:call-template name="rs_details_display">
				<xsl:with-param name="library" select="'AL1'"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="($lib_id = '190902540004146') or (contains($lib_id, 'AS1'))">
			<xsl:call-template name="rs_details_display">
				<xsl:with-param name="library" select="'AS1'"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="($lib_id = '190899330004146') or (contains($lib_id, 'AM1'))">
			<xsl:call-template name="rs_details_display">
				<xsl:with-param name="library" select="'AM1'"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="($lib_id = '12900830000231') or (contains($lib_id, 'RES_SHARE'))">
			<xsl:call-template name="rs_details_display">
				<xsl:with-param name="library" select="'AC1'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- the following template designed to provide copyright message specifically for the Central Library RS
         it was tested and applied only for the GeneralMessageEmailLetter, 
         not tested on other letters yet
    -->
	<xsl:template name="rs_copyright">
		<xsl:param name="lib_id" select="/notification_data/library/org_scope/library_id"/>
		<xsl:param name="lib_code" select="/notification_data/receivers/receiver/user/library_code_original_value"/>
		<!-- 'lib_code' identifies the rs library that handles requests in FulDigitizationDocumentDeliveryNotificationLetter 
             the possible values are: RES_SHARE ; AL1 ; AH1 ; AS1 ; AM1 -->
		<xsl:choose>
			<xsl:when test="/notification_data/languages/string != 'he'">
				<tr>
					<td>
						<b>Please note: Articles/Chapters may be used for research and study purposes only.</b>
					</td>
				</tr>
				<xsl:if test="($lib_id = '12900830000231') or ($lib_code = 'RES_SHARE')">
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
				<xsl:if test="($lib_id = '12900830000231') or ($lib_code = 'RES_SHARE')">
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
		<xsl:param name="lib_id" select="/notification_data/library/org_scope/library_id"/>
		<xsl:param name="letter_language" select="/notification_data/receivers/receiver/user/user_preferred_language"/>
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
	<!-- this template receives param of library identifier and returns library phone and email seperated by "|" -->
	<xsl:template name="get_lib_contact_details">
		<xsl:param name="lib_id_or_name" select="/notification_data/library/org_scope/library_id"/>
		<!-- maybe should expand select options here with OR ?-->
		<xsl:choose>
			<!-- library selection  -->
			<xsl:when test="contains($lib_id_or_name,'הספרייה למדעי החברה, לניהול ולחינוך') or contains($lib_id_or_name,'Social Sciences, Management and Education Library')">
				<xsl:text>03-6409085 | SMLCirc@tauex.tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="contains($lib_id_or_name ,'השאלה בינספרייתית - הספרייה המרכזית') or contains($lib_id_or_name,'Interlibrary Loan - Sourasky Central Library') or contains(.,'ILL - Sourasky Central Library')">
				<xsl:text>972-3-6408746 | cenloan@tauex.tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="contains($lib_id_or_name ,'הספרייה המרכזית') or contains($lib_id_or_name,'Sourasky Central Library')">
				<xsl:text>03-6408662 | cenc@tauex.tau.ac.il </xsl:text>
			</xsl:when>
			<xsl:when test="contains($lib_id_or_name ,'הספרייה למשפטים ע&quot;ש דוד י. לייט') or contains($lib_id_or_name,'The David J. Light Law Library')">
				<xsl:text>03-6408356 | lawlibdalpak@tauex.tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="contains($lib_id_or_name ,'הספרייה לארכיאולוגיה') or contains($lib_id_or_name,'Archaeology Sub-Library')">
				<xsl:text>03-6409023 | libarc@tauex.tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="contains($lib_id_or_name ,'הספרייה לאדריכלות') or contains($lib_id_or_name,'Architecture Sub-Library')">
				<xsl:text>03-6405535 | archlib@tauex.tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="contains($lib_id_or_name ,'הספרייה להפרעות בתקשורת, שיבא') or contains($lib_id_or_name,'Communication Disorders Library, Sheba Hospital')">
				<xsl:text>03-5349817, 03-6409217 שלוחה 111 | tamarar@tauex.tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="contains($lib_id_or_name ,'הספרייה למדעים מדויקים ולהנדסה') or contains($lib_id_or_name,'Exact Sciences and Engineering Library')">
				<xsl:text>03-6408145 | circulation@tauex.tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="contains($lib_id_or_name ,'ספריית גיאוגרפיה') or contains($lib_id_or_name,'Geography Sub-Library')">
				<xsl:text>03-6409044 | geogmaps@tauex.tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="contains($lib_id_or_name ,'הספרייה למדעי החיים ולרפואה') or contains($lib_id_or_name,'Life Sciences and Medicine Library')">
				<xsl:text>03-6409195 | medcirc@tauex.tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="contains($lib_id_or_name ,'הספרייה לעבודה סוציאלית') or contains($lib_id_or_name,'Social Work Library')">
				<xsl:text>03-6409183 | Estyr@tauex.tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="contains($lib_id_or_name ,'ספריית וינר') or contains($lib_id_or_name,'Wiener Library')">
				<xsl:text>972-3-6407832 | wiener@tauex.tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:when test="contains($lib_id_or_name ,'הספרייה למוסיקה') or contains($lib_id_or_name,'Music Sub-Library')">
				<xsl:text>03-6408716 | muslib@post.tau.ac.il</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<br/>
				<xsl:value-of select="$lib_id_or_name"/>
			</xsl:otherwise>
		</xsl:choose>
		<!-- library end  -->
	</xsl:template>
	<!-- feeTable template adds fees table with library's contact details (phone number and email) which appears at the end of the FulUserBorrowingActivityLetter
    -->
	<xsl:template name="feesTable">
		<xsl:param name="letter_language" select="/notification_data/receivers/receiver/user/user_preferred_language"/>
		<table cellpadding="5" class="listing">
			<xsl:attribute name="style">
				<xsl:call-template name="mainTableStyleCss"/>
			</xsl:attribute>
			<tr align="center" bgcolor="#f5f5f5">
				<td colspan="3">
					<table cellpadding="20">
						<tr align="center" bgcolor="#f5f5f5">
							<td align="center" colspan="3">
								<xsl:choose>
									<xsl:when test="$letter_language = 'he' ">
										<!-- Hebrew -->
										<h3 style="color:#ff9933;">תזכורת - קיים לך חוב</h3>
									</xsl:when>
									<xsl:otherwise>
										<h3>We would like to remind you that you have a debt</h3>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<xsl:choose>
					<xsl:when test="$letter_language = 'he' ">
						<!-- Hebrew -->
						<th>ספרייה<!-- library name header (heb) -->
						</th>
						<th>סכום לתשלום<!-- fee amount header (heb) -->
						</th>
						<th>פרטי התקשרות<!-- contact us header (heb) -->
						</th>
					</xsl:when>
					<!-- not Hebrew -->
					<xsl:otherwise>
						<th>Library<!-- library name header (eng) -->
						</th>
						<th>Fee Amount<!-- fee amount header (eng) -->
						</th>
						<th>Contact us<!-- contact us header (eng)-->
						</th>
					</xsl:otherwise>
				</xsl:choose>
			</tr>
			<xsl:for-each select="notification_data/organization_fee_list/string">
				<tr>
					<td align="center">
						<xsl:value-of select="substring-before(., ':')"/>
					</td>
					<td align="center">
						<xsl:value-of select="substring-after(., ':')"/>
					</td>
					<td align="center">
						<xsl:call-template name="get_lib_contact_details">
							<xsl:with-param name="lib_id_or_name" select="."/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
</xsl:stylesheet>
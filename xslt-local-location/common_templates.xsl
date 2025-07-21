<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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

</xsl:stylesheet>
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<xsl:include href="header.xsl" />
<xsl:include href="senderReceiver.xsl" />
<xsl:include href="mailReason.xsl" />
<xsl:include href="footer.xsl" />
<xsl:include href="style.xsl" />
<xsl:include href="recordTitle.xsl" />

<xsl:template match="/">
	<html>
		<head>
		<xsl:call-template name="generalStyle" />
		</head>

			<body>
			<xsl:attribute name="style">
				<xsl:call-template name="bodyStyleCss" /> <!-- style.xsl -->
			</xsl:attribute>

				
				
				
				<!-- 02-08-18 checks if letter in RS or not, and gives the correct contact details accordingly 
				need to test if this works and if the contact details fits in the letter's general layout
				-->
				<xsl:choose>
					<xsl:when test="/notification_data/request/resource_sharing_request_id != ''"> <!-- RS letter-->
					<!-- if RS loan, do not unclude contact details here (they appear below only) -->
						<xsl:call-template name="headFulPlaceOnHoldShelfLetterRS" /> <!-- header.xsl -->
						<br />
					</xsl:when>
					<xsl:otherwise> <!-- not RS letter-->
						<xsl:call-template name="head" /> <!-- header.xsl -->
						<xsl:call-template name="senderReceiverRevised" />  <!-- SenderReceiver.xsl -->
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:call-template name="toWhomIsConcerned" /> <!-- mailReason.xsl -->

				<div class="messageArea">
					<div class="messageBody">
						<table cellspacing="0" cellpadding="5" border="0">
							<tr>
								<td>@@following_item_requested_on@@ @@can_picked_at@@<!--This template call is used for letters sent from Wiener Library--><xsl:call-template name="additional_text">
<xsl:with-param name="label" select="'text_01'" />
<xsl:with-param name="lib_id" select="/notification_data/organization_unit/org_scope/library_id" />
<xsl:with-param name="letter_language" select="/notification_data/receivers/receiver/preferred_language" />
</xsl:call-template>.
									<xsl:if test="notification_data/request/work_flow_entity/expiration_date">
										@@note_item_held_until@@ <xsl:value-of select="notification_data/request/work_flow_entity/expiration_date"/>.
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td><xsl:call-template name="recordTitleExtendedTable" /> <!-- recordTitle.xsl --></td>
							</tr>
							<!--
							this commented out part is for additional notes about late loans etc.
							<xsl:if test="notification_data/request/system_notes !=''">
								<tr>
									<td><b>@@notes_affect_loan@@:</b></td>
								</tr>
								
								<tr>
									<td><xsl:value-of select="notification_data/request/system_notes"/></td>
								</tr>
							</xsl:if>
							-->
							
						</table>
					</div>
				</div>
				<br />
				<table cellspacing="5">
						<tr><td>@@sincerely@@</td></tr>
						<xsl:choose>
							<xsl:when test="/notification_data/request/resource_sharing_request_id != ''"> <!-- RS letter-->
								<xsl:call-template name="rs_dept_details"> <!-- footer.xsl -->
									 <xsl:with-param name="lib_id" select="/notification_data/organization_unit/org_scope/library_id" />
									 <xsl:with-param name="letter_language" select="/notification_data/receivers/receiver/user/user_preferred_language" />
									 <xsl:with-param name="lib_name" select="/notification_data/organization_unit/name" /> 
								</xsl:call-template>				
							</xsl:when>
							<xsl:otherwise> <!-- not RS letter-->
								<tr>
									<td>@@department@@ /</td>
									<td><xsl:value-of select="notification_data/organization_unit/name"/> / </td>
									<td><xsl:value-of select="notification_data/organization_unit/phone/phone"/> / </td>
							<td><a href="mailto:{notification_data/organization_unit/email/email}"><xsl:value-of select="notification_data/organization_unit/email/email" /></a></td>
						</tr>
							</xsl:otherwise>
						</xsl:choose>
				</table>
				
				<!-- footer.xsl -->
				<xsl:call-template name="lastFooter" />
				<xsl:call-template name="donotreply">
					<xsl:with-param name="lib_id" select="/notification_data/organization_unit/org_scope/library_id" />
					<xsl:with-param name="letter_language" select="/notification_data/receivers/receiver/user/user_preferred_language" />
				</xsl:call-template>
				
				<!--
				<xsl:call-template name="contactUs" />
				<xsl:call-template name="myAccount" />
				-->
			</body>
	</html>
	</xsl:template>



</xsl:stylesheet>
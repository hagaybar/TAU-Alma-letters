<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="header.xsl" />
	<xsl:include href="senderReceiver.xsl" />
	<xsl:include href="footer.xsl" />
	<xsl:include href="style.xsl" />

	<xsl:template match="/">
		<html>
			<head>
				<xsl:call-template name="generalStyle" />
			</head>

			<body>
				<xsl:attribute name="style">
					<xsl:call-template name="bodyStyleCss" /> <!-- style.xsl -->
				</xsl:attribute>
<!-- 
I am not able to customize the head since user gets one message for all overdue notification types
and I can not differentiate messages by the notification_type. The solution = added column: notification_type (for each item, how many notifications were sent).
Its based on values located in: /notification_data/loans_by_library/library_loans_for_display/item_loans/overdue_and_lost_loan_notification_display/item_loan/notified_by_profiles
-->

				<xsl:call-template name="head" /> <!-- header.xsl -->
				<xsl:call-template name="senderReceiverRevised" /> <!-- SenderReceiver.xsl -->

				<br />


				<table cellspacing="0" cellpadding="5" border="0">
					<tr>
						<td>
							<h>@@inform_you_item_below@@ </h>
						</td>
					</tr>
				</table>

				<table cellpadding="5" class="listing">
					<xsl:attribute name="style">
						<xsl:call-template name="mainTableStyleCss" /> <!-- style.xsl -->
					</xsl:attribute>
					
					<xsl:for-each select="notification_data/loans_by_library/library_loans_for_display">
						<tr>
							<td>
								<table cellpadding="5" class="listing">
									<xsl:attribute name="style">
										<xsl:call-template name="mainTableStyleCss" />
									</xsl:attribute>
									<tr align="center" bgcolor="#f5f5f5">
										<td colspan="8">
											<!-- add cell padding to the table ? <table cellpadding="10"></table> -->
											<table cellpadding="20">
												<tr align="center" bgcolor="#f5f5f5">
													<td align="center" colspan="2">
														<!-- library name -->
														<h3><xsl:value-of select="organization_unit/name" /></h3>
													</td>
													<td align="center">
														<!-- library phone number -->
														<xsl:value-of select="organization_unit/phone/phone" />
													</td>
													<td align="center">
														<!-- library email address -->
														<a href="mailto:{organization_unit/email/email}"><xsl:value-of select="organization_unit/email/email" /></a>
													</td>

												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<th>@@lost_item@@</th>
										<th>@@description@@</th>
										<th>@@library@@</th>
										<th>@@loan_date@@</th>
										<th>@@due_date@@</th>
										<th>@@barcode@@</th>
										<th>@@notification_type@@</th> <!-- How many notifications were sent - first/second/third/fourth -->
										<th>@@charged_with_fines_fees@@</th>
									</tr>

									<xsl:for-each select="item_loans/overdue_and_lost_loan_notification_display">
										<tr>
											<td><xsl:value-of select="item_loan/title"/></td>
											<td><xsl:value-of select="item_loan/item_description"/></td>
											<td><xsl:value-of select="physical_item_display_for_printing/library_name"/></td>
											<td><xsl:value-of select="item_loan/loan_date"/></td>
											<td><xsl:value-of select="item_loan/due_date"/></td>
											<td><xsl:value-of select="item_loan/barcode"/></td> <!-- here the condition should be placed, give message according to number of notifications made. can use global vars as well -->
											<td>
											 <!-- here the condition checks which notice number should be placed, utilizing the labels additional_info_1_type1 - 4 -->
												<xsl:choose>
													<xsl:when test="item_loan/notified_by_profiles='Overdue notice - 1;'">
													@@additional_info_1_type1@@
													</xsl:when>
													<xsl:when test="item_loan/notified_by_profiles='Overdue notice - 1;Overdue notice - 2;'">
													@@additional_info_1_type2@@
													</xsl:when>
													<xsl:when test="item_loan/notified_by_profiles='Overdue notice - 1;Overdue notice - 2;Overdue notice - 3;'">
													@@additional_info_1_type3@@
													</xsl:when>
													<xsl:when test="item_loan/notified_by_profiles='Overdue notice - 1;Overdue notice - 2;Overdue notice - 3;Overdue notice - 4;'">
													@@additional_info_1_type4@@
													</xsl:when>
													<xsl:otherwise>
													</xsl:otherwise>
												</xsl:choose>
											
											</td>
											<td>
												<xsl:for-each select="fines_fees_list/user_fines_fees">
													<b><xsl:value-of select="fine_fee_type_display"/>: </b><xsl:value-of select="fine_fee_ammount/sum"/>&#160;<xsl:value-of select="fine_fee_ammount/currency"/>&#160;<xsl:value-of select="ff"/>
													<br />
												</xsl:for-each>
											</td>
										</tr>
									</xsl:for-each>
								</table>
							</td>
						</tr>
						<hr/><br/>
					</xsl:for-each>
					<xsl:if test="notification_data/overdue_notification_fee_amount/sum !=''">
						<tr>
							<td>
								<b>@@overdue_notification_fee@@ </b>
								<xsl:value-of select="notification_data/overdue_notification_fee_amount/sum"/>&#160;<xsl:value-of select="notification_data/overdue_notification_fee_amount/currency"/>&#160;<xsl:value-of select="ff"/>
							</td>
						</tr>
					</xsl:if>
					<br />
					<!--
					<br />
					@@additional_info_1@@
					<br />
					@@additional_info_2@@
					-->
					<br />
					<table>

						<tr><td>@@sincerely@@</td></tr>
						<xsl:choose>
						
							<xsl:when test="/notification_data/organization_unit/code = '972TAU_INST'">
								<xsl:if test="/notification_data/receivers/receiver/user/user_preferred_language = 'he'">
									<tr>
										<td>צוות מדורי השאלה בספריות אוניברסיטת תל אביב</td>
									</tr>
								</xsl:if>
								<xsl:if test="/notification_data/receivers/receiver/user/user_preferred_language != 'he'">
									<tr>
										<td>Circulation Departments in Tel Aviv University</td>
									</tr>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<tr>
									<td>@@department@@ /</td>
									<td><xsl:value-of select="notification_data/organization_unit/name"/> / </td>
									<td><xsl:value-of select="notification_data/organization_unit/phone/phone"/> / </td>
									<td><a href="mailto:{notification_data/organization_unit/email/email}"><xsl:value-of select="notification_data/organization_unit/email/email" /></a></td>
								</tr>
							</xsl:otherwise>
						</xsl:choose>
					</table>
				</table>
				<br />

				<xsl:call-template name="lastFooter" /> <!-- footer.xsl -->
				<xsl:call-template name="donotreply" />   <!-- footer.xsl -->

			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
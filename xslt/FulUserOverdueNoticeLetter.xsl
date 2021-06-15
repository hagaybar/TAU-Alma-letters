<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="header.xsl"/>
	<xsl:include href="senderReceiver.xsl"/>
	<xsl:include href="mailReason.xsl"/>
	<xsl:include href="footer.xsl"/>
	<xsl:include href="style.xsl"/>
	<xsl:include href="recordTitle.xsl"/>
	<xsl:template match="/">
		<html>
			<head>
				<xsl:call-template name="generalStyle"/>
			</head>
			<body>
				<xsl:attribute name="style">
					<xsl:call-template name="bodyStyleCss"/>
					<!-- style.xsl -->
				</xsl:attribute>
				<xsl:call-template name="head"/>
				<!-- header.xsl -->
				<xsl:call-template name="senderReceiverRevised"/>
				<!-- SenderReceiver.xsl -->
				<br/>
				<xsl:call-template name="toWhomIsConcerned"/>
				<!-- mailReason.xsl -->
				<div class="messageArea">
					<div class="messageBody">
						<table cellspacing="0" cellpadding="5" border="0">
							<tr>
								<td>
									<b>@@message@@</b>
									<br/>
									<br/>
								</td>
							</tr>
							<tr>
								<td>
									<b>@@loans@@</b>
								</td>
							</tr>
							<!-- alternative table content begin... -->
							<xsl:for-each select="notification_data/loans_by_library/library_loans_for_display">
								<tr>
									<td>
										<table cellpadding="5" class="listing">
											<xsl:attribute name="style">
												<xsl:call-template name="mainTableStyleCss"/>
											</xsl:attribute>
											<tr align="center" bgcolor="#f5f5f5">
												<td colspan="4">
													<!-- add cell padding to the table ? <table cellpadding="10"></table> -->
													<table cellpadding="20">
														<tr align="center" bgcolor="#f5f5f5">
															<td align="center" colspan="2">
																<!-- library name -->
																<h3>
																	<xsl:value-of select="organization_unit/name"/>
																</h3>
															</td>
															<td align="center">
																<!-- library phone number -->
																<xsl:value-of select="organization_unit/phone/phone"/>
															</td>
															<td align="center">
																<!-- library email address -->
																<a href="mailto:{organization_unit/email/email}">
																	<xsl:value-of select="organization_unit/email/email"/>
																</a>
															</td>
														</tr>
													</table>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<table cellpadding="5" class="listing">
											<xsl:attribute name="style">
												<xsl:call-template name="mainTableStyleCss"/>
												<!-- style.xsl -->
											</xsl:attribute>
											<tr>
												<th>@@title@@</th>
												<th>
													<xsl:call-template name="barcode"/>
												</th>
												<!-- custom template in footer.xsl -->
												<!-- <th>@@author@@</th> -->
												<th>@@due_date@@</th>
												<!-- <th>@@library@@</th> -->
											</tr>
											<xsl:for-each select="item_loans/overdue_and_lost_loan_notification_display">
												<tr>
													<td>
														<xsl:value-of select="item_loan/title"/>
														<xsl:if test="item_loan/item_description != ''">
															<xsl:text>, </xsl:text><xsl:value-of select="item_loan/item_description"/>
														</xsl:if>
													</td>
													<!--item title and item description-->
													<td>
														<xsl:value-of select="item_loan/barcode"/>
													</td>
													<!--barcode-->
													<!-- <td><xsl:value-of select="author"/></td> -->
													<td>
														<xsl:value-of select="item_loan/new_due_date_str"/>
													</td>
													<!--due date-->
													<!--
													<td>
														<xsl:value-of select="item_loan/library_name"/>
													</td>
													-->
													<!--library name-->
												</tr>
											</xsl:for-each>
										</table>
									</td>
								</tr>
							</xsl:for-each>
							<!--
									<td><xsl:value-of select="notification_data/loans_by_library/library_loans_for_display/organization_unit/email/email"/></td>  
									<td><xsl:value-of select="notification_data/loans_by_library/library_loans_for_display/organization_unit/phone/phone"/></td>  
 -->
							<!-- alternative table content end... -->
						</table>
						<br/>
						<br/>
						@@additional_info_1@@
						<br/>
						@@additional_info_2@@
						<br/>
						<table>
							<tr>
								<td>@@sincerely@@</td>
							</tr>
							<tr>
								<td>@@department@@</td>
							</tr>
						</table>
					</div>
				</div>
				<!-- footer.xsl -->
				<xsl:call-template name="lastFooter"/>
				<xsl:call-template name="donotreply"/>
				<!--
				<xsl:call-template name="contactUs" />
				<xsl:call-template name="myAccount" />
				-->
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
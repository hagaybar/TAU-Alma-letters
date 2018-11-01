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
          <xsl:call-template name="bodyStyleCss" /><!-- style.xsl -->
        </xsl:attribute>

        <xsl:call-template name="head" /><!-- header.xsl -->
        <xsl:call-template name="senderReceiverRevised" />  <!-- SenderReceiver.xsl -->
		
		<br />
		<xsl:call-template name="toWhomIsConcerned" /> <!-- mailReason.xsl -->


        <div class="messageArea">
          <div class="messageBody">

			<table cellspacing="0" cellpadding="5" border="0">

			  <xsl:if test="notification_data/item_loans/item_loan or notification_data/overdue_item_loans/item_loan">

	              <tr>
	              	<td>
						<b>@@reminder_message@@</b>
						<br/><br/>
	                </td>
	              </tr>

	              <xsl:if test="notification_data/overdue_loans_by_library/library_loans_for_display">

		              <tr>
		              	<td>
							<b>@@overdue_loans@@</b>
		                </td>
		              </tr>

					<xsl:for-each select="notification_data/overdue_loans_by_library/library_loans_for_display">
						  <tr>
							<td>
								<table cellpadding="5" class="listing">
									<xsl:attribute name="style">
										<xsl:call-template name="mainTableStyleCss" />
									</xsl:attribute>
									<tr align="center" bgcolor="#f5f5f5">
										<td colspan="4">
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
										<th>@@title@@</th>
										<th><xsl:call-template name="barcode" /></th> <!-- custom template in footer.xsl -->
										<th>@@fine@@</th>
										<th>@@due_date@@</th>

									</tr>

									<xsl:for-each select="item_loans/overdue_and_lost_loan_notification_display/item_loan">
										<tr>
											<td><xsl:value-of select="title"/> <xsl:value-of select="description"/></td>
											<td><xsl:value-of select="barcode"/></td>
											<td><xsl:value-of select="fine"/></td>
											<td><xsl:value-of select="due_date"/></td>
										</tr>
									</xsl:for-each>
								</table>
							</td>
						</tr>
						<hr/><br/>
					</xsl:for-each>
				</xsl:if>

				<xsl:if test="notification_data/loans_by_library/library_loans_for_display">

				  <tr>
					<td>
						<b>@@loans@@</b>
					</td>
				  </tr>

					<xsl:for-each select="notification_data/loans_by_library/library_loans_for_display">
						<tr>
							<td>
								<table cellpadding="4" class="listing">
									<xsl:attribute name="style">
										<xsl:call-template name="mainTableStyleCss" />
									</xsl:attribute>
									<tr align="center" bgcolor="#f5f5f5">
										<td colspan="5">
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
										<th>@@title@@</th>
										<th><xsl:call-template name="barcode" /></th> <!-- custom template in footer.xsl -->
										<th>@@fine@@</th>
										<!-- <th>@@due_date@@</th> -->
									</tr>

									<xsl:for-each select="item_loans/overdue_and_lost_loan_notification_display/item_loan">
										<tr>
											<td><xsl:value-of select="title"/> <xsl:value-of select="description"/></td>
											<td><xsl:value-of select="barcode"/></td>
											<td><xsl:value-of select="fine"/></td>
											<!-- <td><xsl:value-of select="due_date"/></td> -->
										</tr>
									</xsl:for-each>
								</table>
							</td>
						</tr>
						<hr/><br/>
					</xsl:for-each>
				</xsl:if>

			  </xsl:if>

			  <xsl:if test="notification_data/organization_fee_list/string">
	              <tr>
	              	<td>
						<b>@@debt_message@@</b>
	                </td>
	              </tr>
				  
				  <xsl:call-template name="feeContactDetails" />

				  <tr>
	              	<td>
						<b>
						@@total@@ <xsl:value-of select="notification_data/total_fee"/>
						</b>
	                </td>
	              </tr>

	              <tr>
	              	<td>
						<b>@@please_pay_message@@</b>
						<br/><br/>
	                </td>
	              </tr>

			  </xsl:if>
            </table>

			<br />

			<table>
				<tr><td>@@sincerely@@</td></tr>
				<tr><td>@@department@@</td></tr>
			</table>

          </div>
        </div>

        <!-- footer.xsl -->
        <xsl:call-template name="lastFooter" />
		<xsl:call-template name="donotreply" />
         <!-- 
        <xsl:call-template name="myAccount" />
		<xsl:call-template name="contactUs" />
         -->
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>

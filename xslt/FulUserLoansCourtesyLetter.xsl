<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:key name="items-by-library" match="item_loan" use="library_name" />
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
					<xsl:call-template name="bodyStyleCss" />
					<!-- style.xsl -->
				</xsl:attribute>
				<xsl:call-template name="head" />
				<!-- header.xsl -->
				<xsl:call-template name="senderReceiverRevised" />
				<!-- SenderReceiver.xsl -->
				<!-- SenderReceiver.xsl -->
				<br />
				<xsl:call-template name="toWhomIsConcerned" />
				<!-- mailReason.xsl -->
				<div class="messageArea">
					<div class="messageBody">

							<table cellspacing="0" cellpadding="5" border="0">
								<tr>
									<td>
										<b>@@message@@</b>
										<br />
										<br />
										@@additional_info_1@@

										<br/>
									</td>
								</tr>
								<tr>
									<td>
										<b>@@loans@@</b>
									</td>
								</tr>
								<tr>
									<td>
										<xsl:for-each select="notification_data/item_loans/item_loan[count(. | key('items-by-library', library_name)[1]) = 1]">
											<xsl:sort select="library_name" />

											<table cellpadding="5" class="listing">
												<xsl:attribute name="style">
													<xsl:call-template name="mainTableStyleCss" />
													<!-- style.xsl -->
												</xsl:attribute>
												
												<tr align="center" bgcolor="#f5f5f5">
													<td colspan="3">
														<h3><xsl:value-of select="library_name" /></h3>
													</td>
												</tr>
												<tr>
													<th>@@title@@</th>
													<th><xsl:call-template name="barcode" /></th> <!-- custom template in footer.xsl -->
													<th>@@due_date@@</th>
												</tr>
												<xsl:for-each select="key('items-by-library', library_name)">
													<xsl:sort select="library_name" />
													<tr> 
														<td>
															<xsl:value-of select="title" />
														</td> 
														<td>
															<xsl:value-of select="barcode" />
														</td>
														<td>
															<xsl:value-of select="due_date" />
														</td>
													</tr>
												</xsl:for-each>
											</table>
										</xsl:for-each>
									</td>
								</tr>
							</table>
						

						<br />

						<br />
			@@additional_info_2@@

						<br />
						<table cellspacing="20">
							<tr>
								<td>@@sincerely@@</td>
							</tr>
							<tr>
								<td>@@department@@ </td>
							</tr>
						</table>
					</div>
				</div>


				<!-- footer.xsl -->
				<xsl:call-template name="lastFooter" />
				<xsl:call-template name="donotreply" />

				<!--
				<xsl:call-template name="contactUs" />
				<xsl:call-template name="myAccount" />
				-->
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>

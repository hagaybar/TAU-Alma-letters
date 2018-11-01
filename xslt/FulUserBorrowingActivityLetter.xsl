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

  <!-- 'circ_mail_text' contains the text for the library's email link. 
	   If the letter's language is Hebrew, the text is in Hebrew, otherwise its in English  -->
	
	<xsl:variable name="circ_mail_text">
		<xsl:choose>
			<xsl:when test="/notification_data/receivers/receiver/preferred_language = 'he'">
				<xsl:text>צרו קשר למידע נוסף על השאלה זו</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Contact us for more information about this loan</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

  <!-- 'mail_tab_text' contains the text for the column header, in which the library's email link will appear, 
	   If the letter's language is Hebrew, the text is in Hebrew, otherwise its in English  -->
	
	<xsl:variable name="mail_tab_text">
		<xsl:choose>
			<xsl:when test="/notification_data/receivers/receiver/preferred_language = 'he'">
				<xsl:text>צרו קשר</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Contact Us</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	
		<html>
			<head>
				<xsl:call-template name="generalStyle" />
			</head>
			<body>
				<xsl:attribute name="style">
					<xsl:call-template name="bodyStyleCss" /><!-- style.xsl -->
				</xsl:attribute>

				<xsl:call-template name="head" /><!-- header.xsl -->
				<xsl:call-template name="senderReceiver" /> <!-- SenderReceiver.xsl -->

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
														<td colspan="6">
															<h3><xsl:value-of select="organization_unit/name" /></h3>
														</td>
													</tr>
													<tr>
														<th>@@title@@</th>
														<th>@@description@@</th>
														<th>@@author@@</th>
														<th>@@due_date@@</th>
														<th>@@fine@@</th>
														<th><xsl:value-of select="$mail_tab_text"/></th> <!-- added tab for library email address link -->
													</tr>

													<xsl:for-each select="item_loans/overdue_and_lost_loan_notification_display/item_loan">
														<tr>
															<td><xsl:value-of select="title"/></td>
															<td><xsl:value-of select="description"/></td>
															<td><xsl:value-of select="author"/></td>
															<td><xsl:value-of select="due_date"/></td>
															<td><xsl:value-of select="fine"/></td>
															
															<!-- 'lib_id' contains the unique id of the library, for each loan listed in the letter--> 
															
															<xsl:variable name="lib_id" select="library_id" />
															
															<!-- 'circ_email' contains the library's email address, its value is determined according to the value of 'lib_id' (from which library the loan was made). -->
															
															<xsl:variable name="circ_email">
																<xsl:choose>
																	<xsl:when test="$lib_id = '190896720004146'">
																		<xsl:text>mailto:al1_circ@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190893010004146'">
																		<xsl:text>mailto:ah1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190886640004146'">
																		<xsl:text>mailto:ac1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190902540004146'">
																		<xsl:text>mailto:as1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190899330004146'">
																		<xsl:text>mailto:am1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190893290004146'">
																		<xsl:text>mailto:sw1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190887990004146'">
																		<xsl:text>mailto:mus_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190887250004146'">
																		<xsl:text>mailto:arc_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190887530004146'">
																		<xsl:text>mailto:adr_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190905630004146'">
																		<xsl:text>mailto:art1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190899660004146'">
																		<xsl:text>mailto:cmd_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190906170004146'">
																		<xsl:text>mailto:sli1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190905810004146'">
																		<xsl:text>mailto:drc1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>																	
																	<xsl:when test="$lib_id = '190888270004146'">
																		<xsl:text>mailto:geo_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190906530004146'">
																		<xsl:text>mailto:hjp1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190886920004146'">
																		<xsl:text>mailto:illc_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190905990004146'">
																		<xsl:text>mailto:edu1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190905090004146'">
																		<xsl:text>mailto:asm1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190897000004146'">
																		<xsl:text>mailto:illl_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190887810004146'">
																		<xsl:text>mailto:meh_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>																	
																	<xsl:when test="$lib_id = '12900830000231'">
																		<xsl:text>mailto:rs1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>																	
																	<xsl:when test="$lib_id = '190893520004146'">
																		<xsl:text>mailto:illh_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>																	
																	<xsl:when test="$lib_id = '190905270004146'">
																		<xsl:text>mailto:day1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190905450004146'">
																		<xsl:text>mailto:wie1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>																	
																	<xsl:when test="$lib_id = '190906350004146'">
																		<xsl:text>mailto:zif1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>																	
																	<xsl:otherwise>
																		<xsl:text>mailto:no_email@tau.ac.il</xsl:text>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:variable>
															
															<!-- for each loan listed in the letter, a link to the library's email is added here.  -->
															
															<td><a href="{$circ_email}"><xsl:value-of select="$circ_mail_text"/></a></td>															
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
												<table cellpadding="5" class="listing">
													<xsl:attribute name="style">
														<xsl:call-template name="mainTableStyleCss" />
													</xsl:attribute>
													<tr align="center" bgcolor="#f5f5f5">
														<td colspan="5">
															<h3><xsl:value-of select="organization_unit/name" /></h3>
														</td>
													</tr>
													<tr>
														<th>@@title@@</th>
														<th>@@due_date@@</th>
														<th>@@fine@@</th>
														<th>@@description@@</th>
														<th><xsl:value-of select="$mail_tab_text"/></th> <!-- added tab for library email address link -->
													</tr>

													<xsl:for-each select="item_loans/overdue_and_lost_loan_notification_display/item_loan">
														<tr>
															<td><xsl:value-of select="title"/></td>
															<td><xsl:value-of select="due_date"/></td>
															<td><xsl:value-of select="fine"/></td>
															<td><xsl:value-of select="description"/></td>
															
															<!-- 'lib_id' contains the unique id of the library, for each loan listed in the letter--> 
															
															<xsl:variable name="lib_id" select="library_id" />
															
															<!-- 'circ_email' contains the library's email address, its value is determined according to the value of 'lib_id' (from which library the loan was made). -->
															
															<xsl:variable name="circ_email">
																<xsl:choose>
																	<xsl:when test="$lib_id = '190896720004146'">
																		<xsl:text>mailto:al1_circ@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190893010004146'">
																		<xsl:text>mailto:ah1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190886640004146'">
																		<xsl:text>mailto:ac1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190902540004146'">
																		<xsl:text>mailto:as1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190899330004146'">
																		<xsl:text>mailto:am1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190893290004146'">
																		<xsl:text>mailto:sw1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190887990004146'">
																		<xsl:text>mailto:mus_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190887250004146'">
																		<xsl:text>mailto:arc_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190887530004146'">
																		<xsl:text>mailto:adr_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190905630004146'">
																		<xsl:text>mailto:art1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190899660004146'">
																		<xsl:text>mailto:cmd_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190906170004146'">
																		<xsl:text>mailto:sli1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190905810004146'">
																		<xsl:text>mailto:drc1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>																	
																	<xsl:when test="$lib_id = '190888270004146'">
																		<xsl:text>mailto:geo_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190906530004146'">
																		<xsl:text>mailto:hjp1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190886920004146'">
																		<xsl:text>mailto:illc_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190905990004146'">
																		<xsl:text>mailto:edu1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190905090004146'">
																		<xsl:text>mailto:asm1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190897000004146'">
																		<xsl:text>mailto:illl_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190887810004146'">
																		<xsl:text>mailto:meh_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>																	
																	<xsl:when test="$lib_id = '12900830000231'">
																		<xsl:text>mailto:rs1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>																	
																	<xsl:when test="$lib_id = '190893520004146'">
																		<xsl:text>mailto:illh_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>																	
																	<xsl:when test="$lib_id = '190905270004146'">
																		<xsl:text>mailto:day1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>
																	<xsl:when test="$lib_id = '190905450004146'">
																		<xsl:text>mailto:wie1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>																	
																	<xsl:when test="$lib_id = '190906350004146'">
																		<xsl:text>mailto:zif1_circ_email@tau.ac.il</xsl:text>
																	</xsl:when>																	
																	<xsl:otherwise>
																		<xsl:text>mailto:no_email@tau.ac.il</xsl:text>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:variable>
															
															<!-- for each loan listed in the letter, a link to the library's email is added here.  -->
															
															<td><a href="{$circ_email}"><xsl:value-of select="$circ_mail_text"/></a></td>
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

								<xsl:for-each select="notification_data/organization_fee_list/string">
									<tr>
										<td><xsl:value-of select="."/></td>
									</tr>
								</xsl:for-each>

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
				<xsl:call-template name="myAccount" />
				<!-- <xsl:call-template name="contactUs" /> -->
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>

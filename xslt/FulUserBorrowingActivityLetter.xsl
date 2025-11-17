<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="header.xsl" />
  <xsl:include href="senderReceiver.xsl" />
  <xsl:include href="mailReason.xsl" />
  <xsl:include href="footer.xsl" />
  <xsl:include href="style.xsl" />
  <xsl:include href="recordTitle.xsl" />

  <!-- Emergency mode control variable: 'False' = normal letter, 'True' = emergency message -->
  <xsl:variable name="emergency" select="'False'" />

  <xsl:template match="/">
    <html>
      <head>
        <xsl:call-template name="generalStyle" />
      </head>
      <body>
        <xsl:attribute name="style">
          <xsl:call-template name="bodyStyleCss" /><!-- style.xsl -->
        </xsl:attribute>

        <xsl:choose>
          <!-- Emergency mode: display simple test message -->
          <xsl:when test="$emergency = 'True'">
            <xsl:call-template name="headFulUserBorrowingActivityLetter"><!-- header.xsl -->
              <xsl:with-param name="emergency" select="$emergency" />
            </xsl:call-template>
            <xsl:call-template name="senderReceiverRevised" />  <!-- SenderReceiver.xsl -->

            <br />
            <xsl:call-template name="toWhomIsConcerned" /> <!-- mailReason.xsl -->

            <div class="messageArea">
              <div class="messageBody">
                <table cellspacing="0" cellpadding="5" border="0">
                  <tr>
                    <td>
                      <xsl:choose>
                        <xsl:when test="/notification_data/receivers/receiver/user/user_preferred_language = 'he'">
                          <!-- Hebrew emergency message -->
                          <p>שלום,</p>
                          <br/>
                          <p>ימים לא פשוטים עוברים על כולנו.</p>
                          <p>עקב המצב, הספרייה סגורה למבקרים עד להודעה חדשה.</p>
                          <br/>
                          <p><b>לתשומת לבך:</b></p>
                          <ul>
                            <li>מועד ההחזרה של כלל הפריטים שבידיך יוארך באופן אוטומטי עד לחידוש פעילות הספרייה.</li>
                            <li>אם ברשותך ספר שהוזמן על ידי קוראים אחרים – נבקש להחזירו בהקדם האפשרי עם החזרה לשגרה.</li>
                            <li>עדכונים על חידוש הפעילות יתפרסמו באתרי הספריות וברשתות החברתיות.</li>
                          </ul>
                          <br/>
                          <p>לשאלות או בקשות, ניתן לפנות לספריות באמצעות דוא"ל או טלפון.</p>
                          <p>בתקווה לימים שקטים וטובים במהרה,</p>
                          <p><b>צוות מדורי השאלה בספריות אוניברסיטת תל אביב</b></p>
                        </xsl:when>
                        <xsl:otherwise>
                          <!-- English emergency message -->
                          <p>Hello,</p>
                          <br/>
                          <p>These are challenging times for all of us.</p>
                          <p>Due to the situation, the library is closed until further notice.</p>
                          <br/>
                          <ul>
                            <li>The return date for all borrowed items will be automatically extended until the library reopens.</li>
                            <li>We would appreciate it if you could return requested items as soon as possible once regular services resume.</li>
                            <li>Updates regarding the reopening of the library will be published on the libraries' websites and social media.</li>
                            <li>For any further questions or requests you are welcome to contact us by e-mail or phone.</li>
                          </ul>
                          <br/>
                          <p>Wishing for calmer and better days soon,</p>
                          <p><b>The Circulation Department</b></p>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                  </tr>
                </table>
              </div>
            </div>

            <!-- footer.xsl -->
            <xsl:call-template name="lastFooter" />
            <xsl:call-template name="donotreply" />
          </xsl:when>

          <!-- Normal mode: display regular letter content -->
          <xsl:otherwise>
            <xsl:call-template name="headFulUserBorrowingActivityLetter"><!-- header.xsl -->
              <xsl:with-param name="emergency" select="$emergency" />
            </xsl:call-template>
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
										<!-- <th><xsl:call-template name="barcode" /></th> --><!-- custom template in footer.xsl -->
										<!-- <th>@@fine@@</th> -->
										<th>@@due_date@@</th>

									</tr>

									<xsl:for-each select="item_loans/overdue_and_lost_loan_notification_display/item_loan">
										<tr>
											<td><xsl:value-of select="title"/>
												<xsl:if test="item_description != ''">
													<xsl:text>, </xsl:text><xsl:value-of select="item_description" />
												</xsl:if>
											</td>
											<!-- <td><xsl:value-of select="barcode"/></td> -->
											<!-- <td><xsl:value-of select="fine"/></td> -->
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
										<!-- <th><xsl:call-template name="barcode" /></th> --> <!-- custom template in footer.xsl -->
										<!-- <th>@@fine@@</th> -->
										<!-- <th>@@due_date@@</th> -->
									</tr>

									<xsl:for-each select="item_loans/overdue_and_lost_loan_notification_display/item_loan">
										<tr>
											<td><xsl:value-of select="title"/>
												<xsl:if test="item_description != ''">
													<xsl:text>, </xsl:text><xsl:value-of select="item_description" />
												</xsl:if>
											</td>
											<!-- <td><xsl:value-of select="barcode"/></td> -->
											<!-- <td><xsl:value-of select="fine"/></td> -->
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
			  <tr>
				<xsl:if test="notification_data/organization_fee_list/string">
					<xsl:call-template name="feesTable" />
				</xsl:if>
			  </tr>
            </table>

			<br />
			<h3>
			<xsl:call-template name="additional_text">
				<xsl:with-param name="label" select="'text_03'" />
				<xsl:with-param name="letter_language" select="/notification_data/receivers/receiver/preferred_language" />
			</xsl:call-template>
			<a href="https://tau-primo.hosted.exlibrisgroup.com/primo-explore/account?vid=TAU&amp;section=overview&amp;lang=en_US">
				<xsl:call-template name="additional_text">
					<xsl:with-param name="label" select="'text_04'" />
					<xsl:with-param name="letter_language" select="/notification_data/receivers/receiver/preferred_language" />
				</xsl:call-template>
			</a>
			</h3>

			
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
          </xsl:otherwise>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
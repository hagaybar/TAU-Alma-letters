<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template name="head">
	<!-- get letter type -->
		<xsl:param name="letter_type" select = "/notification_data/general_data/letter_type" />
		<!-- get library name -->
		<xsl:param name="lib_name">
			<xsl:choose>
				<xsl:when test="/notification_data/library/name!=''">
					<xsl:value-of select = "/notification_data/library/name" />
				</xsl:when>
				<xsl:when test="/notification_data/item/library_name!=''">
					<xsl:value-of select="/notification_data/item/library_name" />
				</xsl:when>	
				<xsl:when test="/notification_data/items/physical_item_display_for_printing/library_name!=''">
					<xsl:value-of select = "/notification_data/items/physical_item_display_for_printing/library_name" />
				</xsl:when>
				<xsl:when test="/notification_data/phys_item_display/owning_library_name!=''">
					<xsl:value-of select = "/notification_data/phys_item_display/owning_library_name" />
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<table cellspacing="0" cellpadding="5" border="0">
			<xsl:attribute name="style">
				<xsl:call-template name="headerTableStyleCss" /><!-- style.xsl -->
			</xsl:attribute>
			<!-- LOGO INSERT -->
			<tr>
				<xsl:attribute name="style">
					<xsl:call-template name="headerLogoStyleCss" />
					<!-- style.xsl -->
				</xsl:attribute>
				<td colspan="2">
					<div id="mailHeader">
						<div id="logoContainer" class="alignLeft">
						<table>
							<tr>
								<td>
									<img src="cid:logo.jpg" alt="logo" style="float: left; margin-right:10px;"/>
								</td>
								<td>
									<!-- insert library name beside the logo for letters in list (RS letters) -->
									<xsl:choose>
										<xsl:when test="contains('|GeneralMessageEmailLetter|BorrowerOverdueEmailLetter|LenderRejectEmailLetter|LenderRenewResponseEmailLetter|LendingRecallEmailLetter|LendingReqReportSlipLetter|LenderWillSupplyEmailLetter|FulBorrowingInfoLetter|LenderShipEmailLetter|FulIncomingSlipLetter|FulRenewEmailLetter|FulLostEmailLetter|QueryToPatronLetter|ResourceSharingReceiveSlipLetter|ResourceSharingReturnSlipLetter|ResourceSharingShippingSlipLetter|FulOutgoingEmailLetter|',concat('|', $letter_type, '|'))">
											<h1 style="position: relative; margin-left:10px;"><xsl:value-of select="$lib_name" /></h1>
										</xsl:when>
										<xsl:otherwise>
											<!-- do not add library name (next line used in tests):
											<xsl:text>not included in selected letters</xsl:text>
											-->
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>						
						</table>

						</div>
					</div>
				</td>
			</tr>
			<!-- END OF LOGO INSERT -->
			<tr>
				<xsl:for-each select="notification_data/general_data">
					<td>
						<h1>
							<xsl:value-of select="letter_name"/>
						</h1>
					</td>
					<td align="right">
						<xsl:value-of select="current_date"/>
					</td>
				</xsl:for-each>
			</tr>
		</table>
	</xsl:template>

	
	<xsl:template name="headFulItemChangeDateLetter">
		<table cellspacing="0" cellpadding="5" border="0">
			<xsl:attribute name="style">
				<xsl:call-template name="headerTableStyleCss" />
				<!-- style.xsl -->
			</xsl:attribute>
			<!-- LOGO INSERT -->
			<tr>
				<xsl:attribute name="style">
					<xsl:call-template name="headerLogoStyleCss" />
					<!-- style.xsl -->
				</xsl:attribute>
				<td colspan="2">
					<div id="mailHeader">
						<div id="logoContainer" class="alignLeft">
							<img src="cid:logo.jpg" alt="logo"/>
						</div>
					</div>
				</td>
			</tr>
			<!-- END OF LOGO INSERT -->
			<tr>
				<xsl:variable name="letterSubject">
					<xsl:choose>
						<xsl:when test="/notification_data/message='RECALL_ONLY' or /notification_data/message='RECALL_DUEDATE_CHANGE'">
							<xsl:if test="/notification_data/receivers/receiver/preferred_language = 'he'">
								<xsl:text>הפריט שברשותך מוזמן</xsl:text>
							</xsl:if>
							<xsl:if test="/notification_data/receivers/receiver/preferred_language != 'he'">
								<xsl:text>An item you borrowed is recalled</xsl:text>
							</xsl:if>
						</xsl:when>
						<xsl:when test="/notification_data/message='RECALL_CANCEL_NO_CHANGE' or /notification_data/message='RECALL_CANCEL_ITEM_RENEWED' or /notification_data/message='RECALL_CANCEL_RESTORE_ORIGINAL_DUEDATE'">
							<xsl:if test="/notification_data/receivers/receiver/preferred_language = 'he'">
								<xsl:text>הפריט שברשותך אינו מוזמן יותר</xsl:text>
							</xsl:if>
							<xsl:if test="/notification_data/receivers/receiver/preferred_language != 'he'">
								<xsl:text>The recall that has been placed on your borrowed item has been canceled</xsl:text>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="/notification_data/receivers/receiver/preferred_language = 'he'">
								<xsl:text>הודעה על פריט/ים מושאל/ים שברשותך</xsl:text>
							</xsl:if>
							<xsl:if test="/notification_data/receivers/receiver/preferred_language != 'he'">
								<xsl:text>Notice regarding item(s) you borrowed</xsl:text>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:for-each select="notification_data/general_data">
					<td>
						<h1>
							<xsl:value-of select="$letterSubject"/>
						</h1>
					</td>
					<td align="right">
						<xsl:value-of select="current_date"/>
					</td>
				 </xsl:for-each>

			</tr>
		</table>
	</xsl:template>
	
	<xsl:template name="headFulPlaceOnHoldShelfLetterRS">
	
		<table cellspacing="0" cellpadding="5" border="0">
			<xsl:attribute name="style">
				<xsl:call-template name="headerTableStyleCss" />
				<!-- style.xsl -->
			</xsl:attribute>
			<!-- LOGO INSERT -->
			<tr>
				<xsl:attribute name="style">
					<xsl:call-template name="headerLogoStyleCss" />
					<!-- style.xsl -->
				</xsl:attribute>
				<td colspan="2">
					<div id="mailHeader">
						<div id="logoContainer" class="alignLeft">
							<img src="cid:logo.jpg" alt="logo"/>
						</div>
					</div>
				</td>
			</tr>
			<!-- END OF LOGO INSERT -->
			
			<xsl:variable name="letterSubject">
				<xsl:choose> <!-- language -->
					<xsl:when test = "/notification_data/receivers/receiver/user/user_preferred_language = 'he'">	
						<xsl:text>פריט שהוזמן באמצעות השאלה בין-ספרייתית ממתין עבורך</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>The item you requested via interlibrary loan is now available for you at the library</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			
			</xsl:variable>
			
			<tr>
				<xsl:for-each select="notification_data/general_data">
					<td>
						<h1>
							<xsl:value-of select="$letterSubject"/>
						</h1>
					</td>
					<td align="right">
						<xsl:value-of select="current_date"/>
					</td>
				</xsl:for-each>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>
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
					<xsl:call-template name="bodyStyleCss" />
					<!-- style.xsl -->
				</xsl:attribute>
				<xsl:call-template name="head" />
				<!-- header.xsl -->

				<table cellspacing="0" cellpadding="5" border="0">
					<xsl:choose>
						<xsl:when test="notification_data/query_type = 'Type_1_query_name'">
							<tr>
								<td>
									<h3>@@Type_1_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_2_query_name'">
							<tr>
								<td>
									<h3>@@Type_2_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_3_query_name'">
							<tr>
								<td>
									<h3>@@Type_3_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_4_query_name'">
							<tr>
								<td>
									<h3>@@Type_4_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_5_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_6_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_7_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_8_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_9_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_10_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_11_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_12_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_13_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_14_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_15_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_16_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_17_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_18_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_19_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_20_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_21_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_22_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_23_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="notification_data/query_type = 'Type_24_query_name'">
							<tr>
								<td>
									<h3>@@Type_5_header@@</h3>
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<tr>
								<td>
									<h3>@@Type_1_header@@</h3>
								</td>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
				</table>

				<div class="messageArea">
					<div class="messageBody">
						<table cellspacing="0" cellpadding="5" border="0">

							<tr>
								<td>
									@@requested@@:

								</td>

							</tr>
						</table>
						<br />
						<table cellspacing="0" cellpadding="5" border="0">

							<xsl:attribute name="style">
								<xsl:call-template name="listStyleCss" />
								<!-- style.xsl -->
							</xsl:attribute>

							<xsl:if test="notification_data/request/display/material_type !=''">
								<tr>
									<td>
										<b> @@format@@:  </b>
										<xsl:value-of
											select="notification_data/request/display/material_type" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/title !=''">
								<tr>
									<td>
										<b> @@title@@: </b>
										<xsl:value-of select="notification_data/request/display/title" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/journal_title !=''">
								<tr>
									<td>
										<b> @@journal_title@@: </b>
										<xsl:value-of
											select="notification_data/request/display/journal_title" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/author !=''">
								<tr>
									<td>
										<b> @@author@@: </b>
										<xsl:value-of select="notification_data/request/display/author" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/autho_initials !=''">
								<tr>
									<td>
										<b> @@author_initials@@: </b>
										<xsl:value-of
											select="notification_data/request/display/autho_initials" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/publisher !=''">
								<tr>
									<td>
										<b> @@publisher@@: </b>
										<xsl:value-of select="notification_data/request/display/publisher" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if
								test="notification_data/request/display/place_of_publication !=''">
								<tr>
									<td>
										<b> @@place_of_publication@@: </b>
										<xsl:value-of
											select="notification_data/request/display/place_of_publication" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/publication_date !=''">
								<tr>
									<td>
										<b> @@publication_date@@: </b>
										<xsl:value-of
											select="notification_data/request/display/publication_date" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/year !=''">
								<tr>
									<td>
										<b> @@year@@: </b>
										<xsl:value-of select="notification_data/request/display/year" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/edition !=''">
								<tr>
									<td>
										<b> @@edition@@: </b>
										<xsl:value-of select="notification_data/request/display/edition" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/call_number !=''">
								<tr>
									<td>
										<b> @@call_number@@: </b>
										<xsl:value-of select="notification_data/request/display/call_number" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/volume !=''">
								<tr>
									<td>
										<b> @@volume@@: </b>
										<xsl:value-of select="notification_data/request/display/volume" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/issue !=''">
								<tr>
									<td>
										<b> @@issue@@: </b>
										<xsl:value-of select="notification_data/request/display/issue" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if
								test="notification_data/request/display/additional_person_name !=''">
								<tr>
									<td>
										<b> @@additional_person_name@@: </b>
										<xsl:value-of
											select="notification_data/request/display/additional_person_name" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/source !=''">
								<tr>
									<td>
										<b> @@source@@: </b>
										<xsl:value-of select="notification_data/request/display/source" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if
								test="notification_data/request/display/series_title_number !=''">
								<tr>
									<td>
										<b> @@series_title_number@@: </b>
										<xsl:value-of
											select="notification_data/request/display/series_title_number" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/isbn !=''">
								<tr>
									<td>
										<b> @@isbn@@: </b>
										<xsl:value-of select="notification_data/request/display/isbn" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/issn !=''">
								<tr>
									<td>
										<b> @@issn@@: </b>
										<xsl:value-of select="notification_data/request/display/issn" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/doi !=''">
								<tr>
									<td>
										<b> @@doi@@: </b>
										<xsl:value-of select="notification_data/request/display/doi" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/pmid !=''">
								<tr>
									<td>
										<b> @@pmid@@: </b>
										<xsl:value-of select="notification_data/request/display/pmid" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/note !=''">
								<tr>
									<td>
										<b> @@note@@: </b>
										<xsl:value-of select="notification_data/request/display/note" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/chapter !=''">
								<tr>
									<td>
										<b> @@chapter@@: </b>
										<xsl:value-of select="notification_data/request/display/chapter" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/volume_bk !=''">
								<tr>
									<td>
										<b> @@volume@@: </b>
										<xsl:value-of select="notification_data/request/display/volume_bk" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/part !=''">
								<tr>
									<td>
										<b> @@part@@: </b>
										<xsl:value-of select="notification_data/request/display/part" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/pages !=''">
								<tr>
									<td>
										<b> @@pages@@: </b>
										<xsl:value-of select="notification_data/request/display/pages" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/start_page !=''">
								<tr>
									<td>
										<b> @@start_page@@: </b>
										<xsl:value-of select="notification_data/request/display/start_page" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/display/end_page !=''">
								<tr>
									<td>
										<b> @@end_page@@: </b>
										<xsl:value-of select="notification_data/request/display/end_page" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/note !=''">
								<tr>
									<td>
										<b> @@request_note@@: </b>
										<xsl:value-of select="notification_data/request/note" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/general_data/current_date !=''">
								<tr>
									<td>
										<b> @@date@@: </b>
										<xsl:value-of select="notification_data/general_data/current_date" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/external_request_id !=''">
								<tr>
									<td>
										<b> @@request_id@@: </b>
										<xsl:value-of select="notification_data/request/external_request_id" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/format_display !=''">
								<tr>
									<td>
										<b> @@request_format@@: </b>
										<xsl:value-of select="notification_data/request/format_display" />
										<!-- recordTitle.xsl -->
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/max_fee !=''">
								<tr>
									<td>
										<b>@@maximum_fee@@: </b>
										<xsl:value-of select="notification_data/request/max_fee" />
									</td>

								</tr>
							</xsl:if>
						</table>
						<br />

						<table>

							<!--
							<tr>
								<td>@@query_to_patron@@: </td>
							</tr>-->
							<xsl:choose>
								<xsl:when test="notification_data/query_type = 'Type_1_query_name'">
									<!-- 
									<tr>
										<td>@@Type_1_query_line_1@@</td>
									</tr>
									<tr>
										<td>@@Type_1_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_1_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_2_query_name'">
									<tr>
										<td>@@Type_2_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_2_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_2_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_3_query_name'">
									<tr>
										<td>@@Type_3_query_line_1@@</td>
									</tr>
									<tr>
										<td>@@Type_3_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_3_query_line_3@@</td>
									</tr>
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_4_query_name'">
									<tr>
										<td>@@Type_4_query_line_1@@</td>
									</tr>
									<!-- 
									<tr>
										<td>@@Type_4_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_4_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_5_query_name'">
									<tr>
										<td>@@Type_5_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_5_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_5_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_6_query_name'">
									<tr>
										<td>@@Type_6_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_6_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_6_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_7_query_name'">
									<tr>
										<td>@@Type_7_query_line_1@@</td>
									</tr>
									<tr>
										<td>@@Type_7_query_line_2@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_7_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_8_query_name'">
									<tr>
										<td>@@Type_8_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_8_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_8_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_9_query_name'">
									<tr>
										<td>@@Type_9_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_9_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_9_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_10_query_name'">
									<tr>
										<td>@@Type_10_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_10_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_10_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_11_query_name'">
									<tr>
										<td>@@Type_11_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_11_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_11_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_12_query_name'">
									<tr>
										<td>@@Type_12_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_12_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_12_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_13_query_name'">
									<tr>
										<td>@@Type_13_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_13_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_13_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_14_query_name'">
									<tr>
										<td>@@Type_14_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_14_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_14_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_15_query_name'">
									<tr>
										<td>@@Type_15_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_15_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_15_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_16_query_name'">
									<tr>
										<td>@@Type_16_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_16_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_16_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_17_query_name'">
									<tr>
										<td>@@Type_17_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_17_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_17_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_18_query_name'">
									<tr>
										<td>@@Type_18_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_18_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_18_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_19_query_name'">
									<tr>
										<td>@@Type_19_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_19_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_19_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_20_query_name'">
									<tr>
										<td>@@Type_20_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_20_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_20_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_21_query_name'">
									<tr>
										<td>@@Type_21_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_21_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_21_query_line_3@@</td>
									</tr> -->
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_22_query_name'">
									<tr>
										<td>@@Type_22_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_22_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_22_query_line_3@@</td>
									</tr> -->	
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_23_query_name'">
									<tr>
										<td>@@Type_23_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_23_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_23_query_line_3@@</td>
									</tr> -->	
								</xsl:when>
								<xsl:when test="notification_data/query_type = 'Type_24_query_name'">
									<tr>
										<td>@@Type_24_query_line_1@@</td>
									</tr>
									<!--
									<tr>
										<td>@@Type_24_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_24_query_line_3@@</td>
									</tr> -->	
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td>@@Type_1_query_line_1@@</td>
									</tr>
									<tr>
										<td>@@Type_1_query_line_2@@</td>
									</tr>
									<tr>
										<td>@@Type_1_query_line_3@@</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>

						</table>
						<br />
						<table>
							<xsl:if test="notification_data/query_note !=''">
								<tr>
									<td>
									<!--<b> @@query_note@@: </b>-->
										<xsl:value-of select="notification_data/query_note" />
									</td>
								</tr>
							</xsl:if>

						</table>
						<br />
						<table>

							<tr>
								<td>@@Type_1_Sincerely@@</td>
							</tr>
							<!-- rs_dept_details details here from footer.xsl-->
							<xsl:call-template name="rs_dept_details">
								 <xsl:with-param name="lib_id" select="/notification_data/library/org_scope/library_id" />
								 <xsl:with-param name="letter_language" select="/notification_data/receivers/receiver/user/user_preferred_language" />
								 <xsl:with-param name="lib_name" select="/notification_data/library/name" /> 
							</xsl:call-template>

							<!-- all address lines are commented out
							<xsl:if test="notification_data/library/name !=''">
								<tr>
									<td>
										<xsl:value-of select="notification_data/library/name" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/library/address/line1 !=''">
								<tr>
									<td>
										<xsl:value-of select="notification_data/library/address/line1" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/library/address/line2 !=''">
								<tr>
									<td>
										<xsl:value-of select="notification_data/library/address/line2" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/library/address/line3 !=''">
								<tr>
									<td>
										<xsl:value-of select="notification_data/library/address/line3" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/library/address/line4 !=''">
								<tr>
									<td>
										<xsl:value-of select="notification_data/library/address/line4" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/library/address/line5 !=''">
								<tr>
									<td>
										<xsl:value-of select="notification_data/library/address/line5" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/library/address/city !=''">
								<tr>
									<td>
										<xsl:value-of select="notification_data/library/address/city" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/library/address/country !=''">
								<tr>
									<td>
										<xsl:value-of select="notification_data/library/address/country" />
									</td>
								</tr>

							</xsl:if>
							<xsl:if test="notification_data/signature_email !=''">
								<tr>
									<td>
										<xsl:value-of select="notification_data/signature_email" />
									</td>
								</tr>

							</xsl:if>
							-->
						</table>
					</div>
				</div>
				<xsl:call-template name="lastFooter" />
				<xsl:call-template name="donotreply">
					<xsl:with-param name="lib_id" select="/notification_data/library/org_scope/library_id" />
					<xsl:with-param name="letter_language" select="/notification_data/receivers/receiver/user/user_preferred_language" />
				</xsl:call-template>
				<!-- footer.xsl -->
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
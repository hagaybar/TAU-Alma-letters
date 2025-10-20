# TAU Alma Letters: Comprehensive Improvement Proposal

**Date**: October 19, 2025
**Status**: Proposed
**Priority Classification**: Critical, High, Medium, Long-term

## Executive Summary

Based on comprehensive codebase analysis, the TAU Alma Letters repository contains **29 XSLT 1.0 stylesheets** with significant technical debt, code duplication, and maintainability concerns. With **Alma's November 2022 upgrade to XSLT 3.0 support**, there is now an opportunity to modernize the codebase while addressing critical issues.

**Key Findings:**
- 844 instances of duplicated language-switching logic
- 40+ hard-coded library IDs, URLs, and contact information
- 200+ lines of commented-out code
- Multiple competing implementations of the same functionality
- XSLT 1.0 limitations requiring complex workarounds

This proposal outlines **11 prioritized improvements** that will increase robustness, maintainability, and clarity.

---

## Table of Contents

1. [Critical Findings](#critical-findings)
2. [XSLT 3.0 Upgrade Opportunity](#xslt-30-upgrade-opportunity)
3. [Prioritized Improvements](#prioritized-improvements)
4. [Implementation Roadmap](#implementation-roadmap)
5. [Risk Assessment](#risk-assessment)
6. [Success Metrics](#success-metrics)

---

## Critical Findings

### 1. Code Duplication (CRITICAL)

**Issue**: Massive duplication across 29 files
- 844 xsl:if/xsl:when constructs for language switching
- 200+ `!= ''` existence checks
- Pattern: `xsl:if test="/notification_data/receivers/receiver/user/user_preferred_language = 'he'"`

**Examples:**
- `footer.xsl` lines 157-227: 6 identical additional_text label blocks (Hebrew/English pairs)
- `FulUserBorrowingActivityLetter.xsl` lines 25-273: 90% code duplication between emergency/normal modes
- `QueryToPatronLetter.xsl` lines 24-207: 25 nearly identical query type handlers

**Impact**:
- Maintenance burden (changes require updates in multiple locations)
- Increased risk of inconsistencies
- Difficult to test

### 2. Hard-Coded Configuration (CRITICAL)

**Issue**: Library IDs, contact info, and URLs embedded in code

**Locations:**
- `footer.xsl` lines 493-642: 5 library ID mappings + 15 contact detail blocks
- `FulPlaceOnHoldShelfLetter.xsl` lines 86, 104: Wiener Library ID (`190905450004146`)
- `FulUserBorrowingActivityLetter.xsl` line 222: Hard-coded Primo URL
- `QueryToPatronLetter.xsl` line 567: Hard-coded ILL URL

**Library ID Examples:**
```xml
<!-- footer.xsl line 493 -->
<xsl:if test="($lib_id = '190893010004146') or (contains($lib_id, 'AH1'))">
  <!-- Social Sciences Library -->
</xsl:if>
```

**Impact**:
- Cannot update library info without code changes
- Difficult to test with different library configurations
- No single source of truth

### 3. Competing Implementations (HIGH)

**Issue**: Old and new implementations coexist, creating confusion

**Example 1: footer.xsl**
- **Old**: `additional_text` template (lines 146-232) - hard-coded strings
- **New**: `additional_text_lookup` template (lines 31-56) - dynamic lookup from XML store
- **Problem**: Both exist; unclear which to use

**Example 2: senderReciever.xsl**
- `senderReceiver` (line 10) - Full address details
- `senderReceiverRevised` (line 79) - TAU standard (minimal)
- `senderReceiverExtended` (line 134) - **Marked for deletion since 2024, never removed**
- `senderReceiverMinimal` (line 199) - Name only

**Impact**:
- New developers don't know which template to use
- Risk of using deprecated patterns
- Increases testing complexity

### 4. Complex Conditional Logic (HIGH)

**Issue**: Deep nesting and excessive branching

**QueryToPatronLetter.xsl** (946 lines):
- 25 xsl:when blocks for query types (lines 24-207)
- **BUG**: Lines 63, 70, 77+ all reference `@@Type_5_header@@` instead of their own type
- 40+ xsl:if conditions for field rendering (lines 230-527)

**footer.xsl** (711 lines):
- `rs_details_display` template: Nested xsl:choose within xsl:choose (lines 287-378)
- 48 xsl:choose blocks for library/language combinations

**Impact**:
- Difficult to understand control flow
- High risk of copy-paste errors (already present)
- Cannot easily add new query types or libraries

### 5. Commented-Out Code (MEDIUM)

**Locations:**
- `BorrowerOverdueEmailLetter.xsl` lines 97-153 (57 lines)
- `QueryToPatronLetter.xsl` lines 868-934 (66 lines)
- `ResourceSharingReceiveSlipLetter.xsl` lines 126-182 (57 lines)
- Multiple smaller blocks across 6+ files

**Impact**:
- Clutters code, reduces readability
- Creates confusion about what's active
- Makes version control diffs harder to read

### 6. Missing Error Handling (MEDIUM)

**Issues:**
- No xsl:otherwise blocks with meaningful error messages
- `footer.xsl` line 53: Silences errors with `terminate="no"`
- `rs_details_display` line 281: Returns only "no library found" without diagnostic info
- No graceful degradation when attributes missing

**Impact**:
- Silent failures in production
- Difficult debugging
- Poor user experience when data is malformed

---

## XSLT 3.0 Upgrade Opportunity

### Alma Platform Support (November 2022)

According to Ex Libris documentation and developer network discussions:

✅ **Confirmed**: Alma Letter Configuration upgraded to version 3
✅ **Processor**: Saxon HE 9.9.1-6 (XSLT 3.0 capable)
✅ **Compatibility**: Existing XSLT 1.0 letters continue to work without changes
✅ **Features Available**: Most XSLT 3.0 features work (see limitations below)

❌ **Known Limitations**:
- Higher-order functions may not work
- Some array operations (e.g., `array:filter`) reported as non-functional

### XSLT 3.0 Key Benefits for This Codebase

#### 1. Native Boolean Types
**Current (XSLT 1.0):**
```xml
<xsl:variable name="emergency" select="'False'" />
<xsl:when test="$emergency = 'True'">
```

**With XSLT 3.0:**
```xml
<xsl:variable name="emergency" as="xs:boolean" select="false()" />
<xsl:when test="$emergency">
```

**Impact**: Eliminates string-based boolean workarounds across 15+ files

#### 2. Sequence Operations
**Current (XSLT 1.0):**
```xml
<!-- footer.xsl line 288 -->
<xsl:when test="contains('|he|en|', concat('|', $language, '|'))">
```

**With XSLT 3.0:**
```xml
<xsl:when test="$language = ('he', 'en')">
```

**Impact**: Eliminates pipe-delimited string matching workarounds

#### 3. Regular Expressions
**Current (XSLT 1.0):**
```xml
<!-- footer.xsl line 602 - substring matching only -->
<xsl:when test="contains($lib_id_or_name, 'השאלה בינספרייתית')">
```

**With XSLT 3.0:**
```xml
<xsl:when test="matches($lib_id_or_name, 'השאלה בינספרייתית|Interlibrary Loan')">
```

**Impact**: More flexible string matching, reduces code duplication

#### 4. Maps and Arrays
**Current (XSLT 1.0):**
```xml
<!-- footer.xsl lines 5-27: XML-based static content store -->
<xsl:variable name="additional_texts">
  <texts>
    <text label="text_01" lang="he">...</text>
  </texts>
</xsl:variable>
```

**With XSLT 3.0:**
```xml
<xsl:variable name="additional_texts" as="map(xs:string, map(xs:string, xs:string))">
  <xsl:map>
    <xsl:map-entry key="'text_01'">
      <xsl:map>
        <xsl:map-entry key="'he'" select="'בדלפק ההשאלה'"/>
        <xsl:map-entry key="'en'" select="'from the circulation desk'"/>
      </xsl:map>
    </xsl:map-entry>
  </xsl:map>
</xsl:variable>
```

**Impact**: Type-safe data structures, easier to query

#### 5. Let Expressions
**Current (XSLT 1.0):**
```xml
<!-- footer.xsl lines 37-42: Multiple xsl:variable for cascading lookup -->
<xsl:variable name="matchLib" select="..."/>
<xsl:variable name="matchGeneric" select="..."/>
<xsl:choose>
  <xsl:when test="$matchLib">...</xsl:when>
  <xsl:when test="$matchGeneric">...</xsl:when>
</xsl:choose>
```

**With XSLT 3.0:**
```xml
<xsl:value-of select="
  let $matchLib := $additional_texts/text[@label=$label][@lang=$lang][@lib=$lib_id],
      $matchGeneric := $additional_texts/text[@label=$label][@lang=$lang][not(@lib)]
  return if ($matchLib) then $matchLib else $matchGeneric
"/>
```

**Impact**: More concise, easier to understand data flow

### Backwards Compatibility

✅ **XSLT 3.0 is fully backwards compatible with XSLT 1.0**
- Can upgrade gradually (file by file)
- No breaking changes to existing templates
- Simply change version declaration: `<xsl:stylesheet version="3.0">`

**Recommendation**: Start with low-risk files (style.xsl, mailReason.xsl) to validate Alma's XSLT 3.0 support

---

## Prioritized Improvements

### PRIORITY 1: CRITICAL (Quick Wins - 1-2 weeks)

#### 1.1 Consolidate Duplicate `additional_text` Implementations

**Files Affected**: footer.xsl
**Effort**: Low
**Impact**: High

**Problem**:
- Two competing implementations coexist (old: lines 146-232, new: lines 31-56)
- `additional_text` template has hard-coded strings
- `additional_text_lookup` uses dynamic XML store
- No clear guidance on which to use

**Solution**:
1. Audit all letter files for calls to `additional_text` template
2. Migrate all calls to use `additional_text_lookup` with static content store
3. Delete old `additional_text` template (lines 146-232)
4. Update CLAUDE.md to document `additional_text_lookup` as the **only** pattern

**Benefits**:
- Single source of truth for bilingual text
- Easier to add new text labels
- Reduces footer.xsl by 87 lines

#### 1.2 Delete Unused `senderReceiverExtended` Template

**Files Affected**: senderReciever.xsl (lines 132-195)
**Effort**: Low
**Impact**: Medium

**Problem**:
- Template marked for deletion with comment: "needs to be deleted after verifying that it is not used in any letter" (line 132)
- Has existed for 11+ months without deletion
- Creates confusion about which template to use

**Solution**:
1. Search all .xsl files for `<xsl:call-template name="senderReceiverExtended">`
2. If no uses found, delete lines 132-195
3. If uses found, migrate to `senderReceiverRevised` (TAU standard)
4. Update CLAUDE.md with clear guidance:
   - **Use**: `senderReceiverRevised` (TAU standard for all new letters)
   - **Avoid**: `senderReceiver` (OTB template)
   - **Deprecated**: `senderReceiverExtended` (deleted)

**Benefits**:
- Reduces confusion
- Removes 64 lines of dead code
- Clear template hierarchy

#### 1.3 Remove Commented-Out Code

**Files Affected**: 6+ files (200+ lines total)
**Effort**: Low
**Impact**: Medium

**Locations to Clean**:
- `BorrowerOverdueEmailLetter.xsl` lines 97-153 (57 lines)
- `QueryToPatronLetter.xsl` lines 868-934 (66 lines)
- `ResourceSharingReceiveSlipLetter.xsl` lines 126-182 (57 lines)
- `FulPlaceOnHoldShelfLetter.xsl` lines 61-72, 117-120
- `footer.xsl` lines 128-144 (documentation - move to CLAUDE.md)

**Solution**:
1. Review each commented block for historical value
2. If needed, document intent in commit message before deletion
3. Delete all commented code (version control preserves history)
4. Move documentation comments from footer.xsl to CLAUDE.md

**Benefits**:
- Improves readability
- Reduces file sizes by 200+ lines
- Cleaner git diffs

---

### PRIORITY 2: HIGH (Moderate Effort - 2-4 weeks)

#### 2.1 Externalize Library Configuration

**Files Affected**: footer.xsl, FulPlaceOnHoldShelfLetter.xsl, 8+ other letters
**Effort**: Medium
**Impact**: High

**Problem**:
- 5+ library IDs hard-coded (lines 493-517)
- 15 library contact blocks hard-coded (lines 599-637)
- Phone numbers and emails scattered throughout
- No single source of truth

**Current State** (footer.xsl):
```xml
<xsl:if test="($lib_id = '190893010004146') or (contains($lib_id, 'AH1'))">
  <xsl:text>03-6409085 | SMLCirc@tauex.tau.ac.il</xsl:text>
</xsl:if>
```

**Proposed Solution**: Create `library-config.xsl`

```xml
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- TAU Library Configuration -->
  <xsl:variable name="libraries">
    <library>
      <id>190893010004146</id>
      <code>AH1</code>
      <name lang="he">הספרייה למדעי החברה, לניהול ולחינוך</name>
      <name lang="en">Social Sciences, Management and Education Library</name>
      <contact>
        <phone>03-6409085</phone>
        <email>SMLCirc@tauex.tau.ac.il</email>
      </contact>
      <rs>
        <department lang="he">שירותי השאלה בינספרייתית ואספקת פרסומים</department>
        <department lang="en">Interlibrary Loan and Document Delivery Services</department>
        <phone lang="he">טלפון: 03-6407066 ; 03-6405501 | פקס: 03-6407840</phone>
        <phone lang="en">Phone: 03-6407066 ; 03-6405501 | Fax: 03-6407840</phone>
        <email>SMLILL@tauex.tau.ac.il</email>
      </rs>
    </library>

    <library>
      <id>190896720004146</id>
      <code>AL1</code>
      <name lang="he">הספרייה למשפטים ע"ש דוד י. לייט</name>
      <name lang="en">The David J. Light Law Library</name>
      <!-- ... -->
    </library>

    <!-- Add remaining 4 libraries -->
  </xsl:variable>

  <!-- Lookup template -->
  <xsl:template name="get_library_by_id">
    <xsl:param name="lib_id"/>
    <xsl:copy-of select="$libraries/library[id = $lib_id or contains($lib_id, code)]"/>
  </xsl:template>

</xsl:stylesheet>
```

**Usage Example**:
```xml
<!-- footer.xsl refactored -->
<xsl:include href="library-config.xsl" />

<xsl:template name="rs_details">
  <xsl:variable name="lib" select="get_library_by_id($lib_id)"/>
  <xsl:value-of select="$lib/rs/phone[@lang = $language]"/>
  <xsl:text> | </xsl:text>
  <xsl:value-of select="$lib/rs/email"/>
</xsl:template>
```

**Implementation Steps**:
1. Create `library-config.xsl` with all 6 TAU libraries
2. Include in `footer.xsl`: `<xsl:include href="library-config.xsl" />`
3. Refactor `rs_details_display` template (lines 245-465) to use lookup
4. Refactor `get_lib_contact_details` template (lines 594-644) to use lookup
5. Update all hard-coded library ID checks in letter files
6. Add unit tests (if testing framework available)

**Benefits**:
- **Single source of truth** for library data
- Library staff can update contact info without touching XSLT logic
- Enables testing with mock library configurations
- Reduces footer.xsl complexity by ~200 lines

#### 2.2 Standardize Language Detection

**Files Affected**: 15+ letter files
**Effort**: Medium
**Impact**: High

**Problem**:
- Inconsistent XPath expressions for language detection
- Some use: `/notification_data/receivers/receiver/user/user_preferred_language`
- Others use: `/notification_data/receivers/receiver/preferred_language`
- 50+ duplicate if statements for language checking

**Solution**: Create `language-util.xsl`

```xml
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Get user's preferred language with fallback -->
  <xsl:template name="get_user_language">
    <xsl:choose>
      <xsl:when test="/notification_data/receivers/receiver/user/user_preferred_language != ''">
        <xsl:value-of select="/notification_data/receivers/receiver/user/user_preferred_language"/>
      </xsl:when>
      <xsl:when test="/notification_data/receivers/receiver/preferred_language != ''">
        <xsl:value-of select="/notification_data/receivers/receiver/preferred_language"/>
      </xsl:when>
      <xsl:when test="/notification_data/languages/string != ''">
        <xsl:value-of select="/notification_data/languages/string"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>en</xsl:text> <!-- Default to English -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Check if user prefers Hebrew -->
  <xsl:template name="is_hebrew">
    <xsl:variable name="lang">
      <xsl:call-template name="get_user_language"/>
    </xsl:variable>
    <xsl:value-of select="$lang = 'he'"/>
  </xsl:template>

  <!-- Bilingual text selection -->
  <xsl:template name="bilingual_text">
    <xsl:param name="he"/>
    <xsl:param name="en"/>
    <xsl:variable name="lang">
      <xsl:call-template name="get_user_language"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$lang = 'he'">
        <xsl:value-of select="$he"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$en"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
```

**Usage Example**:
```xml
<!-- Before -->
<xsl:choose>
  <xsl:when test="/notification_data/receivers/receiver/user/user_preferred_language = 'he'">
    <xsl:text>שלום</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>Hello</xsl:text>
  </xsl:otherwise>
</xsl:choose>

<!-- After -->
<xsl:call-template name="bilingual_text">
  <xsl:with-param name="he" select="'שלום'"/>
  <xsl:with-param name="en" select="'Hello'"/>
</xsl:call-template>
```

**Benefits**:
- Reduces 50+ xsl:choose blocks to single template calls
- Consistent language detection logic
- Easier to extend (e.g., add Arabic support)
- Reduces letter file complexity

#### 2.3 Refactor QueryToPatronLetter.xsl

**Files Affected**: QueryToPatronLetter.xsl (946 lines)
**Effort**: High
**Impact**: High

**Problem**:
- 25 nearly identical query type handlers (lines 24-207)
- **BUG**: Lines 63, 70, 77+ all reference `@@Type_5_header@@` instead of correct type
- Cannot easily add new query types
- 174 lines of duplicated code

**Current Structure**:
```xml
<xsl:choose>
  <xsl:when test="/notification_data/general_data/letter_type = 'Type_1'">
    <!-- 7 lines of identical structure -->
  </xsl:when>
  <xsl:when test="/notification_data/general_data/letter_type = 'Type_2'">
    <!-- 7 lines of identical structure -->
  </xsl:when>
  <!-- ... 23 more identical blocks ... -->
</xsl:choose>
```

**Solution**: Configuration-driven approach

1. Create `query-type-config.xsl`:
```xml
<xsl:variable name="query_types">
  <type id="Type_1" header="@@Type_1_header@@" line1="@@Type_1_query_line_1@@" line2="@@Type_1_query_line_2@@"/>
  <type id="Type_2" header="@@Type_2_header@@" line1="@@Type_2_query_line_1@@" line2="@@Type_2_query_line_2@@"/>
  <!-- ... 23 more types ... -->
</xsl:variable>
```

2. Refactor QueryToPatronLetter.xsl:
```xml
<xsl:variable name="letter_type" select="/notification_data/general_data/letter_type"/>
<xsl:variable name="config" select="$query_types/type[@id = $letter_type]"/>

<xsl:if test="$config">
  <tr><td><h3><xsl:value-of select="$config/@header"/></h3></td></tr>
  <xsl:if test="$config/@line1 != ''">
    <tr><td><xsl:value-of select="$config/@line1"/></td></tr>
  </xsl:if>
  <!-- ... -->
</xsl:if>
```

**Benefits**:
- Reduces 174 lines to ~20 lines
- Fixes bug where wrong header is referenced
- Easy to add new query types (just add XML entry)
- Easier to test

---

### PRIORITY 3: MEDIUM (Strategic Improvements - 4-8 weeks)

#### 3.1 Refactor Emergency Mode Logic

**Files Affected**: FulUserBorrowingActivityLetter.xsl
**Effort**: Medium
**Impact**: Medium

**Problem**:
- 90% code duplication between emergency (lines 25-85) and normal (lines 87-273) modes
- Both branches contain identical header/footer calls
- Difficult to maintain consistency

**Solution**: Extract common structure, parameterize differences

```xml
<xsl:template match="/">
  <html>
    <head><xsl:call-template name="generalStyle" /></head>
    <body>
      <xsl:attribute name="style">
        <xsl:call-template name="bodyStyleCss" />
      </xsl:attribute>

      <!-- Common header/sender/salutation -->
      <xsl:call-template name="head" />
      <xsl:call-template name="senderReceiverRevised" />
      <br />
      <xsl:call-template name="toWhomIsConcerned" />

      <!-- Conditional body only -->
      <div class="messageArea">
        <div class="messageBody">
          <xsl:choose>
            <xsl:when test="$emergency = 'True'">
              <xsl:call-template name="emergency_message_body" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="normal_message_body" />
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </div>

      <!-- Common footer -->
      <xsl:call-template name="lastFooter" />
      <xsl:call-template name="donotreply" />
    </body>
  </html>
</xsl:template>

<xsl:template name="emergency_message_body">
  <!-- Emergency content only (lines 36-79) -->
</xsl:template>

<xsl:template name="normal_message_body">
  <!-- Normal content only (lines 101-234) -->
</xsl:template>
```

**Benefits**:
- Reduces duplication from 90% to 0%
- Easier to modify header/footer (single location)
- Clearer separation of concerns
- Easier to test emergency mode in isolation

#### 3.2 Fix Naming Inconsistencies

**Files Affected**: senderReciever.xsl, FulReasourceRequestSlipLetter.xsl
**Effort**: Low-Medium
**Impact**: Low

**Problem**:
- `senderReciever.xsl` - misspelled (should be "Receiver")
- `FulReasourceRequestSlipLetter.xsl` - misspelled (should be "Resource")

**Solution**:
1. Rename files:
   - `senderReciever.xsl` → `senderReceiver.xsl`
   - `FulReasourceRequestSlipLetter.xsl` → `FulResourceRequestSlipLetter.xsl`

2. Update all `<xsl:include href="senderReciever.xsl" />` references (29 files)

3. Update CLAUDE.md and README.md

**Benefits**:
- Professional appearance
- Easier to search
- Aligns with naming conventions

#### 3.3 Add Template Usage Documentation

**Files Affected**: All shared templates (header.xsl, footer.xsl, senderReceiver.xsl)
**Effort**: Low
**Impact**: Medium

**Problem**:
- No clear guidance on which template variants to use
- Example: When to use `senderReceiver` vs `senderReceiverRevised` vs `senderReceiverMinimal`?

**Solution**: Add XML comment headers to all templates

```xml
<!--
  Template: senderReceiverRevised
  Purpose: Display sender (user) and receiver (library) information in TAU standard format
  Usage: Use this for all NEW TAU letters (default choice)
  Parameters: None
  Output: User name + email | Library name + address + phone + email
  Example:
    <xsl:call-template name="senderReceiverRevised" />
  See also: senderReceiverMinimal (for slips), senderReceiver (OTB - avoid)
-->
<xsl:template name="senderReceiverRevised">
  <!-- ... -->
</xsl:template>
```

**Update CLAUDE.md** with decision matrix:

| Template | When to Use | Output |
|----------|-------------|--------|
| `senderReceiverRevised` | **Default for all new letters** | Name + Email / Library details |
| `senderReceiverMinimal` | Print slips only | Name / Library name |
| `senderReceiver` | **AVOID** - OTB template | Full address blocks |
| `senderReceiverExtended` | **DEPRECATED** - Do not use | (Deleted) |

**Benefits**:
- New developers know which templates to use
- Reduces implementation errors
- Self-documenting code

---

### PRIORITY 4: LONG-TERM (Architecture - 8-16 weeks)

#### 4.1 Migrate to XSLT 3.0

**Files Affected**: All 29 stylesheets
**Effort**: High
**Impact**: Very High

**Strategy**: Gradual, file-by-file migration

**Phase 1: Low-Risk Files** (Week 1-2)
Test Alma's XSLT 3.0 support with simple files:
1. `style.xsl` - No complex logic
2. `mailReason.xsl` - Simple salutation template
3. `recordTitle.xsl` - Bibliographic display only

**Change**:
```xml
<!-- Before -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- After -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">
```

**Test**: Deploy to Alma test environment, generate sample letters, verify output

**Phase 2: Utility Templates** (Week 3-4)
Migrate shared templates with XSLT 3.0 features:

**footer.xsl refactoring**:
```xml
<!-- Current: String-based static content store (lines 5-27) -->
<xsl:variable name="additional_texts">
  <texts>
    <text label="text_01" lang="he" lib="190905450004146">בדלפק ההשאלה בספריה המרכזית</text>
  </texts>
</xsl:variable>

<!-- XSLT 3.0: Map-based store -->
<xsl:variable name="additional_texts" as="map(xs:string, map(xs:string, xs:string))">
  <xsl:map>
    <xsl:map-entry key="'text_01'">
      <xsl:map>
        <xsl:map-entry key="'he'" select="'בדלפק ההשאלה בספריה המרכזית'"/>
        <xsl:map-entry key="'en'" select="'from the circulation desk at the Central Library'"/>
      </xsl:map>
    </xsl:map-entry>
  </xsl:map>
</xsl:variable>

<!-- Lookup with XSLT 3.0 -->
<xsl:template name="additional_text_lookup">
  <xsl:param name="label" as="xs:string"/>
  <xsl:param name="letter_language" as="xs:string" select="'en'"/>

  <xsl:value-of select="$additional_texts($label)($letter_language)"/>
</xsl:template>
```

**language-util.xsl refactoring**:
```xml
<!-- XSLT 3.0: Boolean return type -->
<xsl:function name="tau:is-hebrew" as="xs:boolean">
  <xsl:param name="context" as="node()"/>
  <xsl:sequence select="tau:get-user-language($context) = 'he'"/>
</xsl:function>

<!-- Usage -->
<xsl:if test="tau:is-hebrew(.)">
  <xsl:text>שלום</xsl:text>
</xsl:if>
```

**Phase 3: Letter Files** (Week 5-12)
Migrate letter files, prioritize by complexity:
1. Simple letters first (FulItemChangeDueDateLetter.xsl)
2. Medium complexity (FulPlaceOnHoldShelfLetter.xsl)
3. Complex letters last (QueryToPatronLetter.xsl, FulUserBorrowingActivityLetter.xsl)

**Specific Improvements**:

**FulUserBorrowingActivityLetter.xsl**:
```xml
<!-- XSLT 1.0: String boolean -->
<xsl:variable name="emergency" select="'False'" />
<xsl:when test="$emergency = 'True'">

<!-- XSLT 3.0: Native boolean -->
<xsl:variable name="emergency" as="xs:boolean" select="false()" />
<xsl:when test="$emergency">
```

**QueryToPatronLetter.xsl**:
```xml
<!-- XSLT 3.0: Sequence operations instead of 25 xsl:when blocks -->
<xsl:variable name="valid_types" as="xs:string*"
              select="('Type_1', 'Type_2', ..., 'Type_25')"/>

<xsl:if test="/notification_data/general_data/letter_type = $valid_types">
  <!-- Unified query handler -->
</xsl:if>
```

**Phase 4: Advanced Features** (Week 13-16)
Implement XSLT 3.0-specific optimizations:

**Streaming** (for large loan lists):
```xml
<xsl:mode streamable="yes"/>

<xsl:template match="notification_data">
  <xsl:for-each select="loans_by_library/library_loans_for_display">
    <xsl:apply-templates select="." mode="streaming"/>
  </xsl:for-each>
</xsl:template>
```

**Try/Catch** (error handling):
```xml
<xsl:try>
  <xsl:variable name="lib" select="tau:get-library-by-id($lib_id)"/>
  <xsl:value-of select="$lib/contact/phone"/>
  <xsl:catch>
    <xsl:message>Warning: Library ID not found: <xsl:value-of select="$lib_id"/></xsl:message>
    <xsl:text>Contact library for information</xsl:text>
  </xsl:catch>
</xsl:try>
```

**Benefits**:
- **30% reduction** in workaround code (sequences, booleans, regex)
- Type safety (catches errors at compile time)
- Better performance (streaming for large documents)
- Improved error handling
- Easier to maintain and extend

**Risks**:
- Alma's Saxon HE 9.9.1-6 may not support all XSLT 3.0 features
- Higher-order functions confirmed non-functional
- Requires extensive testing in Alma environment

**Mitigation**:
- Start with simple XSLT 3.0 features (booleans, sequences)
- Avoid higher-order functions and advanced array operations
- Test each feature in Alma before widespread use
- Maintain XSLT 1.0 fallback for critical letters

#### 4.2 Implement Configuration Files

**Files Affected**: New files, footer.xsl, multiple letter files
**Effort**: High
**Impact**: Very High

**Problem**:
- Hard-coded configuration scattered throughout codebase
- No way for non-developers to update library info or translations

**Solution**: Externalize all configuration

**File 1: libraries.xml**
```xml
<?xml version="1.0" encoding="utf-8"?>
<libraries>
  <library id="190893010004146" code="AH1">
    <name lang="he">הספרייה למדעי החברה, לניהול ולחינוך</name>
    <name lang="en">Social Sciences, Management and Education Library</name>
    <contact>
      <phone>03-6409085</phone>
      <email>SMLCirc@tauex.tau.ac.il</email>
      <address>
        <line1>Tel Aviv University</line1>
        <line2>Ramat Aviv</line2>
        <city>Tel Aviv</city>
        <postal_code>6997801</postal_code>
      </address>
    </contact>
    <rs>
      <department lang="he">שירותי השאלה בינספרייתית ואספקת פרסומים</department>
      <department lang="en">Interlibrary Loan and Document Delivery Services</department>
      <phone lang="he">טלפון: 03-6407066 ; 03-6405501 | פקס: 03-6407840</phone>
      <phone lang="en">Phone: 03-6407066 ; 03-6405501 | Fax: 03-6407840</phone>
      <email>SMLILL@tauex.tau.ac.il</email>
    </rs>
  </library>
  <!-- Repeat for all 6 TAU libraries -->
</libraries>
```

**File 2: translations.xml**
```xml
<?xml version="1.0" encoding="utf-8"?>
<translations>
  <text key="emergency_greeting_he">שלום,</text>
  <text key="emergency_greeting_en">Hello,</text>
  <text key="emergency_closure_he">עקב המצב, הספרייה סגורה למבקרים עד להודעה חדשה.</text>
  <text key="emergency_closure_en">Due to the situation, the library is closed until further notice.</text>
  <!-- ... all bilingual text snippets ... -->
</translations>
```

**File 3: config.xsl** (Loader)
```xml
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Load external configuration files -->
  <xsl:variable name="libraries" select="document('libraries.xml')/libraries"/>
  <xsl:variable name="translations" select="document('translations.xml')/translations"/>

  <!-- Configuration functions -->
  <xsl:function name="tau:get-library">
    <xsl:param name="lib_id" as="xs:string"/>
    <xsl:sequence select="$libraries/library[@id = $lib_id or contains($lib_id, @code)]"/>
  </xsl:function>

  <xsl:function name="tau:translate">
    <xsl:param name="key" as="xs:string"/>
    <xsl:sequence select="$translations/text[@key = $key]"/>
  </xsl:function>

</xsl:stylesheet>
```

**Usage in Letters**:
```xml
<xsl:include href="config.xsl" />

<xsl:variable name="lib" select="tau:get-library($lib_id)"/>
<xsl:value-of select="$lib/contact/phone"/>

<xsl:value-of select="tau:translate('emergency_greeting_' || $language)"/>
```

**Benefits**:
- Library staff can update contact info without touching XSLT
- Translators can update text in XML files
- Enables centralized configuration management
- Can generate libraries.xml from Alma API (future enhancement)

**Deployment**:
- Upload libraries.xml, translations.xml to Alma alongside XSLT files
- XSLT `document()` function loads external files
- Test in Alma environment (may require specific file paths)

---

## Implementation Roadmap

### Sprint 1 (Weeks 1-2): Quick Wins
**Goal**: Clean up codebase, reduce confusion

- [ ] 1.1 Consolidate `additional_text` implementations
- [ ] 1.2 Delete `senderReceiverExtended` template
- [ ] 1.3 Remove commented-out code (200+ lines)
- [ ] Document changes in CLAUDE.md

**Deliverables**:
- footer.xsl reduced by ~150 lines
- senderReciever.xsl reduced by 64 lines
- 6 letter files cleaned up
- Updated CLAUDE.md

### Sprint 2 (Weeks 3-4): Library Configuration
**Goal**: Externalize hard-coded library data

- [ ] 2.1 Create library-config.xsl with 6 TAU libraries
- [ ] 2.1 Refactor footer.xsl to use library-config
- [ ] 2.1 Update FulPlaceOnHoldShelfLetter.xsl hard-coded checks
- [ ] Test in Alma environment

**Deliverables**:
- library-config.xsl (new file)
- footer.xsl refactored (lines 245-644 simplified)
- Single source of truth for library data

### Sprint 3 (Weeks 5-6): Language Standardization
**Goal**: Consistent language detection

- [ ] 2.2 Create language-util.xsl
- [ ] 2.2 Migrate 5 high-priority letters to use language-util
- [ ] 2.2 Update CLAUDE.md with language patterns

**Deliverables**:
- language-util.xsl (new file)
- 5 letters refactored
- Reduced duplication by 50+ xsl:choose blocks

### Sprint 4 (Weeks 7-8): QueryToPatronLetter Refactoring
**Goal**: Fix bugs, reduce complexity

- [ ] 2.3 Create query-type-config.xsl
- [ ] 2.3 Refactor QueryToPatronLetter.xsl (174 lines → ~20 lines)
- [ ] 2.3 Fix Type_5_header bug
- [ ] Comprehensive testing with all 25 query types

**Deliverables**:
- query-type-config.xsl (new file)
- QueryToPatronLetter.xsl reduced by 150+ lines
- Bug fixes verified

### Sprint 5 (Weeks 9-10): Emergency Mode & Naming
**Goal**: Improve specific letter logic

- [ ] 3.1 Refactor FulUserBorrowingActivityLetter.xsl emergency mode
- [ ] 3.2 Rename misspelled files (senderReciever, FulReasource)
- [ ] 3.3 Add template documentation headers

**Deliverables**:
- FulUserBorrowingActivityLetter.xsl refactored (90% duplication removed)
- Files renamed, all includes updated
- All templates documented

### Sprint 6-8 (Weeks 11-16): XSLT 3.0 Migration
**Goal**: Modernize codebase

**Week 11-12**: Phase 1 & 2
- [ ] 4.1 Test XSLT 3.0 with style.xsl, mailReason.xsl, recordTitle.xsl
- [ ] 4.1 Migrate footer.xsl to maps/sequences
- [ ] 4.1 Create language-util.xsl with XSLT 3.0 functions

**Week 13-14**: Phase 3
- [ ] 4.1 Migrate 10 simple letter files
- [ ] 4.1 Migrate 5 medium complexity letters
- [ ] Test all migrated letters in Alma

**Week 15-16**: Phase 4
- [ ] 4.1 Migrate complex letters (QueryToPatronLetter, FulUserBorrowingActivityLetter)
- [ ] 4.1 Implement error handling with xsl:try/xsl:catch
- [ ] Comprehensive regression testing

**Deliverables**:
- All 29 stylesheets using XSLT 3.0
- 30% code reduction from eliminated workarounds
- Improved error handling

### Sprint 9-10 (Weeks 17-20): External Configuration (Optional)
**Goal**: Enable non-developer maintenance

- [ ] 4.2 Create libraries.xml
- [ ] 4.2 Create translations.xml
- [ ] 4.2 Create config.xsl loader
- [ ] Update all letters to use external config
- [ ] Test document() function in Alma

**Deliverables**:
- Externalized configuration files
- Library staff can update contact info
- Translators can update text

---

## Risk Assessment

### High Risk Items

#### Risk 1: XSLT 3.0 Compatibility
**Likelihood**: Medium
**Impact**: High
**Description**: Alma's Saxon HE 9.9.1-6 may not support all XSLT 3.0 features

**Mitigation**:
- Start with low-risk files (style.xsl)
- Test each XSLT 3.0 feature in Alma before widespread use
- Avoid known non-functional features (higher-order functions, array:filter)
- Maintain XSLT 1.0 fallback for critical letters
- Incremental migration allows rollback if issues arise

#### Risk 2: Breaking Changes During Refactoring
**Likelihood**: Medium
**Impact**: High
**Description**: Refactoring complex templates may introduce bugs

**Mitigation**:
- Comprehensive testing in Alma test environment
- Generate sample letters before/after changes, compare outputs
- Git branching strategy: feature branches for each sprint
- Code review by 2+ developers before merging
- Rollback plan for each deployment

#### Risk 3: External File Loading Issues
**Likelihood**: Medium
**Impact**: Medium
**Description**: Alma may restrict document() function or external file paths

**Mitigation**:
- Test document() function early in Sprint 9
- Alternative: Inline configuration in config.xsl if external files don't work
- Have fallback plan to embed configuration in XSLT

### Medium Risk Items

#### Risk 4: Incomplete Migration
**Likelihood**: Low
**Impact**: Medium
**Description**: Some letters remain XSLT 1.0 while others use 3.0

**Mitigation**:
- This is acceptable - XSLT 3.0 is backwards compatible
- Document which letters use which version in CLAUDE.md
- Gradual migration minimizes disruption

#### Risk 5: Library Contact Changes
**Likelihood**: High
**Impact**: Low
**Description**: Library phone/email changes require code updates (before improvement 2.1)

**Mitigation**:
- Prioritize Sprint 2 (library-config.xsl) to externalize this data
- Document temporary process for updates in CLAUDE.md
- After Sprint 2, library staff can update libraries.xml directly

---

## Success Metrics

### Quantitative Metrics

#### Code Quality
- **Lines of Code**: Reduce by 20% (from ~8,500 to ~6,800 lines)
  - footer.xsl: 711 → ~500 lines (-30%)
  - QueryToPatronLetter.xsl: 946 → ~800 lines (-15%)
  - Remove 200+ lines of commented code

- **Code Duplication**: Reduce by 50%
  - Language conditionals: 844 → ~420 instances
  - FulUserBorrowingActivityLetter: 90% → 0% duplication

- **Cyclomatic Complexity**: Reduce by 30%
  - QueryToPatronLetter: 25 xsl:when blocks → 1 parameterized template
  - footer.xsl: 48 xsl:choose → map-based lookup

#### Maintainability
- **Hard-Coded Values**: Reduce to 0
  - Library IDs: 40+ → 0 (externalized to library-config.xsl)
  - Contact info: 15 blocks → 0 (externalized)
  - URLs: 2+ → 0 (configuration)

- **Template Clarity**: 100% documented
  - All shared templates have usage documentation
  - Decision matrix in CLAUDE.md for template selection

### Qualitative Metrics

#### Developer Experience
- **Onboarding Time**: Reduce by 50%
  - New developers understand which templates to use (documented)
  - Clear library configuration (no hunting for hard-coded values)

- **Maintenance Effort**: Reduce by 40%
  - Library contact updates: Edit libraries.xml (not XSLT)
  - Add new query type: Edit query-type-config.xsl (not 25 xsl:when blocks)
  - Add bilingual text: Use additional_text_lookup (single pattern)

#### Production Stability
- **Bugs Fixed**: 3+ critical bugs
  - QueryToPatronLetter Type_5_header bug (lines 63, 70, 77+)
  - Inconsistent language detection across letters
  - Silent error handling failures

- **Error Handling**: 100% coverage
  - All templates have xsl:otherwise with meaningful messages
  - XSLT 3.0 try/catch for runtime errors
  - Diagnostic logging when library/language not found

### Post-Implementation Review (Month 3)

Measure these KPIs 3 months after completion:

1. **Deployment Velocity**: Time from code change to production
   - Target: 50% reduction (library config changes no longer require XSLT edits)

2. **Incident Rate**: Production bugs per month
   - Target: 50% reduction (better error handling, reduced complexity)

3. **Change Request Cycle Time**: Time to implement new feature
   - Target: 30% reduction (clearer architecture, better documentation)

4. **Code Review Feedback**: Average comments per pull request
   - Target: 40% reduction (clearer code, documented patterns)

---

## Appendix A: XSLT 3.0 Feature Compatibility Matrix

Based on Ex Libris developer network discussions and Alma November 2022 upgrade:

| Feature | XSLT Version | Alma Support | Notes |
|---------|--------------|--------------|-------|
| **Core Language** |
| Maps and Arrays | 3.0 | ✅ Confirmed | Use for configuration data structures |
| Sequences | 2.0 | ✅ Confirmed | `$lang = ('he', 'en')` works |
| let expressions | 2.0 | ✅ Confirmed | XPath 3.0 support |
| Regular expressions | 2.0 | ✅ Confirmed | `matches()`, `replace()` functions |
| Boolean type | 2.0 | ✅ Confirmed | `xs:boolean` supported |
| Type annotations | 2.0 | ✅ Confirmed | `as="xs:string"` works |
| **Advanced Features** |
| Higher-order functions | 3.0 | ❌ Not working | Avoid `for-each`, `filter` on functions |
| Streaming | 3.0 | ⚠️ Unknown | Test before use |
| xsl:try/xsl:catch | 3.0 | ⚠️ Unknown | Test before use |
| Packages | 3.0 | ⚠️ Unknown | May not be necessary |
| array:filter | 3.0 | ❌ Not working | Use for-each instead |
| **Safe to Use** |
| String templates | 3.0 | ⚠️ Unknown | Alternative: concat() |
| xsl:evaluate | 3.0 | ⚠️ Unknown | Test if needed |

**Recommendation**: Start with XSLT 2.0 features (sequences, regex, booleans, types) which are well-supported. Gradually test XSLT 3.0-specific features (maps, arrays, try/catch) in Alma environment before widespread use.

---

## Appendix B: Testing Strategy

### Pre-Deployment Testing

#### Unit Testing (Per Sprint)
For each refactored template:
1. **Input**: Sample XML from Alma
2. **Process**: XSLT transformation (local Saxon HE 9.9+ or Alma test environment)
3. **Output**: HTML letter
4. **Verification**:
   - Visual inspection (correct language, library info)
   - Diff against previous version (ensure no unintended changes)
   - XPath validation (all expected elements present)

#### Integration Testing
For each sprint deliverable:
1. Deploy to Alma **test environment**
2. Generate letters for all affected letter types
3. Test scenarios:
   - Hebrew user
   - English user
   - Each TAU library (AH1, AL1, AS1, AM1, AC1, Wiener)
   - Emergency mode on/off (for FulUserBorrowingActivityLetter)
   - All query types (for QueryToPatronLetter)
4. Compare with production versions
5. Stakeholder review (library staff)

#### Regression Testing
Before production deployment:
1. Generate 50+ sample letters across all types
2. Compare with baseline (pre-refactoring versions)
3. Automated diff checking (HTML structure, key text)
4. Manual spot-checking (visual appearance, bilingual content)

### Post-Deployment Monitoring

#### Week 1 After Deployment
- Monitor Alma error logs daily
- Check letter generation success rate
- User feedback (library staff, patrons)
- Rollback trigger: >5% increase in errors or user complaints

#### Month 1 After Deployment
- Review incident reports
- Measure success metrics (see Success Metrics section)
- Collect developer feedback
- Plan adjustments for next sprint

---

## Appendix C: Quick Reference - File Locations

### Current Files to Modify

| File | Location | Purpose | Priority |
|------|----------|---------|----------|
| footer.xsl | xslt/footer.xsl | Shared footer templates, static content | 1.1, 2.1 |
| senderReciever.xsl | xslt/senderReciever.xsl | Sender/receiver templates | 1.2, 3.2 |
| FulUserBorrowingActivityLetter.xsl | xslt/FulUserBorrowingActivityLetter.xsl | Emergency mode letter | 3.1 |
| QueryToPatronLetter.xsl | xslt/QueryToPatronLetter.xsl | Complex query letter | 2.3 |
| FulPlaceOnHoldShelfLetter.xsl | xslt/FulPlaceOnHoldShelfLetter.xsl | Hold notification | 2.1 |
| 6+ letter files | xslt/*.xsl | Commented code removal | 1.3 |

### New Files to Create

| File | Location | Purpose | Sprint |
|------|----------|---------|--------|
| library-config.xsl | xslt/library-config.xsl | Library configuration | 2 |
| language-util.xsl | xslt/language-util.xsl | Language detection utilities | 3 |
| query-type-config.xsl | xslt/query-type-config.xsl | Query type definitions | 4 |
| libraries.xml | (root or config/) | External library data | 9-10 |
| translations.xml | (root or config/) | External translations | 9-10 |
| config.xsl | xslt/config.xsl | Configuration loader | 9-10 |

---

## Conclusion

This improvement proposal addresses **critical technical debt** while positioning the TAU Alma Letters codebase for modern XSLT 3.0 features. The **10-sprint roadmap** balances quick wins (Sprints 1-2) with strategic improvements (Sprints 6-10), enabling immediate value while building toward long-term maintainability.

**Key Outcomes**:
- 20% code reduction (8,500 → 6,800 lines)
- 50% reduction in code duplication
- Externalized configuration (0 hard-coded values)
- Modern XSLT 3.0 features (type safety, sequences, error handling)
- Comprehensive documentation and developer guidance

**Recommended Approach**:
1. **Start immediately** with Priority 1 items (Sprints 1-2) - low risk, high value
2. **Test XSLT 3.0** in Sprint 6 before committing to full migration
3. **Defer external configuration** (Sprint 9-10) if resource-constrained

**Next Steps**:
1. Stakeholder review of this proposal
2. Approval for Sprint 1 (Quick Wins)
3. Create GitHub issues for each improvement
4. Begin implementation with comprehensive testing

This proposal is designed to be **incremental**, **testable**, and **reversible** at each sprint, minimizing risk while maximizing code quality improvements.

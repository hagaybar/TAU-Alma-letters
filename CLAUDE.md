# CLAUDE.md

## Project Overview

This repository contains customized XSLT (Extensible Stylesheet Language Transformations) stylesheets for Tel Aviv University's Alma library management system, transforming XML notification data into bilingual (Hebrew/English) HTML emails and printed slips for library patrons covering loans, holds, resource sharing, digitization requests, and general communications.

**IMPORTANT**: For comprehensive information about Alma's letter system, XML structure, configuration methods, and official Ex Libris guidelines, see [ALMA_LETTERS_GUIDE.md](ALMA_LETTERS_GUIDE.md). This document focuses on TAU-specific customizations and development patterns.

## Core Technology Stack

- **Primary Language**: XSLT 1.0
- **Data Format**: XML (Alma notification data)
- **Output Format**: HTML (email/print)
- **Version Control**: Git
- **Target System**: Ex Libris Alma library management platform
- **Languages Supported**: Hebrew (he), English (en)

## Architecture & Patterns

### Design Philosophy

This codebase follows a **modular, template-based architecture** with strict separation of concerns. XSLT stylesheets are organized as reusable component libraries that letter templates compose via `xsl:include` directives.

### Data Flow

1. **Input**: Alma generates XML notification data with patron, item, library, and transaction details
2. **Transformation**: XSLT stylesheet processes XML, applying templates and business logic
3. **Output**: HTML-formatted email/slip rendered with inline CSS and embedded images (logo)

### Component Architecture

```
Letter Stylesheet (e.g., FulPlaceOnHoldShelfLetter.xsl)
    ├─ Includes: header.xsl, footer.xsl, style.xsl, senderReceiver.xsl, mailReason.xsl, recordTitle.xsl
    └─ Orchestrates: template calls in structured HTML document
```

### Core Template Library

All letter stylesheets **MUST** include these core templates:

- **header.xsl** (xslt/header.xsl:1): Logo rendering, library name resolution, letter title/date display
  - `head` template: Standard header with logo and library name (conditional logic for RS letters)
  - `headFulItemChangeDateLetter`: Specialized header for due date change letters
  - `headFulPlaceOnHoldShelfLetterRS`: Header variant for resource sharing hold notifications

- **footer.xsl** (xslt/footer.xsl:1): Institutional footers, contact details, static content store
  - **Static Content Store** (lines 5-27): XML-based key-value store for multilingual/library-specific text snippets (labels: text_01-text_05)
  - `additional_text_lookup`: **NEW PATTERN** (lines 31-56) - Preferred method for adding custom text with library/language/label matching and fallback logic
  - `additional_text`: **LEGACY PATTERN** (lines 146-232) - Hard-coded conditional logic (use only for existing text_01-text_04 labels)
  - `rs_details`: Resource sharing contact details with library-specific phone/email (lines 466-518)
  - `donotreply`: Auto-reply warning message (lines 562-592)
  - `feesTable`: Outstanding fines display with library contact info (lines 647-710)
  - `lastFooter` / `empty_lastFooter`: Institutional footer variants

- **style.xsl** (xslt/style.xsl:1): CSS-in-JS template definitions for consistent visual styling
  - `generalStyle`, `bodyStyleCss`, `headerTableStyleCss`, `footerTableStyleCss`, etc.

- **senderReceiver.xsl** (xslt/senderReciever.xsl:1): Patron and library address blocks
  - `senderReceiverRevised`: **TAU STANDARD** - User name/email + Library details (lines 79-129)
  - `senderReceiverMinimal`: Minimal variant (name only)
  - `senderReceiver`: Out-of-the-box template (avoid in TAU letters)

- **recordTitle.xsl** (xslt/recordTitle.xsl:1): Bibliographic metadata display (title, author, description)

- **mailReason.xsl** (xslt/mailReason.xsl:1): Salutation template (`toWhomIsConcerned`)

### Letter-Specific Patterns

Each letter stylesheet follows this structure:

```xml
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- Include core templates -->
    <xsl:include href="header.xsl" />
    <xsl:include href="footer.xsl" />
    <xsl:include href="style.xsl" />
    <xsl:include href="senderReceiver.xsl" />
    <xsl:include href="mailReason.xsl" />
    <xsl:include href="recordTitle.xsl" />

    <!-- Root template -->
    <xsl:template match="/">
        <html>
            <head>
                <xsl:call-template name="generalStyle" />
            </head>
            <body style="...">
                <!-- Header -->
                <xsl:call-template name="head" />

                <!-- Sender/Receiver -->
                <xsl:call-template name="senderReceiverRevised" />

                <!-- Salutation -->
                <xsl:call-template name="toWhomIsConcerned" />

                <!-- Message body (letter-specific logic) -->
                <div class="messageArea">
                    <!-- Custom content, Alma labels (@@label@@), bibliographic data -->
                </div>

                <!-- Footer -->
                <xsl:call-template name="lastFooter" />
                <xsl:call-template name="donotreply" />
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
```

### Dynamic Content System

**CRITICAL**: When adding custom text to letters, use the **new `additional_text_lookup` template** (footer.xsl:31-56):

```xml
<!-- CORRECT - New pattern with static content store -->
<xsl:call-template name="additional_text_lookup">
    <xsl:with-param name="label" select="'text_05'" />
    <xsl:with-param name="letter_language" select="/notification_data/receivers/receiver/preferred_language" />
    <xsl:with-param name="lib_id" select="/notification_data/organization_unit/org_scope/library_id" />
</xsl:call-template>

<!-- AVOID - Legacy pattern (use only for text_01-text_04) -->
<xsl:call-template name="additional_text">
    <xsl:with-param name="label" select="'text_01'" />
</xsl:call-template>
```

**Static Content Store** (footer.xsl:5-27):
- Define text snippets as XML elements with `@label`, `@lang`, `@lib` attributes
- Supports library-specific overrides (e.g., text_01 for Wiener Library only: `lib="190905450004146"`)
- Template performs three-tier lookup: label+lang+lib → label+lang → warning message

### Library Identification

TAU library codes and IDs:

| Code | ID | Library |
|------|-----|---------|
| AH1 | 190893010004146 | Social Sciences, Management and Education |
| AL1 | 190896720004146 | David J. Light Law Library |
| AS1 | 190902540004146 | Exact Sciences and Engineering |
| AM1 | 190899330004146 | Life Sciences and Medicine |
| AC1 / RES_SHARE | 12900830000231 | Sourasky Central Library (Resource Sharing) |
| - | 190905450004146 | Wiener Library |

### Conditional Rendering Rules

- **Resource Sharing (RS) Letters**: Detected via `/notification_data/request/resource_sharing_request_id != ''`
  - Use specialized headers (`headFulPlaceOnHoldShelfLetterRS`)
  - Display `rs_details` instead of standard `department` contact info
  - Skip `donotreply` for AC1 (12900830000231)

- **Wiener Library (190905450004146)**:
  - Use `empty_lastFooter` instead of `lastFooter`
  - Inject custom pickup location text via `additional_text` label `text_01`

- **Language Detection**: `/notification_data/receivers/receiver/user/user_preferred_language` or `/notification_data/receivers/receiver/preferred_language`
  - Hebrew: `'he'`
  - English: `'en'` (default fallback)

### Paved Path for Adding New Letters

1. **Review Alma documentation**: Consult [ALMA_LETTERS_GUIDE.md](ALMA_LETTERS_GUIDE.md) for available XML paths and Alma platform constraints
2. **Obtain XML sample**: Use Alma's built-in XML sample generator (see ALMA_LETTERS_GUIDE.md → "Obtaining XML Samples")
3. **Create new .xsl file** in `xslt/` directory (naming: `FulCamelCaseLetterName.xsl`)
4. **Include core templates**: header, footer, style, senderReceiver, mailReason, recordTitle
5. **Use standard template structure** (see "Letter-Specific Patterns" above)
6. **Call `senderReceiverRevised`** for user/library details (TAU standard)
7. **Access Alma labels** via `@@label_name@@` (auto-replaced by Alma system)
8. **Extract data from XML** using XPath: `/notification_data/...` (see ALMA_LETTERS_GUIDE.md for complete path reference)
9. **Handle bilingual content** with conditional logic on `user_preferred_language`
10. **Add custom text** via `additional_text_lookup` with new labels in static content store
11. **Test with sample XML** from `xml/` directory or Alma preview pane
12. **Validate in Alma**: Use Alma's built-in preview before deployment (see ALMA_LETTERS_GUIDE.md → "Testing and Deployment")

### Paved Path for Modifying Shared Templates

1. **Identify target template** (header.xsl, footer.xsl, etc.)
2. **Review all includes**: Use `grep -r "xsl:include href=\"{template}.xsl\"" xslt/` to find dependent letters
3. **Review Ex Libris constraints**: Check [ALMA_LETTERS_GUIDE.md](ALMA_LETTERS_GUIDE.md) → "XSLT Best Practices" for platform-specific rules
4. **Test changes** against multiple letter types (regular loans, RS, different libraries)
5. **Preserve backward compatibility**: Do not remove existing template parameters or rename templates
6. **Avoid unused template calls**: Remove any `xsl:call-template` references to non-existent templates (causes XSLT failures even in unused code - see ALMA_LETTERS_GUIDE.md)
7. **Document library-specific logic**: Add inline XML comments for conditional behavior

## Code Conventions & Guardrails

### Mandatory Rules

1. **Template Naming**: Use descriptive camelCase names (`senderReceiverRevised`, not `srr`)
2. **Include Order**: Always load templates in this sequence: header → footer → style → senderReceiver → mailReason → recordTitle
3. **Namespace Declaration**: Every stylesheet MUST declare `xmlns:xsl="http://www.w3.org/1999/XSL/Transform"`
4. **XSLT Version**: All stylesheets MUST use `version="1.0"` (Alma constraint)
5. **XML Declaration**: Start files with `<?xml version="1.0" encoding="utf-8"?>`
6. **Indentation**: Use tabs (width 1) for XSLT elements
7. **Comments**: Use XML comments `<!-- ... -->` to explain business logic, library codes, template behavior
8. **Inline Documentation**: Document complex conditional logic, library IDs, and template parameters at declaration
9. **Path Expressions**: Use absolute XPath (`/notification_data/...`) for clarity, avoid abbreviations like `//`
10. **Static Content First**: Add new dynamic text to static content store (footer.xsl:5-27) before calling `additional_text_lookup`

### Library-Specific Logic

- **NEVER hard-code library names** - use library_id/code for conditionals
- **Test against all libraries** when modifying shared templates
- **Document library exceptions** in comments (e.g., Wiener Library empty footer rule)

### Bilingual Content

- **Default to English** when language is undefined
- **Test both Hebrew/English** for every user-facing string
- **Use consistent terminology** across letters (refer to existing letters as style guide)

### Template Parameters

- **Always provide defaults** for optional parameters (e.g., `select="/notification_data/..."`)
- **Document parameter purpose** in comments above template definition
- **Pass parameters explicitly** when calling templates (avoid relying on context)

### Deprecated Patterns

- **AVOID**: `additional_text` template for new labels (use `additional_text_lookup` instead)
- **AVOID**: `senderReceiver` OTB template (use `senderReceiverRevised`)
- **AVOID**: `senderReceiverExtended` (marked for deletion, per senderReciever.xsl:132)

### Testing Requirements

- **Sample XML**: Place test XML files in `xml/` directory
- **Manual Testing**: Verify rendering in Alma configuration before deployment
- **Regression Testing**: Test existing letters when modifying shared templates

## Key Directories

### `xslt/`
**Purpose**: Production XSLT stylesheets deployed to Alma cloud
**Contents**:
- **Letter templates** (30+ files): Transform-specific stylesheets (e.g., FulPlaceOnHoldShelfLetter.xsl, FulUserLoansCourtesyLetter.xsl)
- **Shared template libraries**: header.xsl, footer.xsl, style.xsl, senderReceiver.xsl, mailReason.xsl, recordTitle.xsl, contactUs.xsl

### `xslt-local-location/`
**Purpose**: Templates loaded from TAU local server (not Alma cloud)
**Contents**:
- common_templates.xsl: Localized reusable templates
- footer-origin.xsl: Original footer backup

**NOTE**: Files here are referenced by local Alma configuration

### `xml/`
**Purpose**: Sample XML data for testing XSLT transformations
**Contents**:
- note.xml: Minimal test XML
- (Add Alma notification XML samples here for development/testing)

### `.git/`
Standard Git repository metadata (ignore for development)

## Recent Development Activity

Key recent commits (from git log):
- **d9d244d**: Refactored `additional_text_lookup` template with improved fallback logic
- **dc4b479**: Introduced new `additional_text_lookup` template for dynamic content rendering
- **8fbe6ef, aa2ce48**: Added static content store for additional_text labels (XML-based approach)
- **be17e59, 8c7aa99**: Revised RS department contact details templates (`rs_details`, `rs_details_display`)
- **aeb6f3c**: Loans grouped by library with contact information in FulUserBorrowingActivityLetter

## Development Workflow

1. **Branch Strategy**: Work on feature branches, merge to `main` via pull requests
2. **Testing**: Create sample XML in `xml/`, test locally before Alma deployment
3. **Alma Preview**: Use Alma's built-in preview pane for real-time validation (see [ALMA_LETTERS_GUIDE.md](ALMA_LETTERS_GUIDE.md) → "Testing and Deployment")
4. **Deployment**: Upload modified .xsl files to Alma configuration (Letters/Slips section)
5. **Version Control**: Commit frequently with descriptive messages referencing letter names/template changes
6. **Documentation**: Update inline comments when adding library-specific logic or new templates

## Additional Resources

- **[ALMA_LETTERS_GUIDE.md](ALMA_LETTERS_GUIDE.md)**: Comprehensive Ex Libris Alma platform documentation including:
  - Complete XML structure reference (`/notification_data/` paths)
  - Alma configuration methods (labels vs. templates)
  - Official XSLT best practices and constraints
  - Testing/deployment procedures
  - Troubleshooting checklist
  - Common customization examples

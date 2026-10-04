# AI-assisted development record

**Project:** CDRT — Client Document Request Tracker

**Participant:** Amitava Majumder | L2 B95

This is a summary of the development conversation and workflow, not a verbatim transcript and not a claim that the participant manually authored every line of code.

## User-provided direction

The participant requested help selecting and building an easy, effective capstone based on the AICA Level 2 course. The submission was due the next day. The course document, repository upload guide and existing ICAI project repository were reviewed before topic selection. The participant then chose the Client Document Request Tracker and requested that it be built from scratch.

## Requirements developed from that direction

Build a local application with client records, document requests, due dates, Pending/Received/Not required states, overdue tracking, a dashboard, reminder drafts and downloadable results. Include fictional sample records, source code, setup instructions, tests and a demonstration script. Keep AI-assisted development separate from runtime AI claims.

## Implementation approach

Use Python's standard library and SQLite to keep installation simple. Build the browser interface using HTML, CSS and JavaScript. Use explicit date rules for overdue items and templates for reminder drafts. Store actual documents outside the application.

## Review and verification work

Create automated tests for due-date boundaries, status transitions, persistence, input validation, reminder exclusions and CSV export. Run the local application, inspect the browser workflow and review the demonstration instructions. Record actual results in TEST_RESULTS.md.

## Participant review before submission

The participant should run the app, try the sample workflow, understand the key rules, and adapt the demonstration script to their own words. Add any subsequent prompts or changes below, describing them accurately.

## Further iterations

The participant confirmed that downloads worked, then requested further improvements and an assessment of GitHub readiness. Version 1.1 adds a database backup download, invalidates reminder drafts when refreshed records change, fixes overdue badge styling, and expands verification to 25 automated tests and a fresh-package launch check. The participant asked that their GitHub account not be used; all preparation remained local.

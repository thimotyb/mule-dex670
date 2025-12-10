# Mule DEX670 Workspace

This repository is my working space for the DEX670 course. I will build the solution incrementally, module by module, across:
- `check-in-papi`: Process API implementation and tests.
- `apps-commons`: Shared Mule components (error handling, health probes).
- `bom` and `parent-pom`: Build/dependency management and deployment defaults.

Each module may evolve as course exercises progress; commits track the incremental steps.

## Notes for Module 1
- Maven WARN about `org.apache.http.client.protocol.ResponseProcessCookies`: comes from HttpClient rejecting an ALB cookie (`AWSALBTGCORS`) with an `Expires` format it dislikes. Harmless; Maven ignores the cookie. Silence per-run with `mvn -Dorg.slf4j.simpleLogger.log.org.apache.http.client.protocol.ResponseProcessCookies=error clean verify` (or set the property in `MAVEN_OPTS` to make it sticky).

## Org ID helper
- Use `set-org-id.bat` to stamp your Anypoint Org ID into all POMs. From repo root: `set-org-id.bat YOUR-ORG-ID` (or run without args to be prompted). It replaces `<groupId>`, `<student.deployment.ap.orgid>`, and `<new.ap.org.id>` UUIDs across `bom`, `parent-pom`, `apps-commons`, and `check-in-papi`.

## WT1-1 (Set up the starter code)
- Based on DEX670 Exercise Guide “Walkthrough 1-1: Set up the starter code”: this repo captures the starter AnyAirline assets (BOM, parent POM, `apps-commons` plugin, and `check-in-papi` process API) ready for incremental work.
- Initialized Git, added the provided Mule projects, and pushed to GitHub for ongoing module-by-module changes.
- Added `set-org-id.bat` to quickly swap in your Anypoint Org ID across all POMs (matches the guide’s instruction to update org IDs before Exchange/Maven usage).
- Tagged `WT1-1` to mark the initial setup checkpoint.

## WT1-2 (Docs sync and tagging)
- Added README context tying the repo to the DEX670 Exercise Guide, clarifying the starter assets captured and how to update the Org ID helper.
- Tagged `WT1-2` to mark this documentation/alignment checkpoint before starting Walkthrough 1-2 implementation work.

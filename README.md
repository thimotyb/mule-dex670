# Mule DEX670 Workspace

This repository is my working space for the DEX670 course. I will build the solution incrementally, module by module, across:
- `check-in-papi`: Process API implementation and tests.
- `apps-commons`: Shared Mule components (error handling, health probes).
- `bom` and `parent-pom`: Build/dependency management and deployment defaults.

Each module may evolve as course exercises progress; commits track the incremental steps.

## Notes for Module 1
- Maven WARN about `org.apache.http.client.protocol.ResponseProcessCookies`: comes from HttpClient rejecting an ALB cookie (`AWSALBTGCORS`) with an `Expires` format it dislikes. Harmless; Maven ignores the cookie. Silence per-run with `mvn -Dorg.slf4j.simpleLogger.log.org.apache.http.client.protocol.ResponseProcessCookies=error clean verify` (or set the property in `MAVEN_OPTS` to make it sticky).

## Org ID helper
- Use `set-org-id.bat` to stamp your Anypoint Org ID into all POMs. From repo root: `set-org-id.bat YOUR-ORG-ID` (or run without args to be prompted). It replaces `<groupId>`, `<student.deployment.ap.orgid>`, and `<new.ap.org.id>` UUIDs across `bom`, `parent-pom`, `apps-commons`, `check-in-papi`, `paypal-sapi`, and `flights-management-sapi`.

## WT1-1 (Set up the starter code)
- Based on DEX670 Exercise Guide “Walkthrough 1-1: Set up the starter code”: this repo captures the starter AnyAirline assets (BOM, parent POM, `apps-commons` plugin, and `check-in-papi` process API) ready for incremental work.
- Initialized Git, added the provided Mule projects, and pushed to GitHub for ongoing module-by-module changes.
- Added `set-org-id.bat` to quickly swap in your Anypoint Org ID across all POMs (matches the guide’s instruction to update org IDs before Exchange/Maven usage).
- Tagged `WT1-1` to mark the initial setup checkpoint.

## WT1-2 (Docs sync and tagging)
- Added README context tying the repo to the DEX670 Exercise Guide, clarifying the starter assets captured and how to update the Org ID helper.
- Readiness probe (from the guide’s health walkthrough): `apps-commons` exposes `/alive` and `/ready`; `check-in-papi/src/main/mule/health.xml` imports it and defines `check-all-dependencies-are-alive` (currently a stub `logger`). Replace that stub with real dependency checks as you wire upstream systems—`ready` will fail if any dependency check raises an error.
- Tagged `WT1-2` to mark this documentation/alignment checkpoint before starting Walkthrough 1-2 implementation work.

## WT1-3 (Implement SAPI calls and validations)
- Wired `check-in-by-pnr` to the System APIs per the guide: validate ticket/passport last name alignment via Flights Management SAPI (`get-ticket-by-pnr`) and Passenger Data SAPI (`get-passenger-data-by-passport`); raise `APP:LASTNAME_MISMATCH` on mismatches.
- Implemented downstream calls: update check-ins in Flights Management SAPI, register passenger flight in Passenger Data SAPI, and create a PayPal payment for bags via PayPal SAPI (payloads built in DW, errors mapped to `APP:CANT_*` codes).
- Adjusted `api.xml` error handler to return 400 on last-name mismatch, and promoted HTTP message logging to DEBUG for troubleshooting.
- Readiness probe now calls `/alive` on all three SAPIs to fail fast if dependencies are down.
- Temporarily ignored the happy-path MUnit test pending updated mocks.

## WT1-4 (Enable OAuth client for PayPal SAPI)
- Pulled in the WT1-4 starter for `paypal-sapi` and wired it to our shared BOM/parent; added OAuth and Object Store modules per the guide so PayPal calls use the client-credentials grant instead of failing with 401s.
- Configured `paypalServerHttpRequestConfig` in `src/main/mule/global.xml` to request tokens from the fake PayPal sandbox, caching them in an object store; left the temporary `encrypt.key` default for Studio tooling as directed in the walkthrough.
- Verified the health endpoints and PayPal flows via the provided cURL calls (create/approve payment) now succeed with OAuth; prep work captured in `snippets.txt` for reruns.
- Updated `set-org-id.bat` so the Org ID helper now stamps the new `paypal-sapi` POMs alongside the existing projects.

## WT1-5 (SOAP with mutual TLS for Flights Management SAPI)
- Added the WT1-5 starter for `flights-management-sapi`, which exposes `check-in` and `get-ticket-by-pnr` via SOAP through the Web Service Consumer connector.
- Configured mutual TLS for the downstream Flights Management SOAP service in `src/main/mule/global.xml` using the provided client PKCS#12 keystore and HTTPS request config (`flightsWSTLSContext` and `flightsWSCConfig`).
- Kept APIkit routing and health flows aligned with earlier modules; sample SOAP payload generation and stubs remain in `main.xml` per the guide’s starter.
- Updated `set-org-id.bat` and run-book snippets to include the new SAPI so org IDs and builds stay in sync.

## WT1-6 (Register and receive cancellation callbacks)
- Implemented the HTTP callback walkthrough in `flights-management-sapi`: added `/api/cancelFlight` listener to accept cancellation notifications and a scheduler-driven `register-callback` flow that invokes the SOAP `registerForCancellationNotifications` operation with the configured callback URL.
- Added callback URL pieces to `properties.yaml`/`dev-properties.yaml` so the service registers its CloudHub URL, and captured cURL examples plus Exchange deploy steps in `snippets.txt`.
- **apps-commons build fix:** removing the hard-coded Mule Maven Plugin version and letting the BOM manage it resolved the "bundle cannot be created with null Bundle URI cannot be null" error when building release (non-SNAPSHOT) artifacts.

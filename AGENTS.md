# Session Notes (2025-12-10)
- Workspace structure: `check-in-papi` (process API stub for check-in/payments), `apps-commons` (shared error/health Mule plugin), Maven `bom` (dependency management) and `parent-pom` (build/deploy config).
- `check-in-papi`: RAML `check-in-papi.raml` defines PUT `/tickets/{PNR}/checkin` and `/paymentApproval`; flows in `src/main/mule` are mostly stubs/log/logs returning sample payment ID or boarding pass; `global.xml` sets env/secure props, TLS listener, APIkit config, autodiscovery; `error.xml` imports shared error handling; `health.xml` imports shared health flows.
- `apps-commons`: `error-common.xml` has APIkit error handlers (400, 404, 405, 406, 415, 501); `health-common.xml` exposes `/alive` and `/ready` flows and expects app to define `check-all-dependencies-are-alive` and listener config.
- POMs: `bom/pom.xml` pins Mule runtime/tooling, connector/module versions, and RAML/OAS artifact versions plus Exchange repos; `parent-pom/pom.xml` inherits the BOM and configures Mule Maven plugin (CloudHub2 deployment), MUnit test/coverage, and resource filtering rules.

# Working Method (WT-driven)
- Follow the DEX670 Activity/Exercise Guide (DOCX in `C:\Uploads\DEX670-EN-Exercise-Guide.docx`) step by step. Each walkthrough (WT) is implemented, then documented.
- After completing a walkthrough:
  - Update `README.md` with a new `WTx-y` section summarizing what changed and why.
  - Commit the code changes and README note together.
  - Tag the repo with the walkthrough ID (e.g., `WT1-1`, `WT1-2`, `WT1-3`) and push both commit and tag.
- Keep `AGENTS.md` as the session scratchpad/context, and keep `set-org-id.bat` in sync when new submodules appear.

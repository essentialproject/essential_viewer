# Build Summary: T0 Strategic Plans Roadmap Report

A summary of the main build steps for the T0 Strategic Plans Roadmap report, organised around the prompts that drove each change.

## Setup — MCP server debugging

Before working on the report itself, the essential-view-builder MCP server (used to author these views) was debugged. Two config issues were fixed: an invalid container `--name` value (a full Windows path) and a `--nmae` typo. The Podman image was confirmed to run, and the server connected.

## 1. File rename

**Prompt:** "change the filename of UCL_strategic_plans_t0_roadmap.xsl to UCL_strategic_plan_roadmaps_attibutes.xsl"

Renamed the view file. Later re-done via `git mv` in the correct repo (`essential_viewer`) so Git tracked it as a rename (88% similarity) preserving history, rather than a delete + add.

## 2. Priority column

**Prompt:** "add a column for priority after Plan name... you will find in performance_measures with a start to the string as 'Prioirty of [plan name]'"

Added a Priority column after Plan Name. This went through several refinements as the data details became clearer:

- Initially matched performance measures by prefix and took the first value
- Refined to read the value from the `DSP Priority` service quality specifically
- Dropped the date suffix from matching (it was just a set-time, a red herring)
- **Prompt:** "the data matching strings should be Priority" — corrected the match strings from the misspelled `Prioirty` to the correct `Priority` (`Priority of` and `DSP Priority`)

## 3. Sortable columns

**Prompt:** "add a sort by to the table - with an initial indication of what is being sorted"

Made Plan Name, Priority, Status, Start Date, End Date, and Sponsors clickable to sort. Added an arrow indicator (up/down) on the active column, defaulting to Start Date ascending. Clicking a column toggles direction; clicking a new one sorts ascending.

## 4. Commit/rename workflow

**Prompts:** "commit and push", then the `git mv` rename request, then "commit with message 'added priority column and enabled sorting columns'", then "push to origin"

Handled the Git rename correctly so history was preserved, committed the priority + sorting work, and pushed.

## 5. Impacts enrichment

**Prompt:** "for the impacts can you add the planned change as a value after the risk tech product or application as well as the rationale if it exists"

Changed the impacts data (risks, applications, tech products) from plain name strings to objects carrying `name`, `change` (the planned change action), and `rationale`. The Impacts column now shows the change as a badge and the rationale as secondary text.

## 6. Value highlighting

**Prompt:** "I like the colour highlight on those impact values can you also add to benefits and DSP metrics"

Applied the same `#eedeff` highlight background to the value badges in the Benefits and DSP Metrics columns for consistency.

## 7. Reverted experiment

**Prompts:** "when they appear twice on the roadmap can you make the 2nd, 3rd... instances - faded out?" then "revert that change please"

Added faded/dashed styling for duplicate timeline items (since objective-to-plan is one-to-many), then reverted it fully at your request.

## 8. Navigation links

**Prompt:** "add some links that jump the user to the roadmap or plan details headers"

Added "Jump to Roadmap" and "Jump to Plan Details" anchor links below the page title, with matching `id` attributes on the two section headers.

## 9. Final commit

**Prompt:** "commit and push"

Committed "add planned change and rationale to impacts, highlight values, add jump links" and pushed to `feature/t0-strategic-plans-roadmap`.

---

The report itself is a single XSLT view that transforms the Essential repository XML into an interactive HTML page with three parts: a metrics summary, a vis.js timeline grouped by objective, and a sortable detail table pulling together performance measures, impacts, dependencies, and priority.

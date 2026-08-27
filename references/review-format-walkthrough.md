# Review report format: walkthrough

The report is GitHub-flavored markdown and renders as a PR comment without changes. Severity labels map to the P0-P3 scale: 🔴 Critical is P0, 🟠 Major is P1, 🟡 Minor is P2, 🔵 Trivial is P3. The category label is the axis that produced the finding, with these icons: 🎯 Correctness, 📋 Spec, 📐 Standards, 🧪 Testing, 🧹 Maintainability, 🔒 Security, ⚡ Performance, 🔌 API contract, 🛟 Reliability, 🗄️ Data migration, 💬 Previous comments, 🤖 Agent-native. Add `_⚡ Quick win_` to the header when the fix is a few lines with no design decision.

## 1. Walkthrough

```
<details>
<summary>📝 Walkthrough</summary>

## Walkthrough

One paragraph: what the PR does, in the order a reader meets it.

### Changes

| Layer / File(s) | Summary |
|---|---|
| **<layer name>** <br> `path/a.ts`, `path/b.ts` | One or two sentences on what changed in this group. |

**Estimated code review effort:** <1-5> (<Trivial | Simple | Moderate | Complex | Critical>) | ~<n> minutes

**Axes:** selected <list>; spawned <list>; walked by the reviewer <list>; dropped by gate <list>.

</details>
```

Group files by the layer they belong to (route, component, model, migration, test, config), not by directory listing. Effort: 1 under 10 minutes, 2 under 20, 3 under 45, 4 under 90, 5 over 90.

## 2. Pre-merge checks

```
<details>
<summary>🚥 Pre-merge checks | ✅ <passed> | ❌ <failed></summary>

| Check name | Status | Explanation | Resolution |
|:---:|:---|:---|:---|
| Title check | ✅ Passed / ⚠️ Warning | Does the title say what the diff does? | What to change, when failed. |
| Description check | ... | Does the body state what changed, how it was verified, and what was left out? | |
| Linked issues check | ... | Does the diff close what the linked issue asks for? Skipped when no issue is linked. | |
| Out of scope changes check | ... | Does the diff contain changes the issue did not ask for? Skipped when no issue is linked. | |
| Tests check | ... | Do the changed behaviors have tests, and does the suite pass? | |

</details>
```

## 3. Findings

Heading: `**Actionable comments: <n>**` where n counts Critical, Major, and Minor findings after merging. Then one section per file in path order, findings in line order. One finding per location: when several axes report the same lines or the same defect, the header lists every axis (`_🎯 Correctness_ · _💬 Previous comments_ | _🟠 Major_`), the severity is the highest reported, and there is one explanation, one proposed fix, and one agent prompt.

Each actionable finding:

```
### `path/file.ts:<line or start-end>`

_🎯 Correctness_ | _🟠 Major_ | _⚡ Quick win_

**One sentence stating the defect, as a claim.**

Two to four sentences: what the code does, the input or state that breaks it, what the caller sees. Reference other files by `path:line`.

<details>
<summary>🐛 Proposed fix</summary>

```diff
-old
+new
```

</details>

<details>
<summary>🤖 Prompt for AI Agents</summary>

```
Verify this finding against the current code. Fix it only if still valid, keep the change minimal, and run the tests.

In `path/file.ts` around lines <start>-<end>, <one or two imperative sentences describing the change without restating the diff>.
```

</details>
```

Omit the proposed fix when the fix needs a design decision; say what the decision is instead.

Trivial findings go together at the end:

```
<details>
<summary>🧹 Nitpick comments (<n>)</summary>

<details>
<summary>path/file.ts (<count>)</summary>

`<line>`: _📐 Standards_ | _🔵 Trivial_

**Claim.** One sentence of explanation.

</details>

</details>
```

## 4. Verdict

```
## Verdict: <Approve | Request changes>

| Axis | Worst finding | Count |
|---|---|---|
| Correctness | 🟠 Major, `path/file.ts:42` | 2 |
| Spec | none | 0 |
```

Request changes when any Critical or Major finding exists. Do not rank findings across axes; the table reports each axis on its own, counting a merged finding under every axis that reported it.

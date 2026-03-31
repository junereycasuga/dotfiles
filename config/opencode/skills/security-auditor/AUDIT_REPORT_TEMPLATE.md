# Security Audit Report Template

## Engagement Details

- Project:
- Repository:
- Commit/Branch Audited:
- Audit Date:
- Auditor:
- Scope:
- Out of Scope:

## Executive Summary

- Overall Risk Level: `critical` | `high` | `medium` | `low`
- Key Risks:
  -
  -
  -
- Immediate Actions:
  -
  -

## Methodology

- Approach used (manual review, targeted testing, dependency scan):
- Trust boundaries reviewed:
- Threat scenarios considered:
- Limitations:

## Findings Overview

| ID | Severity | Title | Area | Status |
|---|---|---|---|---|
| F-001 | high | Example finding title | authz | open |

## Detailed Findings

### [F-001] Finding Title

- Severity: `critical` | `high` | `medium` | `low` | `info`
- Confidence: `high` | `medium` | `low`
- Status: `open` | `mitigated` | `accepted risk`
- Affected Component:
- File/Path Reference:
- CWE (if known):

#### Attack Scenario

Describe how an attacker can abuse this issue.

#### Impact

Describe potential business and technical impact.

#### Evidence

- Code reference:
- Reproduction steps:
  1.
  2.
  3.

#### Remediation

- Recommended fix:
- Compensating controls (if full fix is delayed):
- Regression test to add:

#### Verification

- How to verify the fix:
- Validation command(s):

---

### [F-002] Finding Title

- Severity:
- Confidence:
- Status:
- Affected Component:
- File/Path Reference:
- CWE (if known):

#### Attack Scenario

#### Impact

#### Evidence

#### Remediation

#### Verification

## Dependency and Supply Chain Notes

- Vulnerable dependencies identified:
- Risky/unmaintained packages identified:
- Lockfile integrity concerns:
- Recommended upgrades/pinning:

## Positive Security Controls Observed

-
-

## Residual Risk and Follow-Ups

- Accepted risks:
- Deferred fixes with target dates:
- Owner assignments:

## Appendix

### Severity Definitions

- `critical`: likely exploitable now with severe impact; urgent action required.
- `high`: realistic exploit path with meaningful impact.
- `medium`: limited exploitability or partial impact.
- `low`: low-impact or difficult-to-exploit weakness.
- `info`: hardening or best-practice recommendation.

### Quick Checklist

- [ ] Authentication flow reviewed
- [ ] Authorization checks reviewed (including object-level access)
- [ ] Input validation and output encoding reviewed
- [ ] Secrets management and logging reviewed
- [ ] Session/token handling reviewed
- [ ] CORS/CSRF/rate limiting reviewed as applicable
- [ ] Dependency risk reviewed
- [ ] Regression tests proposed or added for key findings

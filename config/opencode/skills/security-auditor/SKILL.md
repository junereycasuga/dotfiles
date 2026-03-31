---
name: security-auditor
description: Perform practical application security audits, identify risks, and recommend actionable fixes.
compatibility: opencode
---

## Overview

Use this skill when auditing code for security vulnerabilities in services, APIs, CLIs, infrastructure glue code, and dependency configuration.

This skill focuses on:
- Finding real, exploitable weaknesses
- Prioritizing by impact and likelihood
- Recommending concrete, low-friction remediations
- Verifying fixes with targeted checks

## Audit Scope

Cover security-relevant areas in priority order:

1. Authentication and authorization
2. Input validation and output encoding
3. Secrets and credential handling
4. Data access boundaries and multi-tenant isolation
5. Dependency and supply-chain risk
6. Error handling, logging, and information disclosure
7. Network/security configuration defaults

## Audit Workflow

1. Map the attack surface:
   - public endpoints, internal APIs, background workers, CLI commands
   - trust boundaries (user input, webhooks, queues, files, env vars)
2. Identify threat paths and abuse cases:
   - privilege escalation, data exfiltration, account takeover, RCE
3. Review implementation details in critical paths.
4. Validate findings with minimal proof-of-concept steps where safe.
5. Produce remediation guidance with severity and confidence.

## What to Look For

### Access Control

- Missing object-level authorization checks (IDOR/BOLA).
- Role checks done only in UI but not server side.
- Overly broad tokens/permissions.

### Injection and Input Risks

- SQL/NoSQL/command/template injection patterns.
- Unsafe deserialization and dynamic code execution.
- Path traversal and archive extraction issues.

### Auth and Session

- Weak password/session/token handling.
- Missing token expiry/rotation/invalidation logic.
- Insecure cookie/session settings.

### Crypto and Secrets

- Hardcoded secrets, keys, and credentials.
- Weak crypto primitives or improper mode/nonce usage.
- Missing at-rest or in-transit protection where expected.

### Web and API Security

- Missing CSRF protections where state-changing browser endpoints exist.
- CORS misconfiguration (wildcards with credentials, broad origins).
- Missing rate limiting or abuse controls on sensitive endpoints.

### Reliability-to-Security Gaps

- Silent failure paths that bypass checks.
- Insecure fallback behavior after errors/timeouts.
- Excessive data in error messages and logs.

## Dependency and Supply Chain Review

- Check for vulnerable direct and transitive dependencies.
- Flag unmaintained or suspicious packages in critical paths.
- Verify lockfile integrity and least-privilege install/runtime assumptions.
- Prefer minimal dependency additions for fixes.

## Severity Model

Rate findings with concise rationale:

- `critical`: likely exploitable, high business impact, immediate action
- `high`: realistic exploit path with meaningful impact
- `medium`: constrained exploitability or partial impact
- `low`: hard to exploit or defense-in-depth issue
- `info`: improvement opportunity or hardening note

For each finding include:
- affected component/path
- attack scenario
- impact
- evidence
- remediation steps
- confidence (`high`, `medium`, `low`)

## Remediation Guidance

- Prefer fixes that enforce security at the boundary layer.
- Add automated tests that reproduce and prevent regressions.
- Propose staged mitigations when full fixes are large.
- Highlight backward-compatibility or rollout risks.

## Reporting Output

When delivering audit results, use the standard template at:
- `config/opencode/skills/security-auditor/AUDIT_REPORT_TEMPLATE.md`

Prefer filling this template completely so findings are consistent, comparable, and actionable.

## Safe Operating Rules

- Do not exfiltrate, print, or store secrets.
- Do not run destructive or production-impacting exploit attempts.
- Use least-invasive validation for proof of risk.
- Escalate immediately if active credential leakage is discovered.

## When to Use This Skill

Use this skill when tasks involve:
- Security reviews before release
- Investigating suspected vulnerabilities
- Hardening authentication/authorization and data handling
- Evaluating dependency security and supply-chain posture

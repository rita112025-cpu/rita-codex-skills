---

name: security
description: Review security before and after changes involving authentication, authorization, APIs, tokens, secrets, credentials, external input, network access, CI/CD, GitHub Actions, browser-side data, dependencies, file access, command execution, or other security-sensitive boundaries. Use when AGENTS.md or the user requires a security review or security gate.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Security Review

Perform a focused security review before security-sensitive changes and verify the result again after implementation.

## Core Rules

* Base findings only on code, files, configuration, commands, or behavior actually inspected.
* Distinguish confirmed findings from assumptions.
* Do not claim a vulnerability exists without evidence.
* Never expose, print, commit, transmit, or copy secrets unnecessarily.
* Do not weaken existing security controls merely to simplify implementation.
* Prefer least privilege.
* Do not block implementation for speculative or low-confidence concerns.
* If a concern cannot be verified, explicitly mark it as not verified.

## Trigger Conditions

Run this skill when work involves:

* authentication or login;
* authorization or permissions;
* APIs or webhooks;
* tokens, API keys, credentials, cookies, sessions, or secrets;
* GitHub Actions, CI/CD, deployment, or automation credentials;
* network requests;
* external or user-controlled input;
* JSON or other remotely sourced data;
* browser rendering of external data;
* file-system access or path handling;
* shell commands, subprocesses, interpreters, or code execution;
* dependencies or third-party GitHub Actions;
* uploads, downloads, archives, or temporary files;
* CORS, CSP, CSRF, SSRF, XSS, injection, or similar trust-boundary issues.

# Phase 1 — Pre-Implementation Security Gate

Inspect the relevant implementation before modifying it.

## Secrets and Credentials

Check whether the proposed design could expose:

* API keys;
* personal access tokens;
* OAuth credentials;
* passwords;
* private keys;
* session secrets;
* authorization headers;
* `.env` contents;
* CI/CD secrets.

Secrets must not be embedded in:

* browser JavaScript;
* static HTML;
* public JSON;
* committed configuration;
* logs;
* screenshots;
* generated reports;
* other public artifacts.

For GitHub Actions, prefer the built-in `GITHUB_TOKEN` when it provides sufficient capability.

## Authentication and Authorization

When authentication or authorization is involved, verify:

* authentication and authorization are treated separately;
* server-side authorization exists where required;
* client-side checks are not treated as access control;
* permissions are no broader than necessary;
* privileged actions cannot be reached merely by modifying client-controlled values.

## External Input

Treat all external data as untrusted.

Check for:

* missing type or schema validation;
* path traversal;
* command or argument injection;
* SQL or query injection;
* HTML or script injection;
* unsafe URL handling;
* unsafe deserialization;
* unexpectedly large input.

When rendering external text in a browser, prefer safe DOM APIs such as `textContent`.

Do not use `innerHTML` with untrusted content unless sanitization is explicit and verified.

## API and Network Access

Check:

* whether authentication is actually required;
* whether credentials would be exposed client-side;
* request rate limits;
* timeouts;
* retries;
* error handling;
* HTTPS usage;
* response validation;
* whether failed requests can overwrite valid state.

Do not introduce a browser-side secret merely to avoid an API rate limit.

## GitHub Actions and CI/CD

Review workflows for:

* minimum required `permissions`;
* secret exposure;
* unsafe logging;
* untrusted pull-request input;
* unsafe command interpolation;
* unnecessary write access;
* unnecessary third-party Actions.

Default to read-only permissions when possible:

```yaml
permissions:
  contents: read
```

Increase permissions only when the workflow demonstrably requires them.

If generated data must be committed, grant only the specific required write permission and document why.

Never expose secrets to workflows executing untrusted code.

## Dependencies and Supply Chain

Before adding a dependency or third-party Action:

* confirm it is necessary;
* verify its source;
* prefer standard-library or platform functionality when sufficient;
* avoid introducing large dependencies for trivial tasks;
* do not silently substitute unrelated packages.

## Persistence and Failure Handling

For generated data, caches, snapshots, or synchronized state:

* preserve the last known-good state when practical;
* validate new data before replacing valid data;
* avoid partially written output;
* prevent temporary upstream failure from causing permanent data loss.

# Security Gate Result

Before implementation, return exactly one result.

## PASS

No confirmed security issue prevents implementation.

Continue with the requested work.

## WARN

A confirmed concern exists but does not justify blocking implementation.

State:

* concern;
* evidence;
* mitigation.

Then continue.

## BLOCK

Stop only when there is a concrete high-impact issue, such as:

* a secret would be exposed publicly;
* authentication or authorization would be bypassed;
* destructive access outside the intended scope would be possible;
* arbitrary command or code execution would be introduced without an appropriate trust boundary;
* required credentials cannot be handled safely;
* implementation requires intentionally disabling an existing security control without authorization.

State the evidence and the minimum change needed to unblock implementation.

Do not use `BLOCK` for speculative risks.

# Phase 2 — Post-Implementation Verification

After implementation, inspect the actual diff and relevant resulting files.

Verify:

* no secret was committed;
* no secret appears in browser-delivered assets;
* no authorization control was unintentionally removed;
* external data is validated;
* external browser text is rendered safely;
* permissions follow least privilege;
* errors do not expose credentials or sensitive internals;
* failure handling preserves valid state where required;
* added dependencies or Actions are necessary and expected;
* implemented security behavior matches the intended architecture.

Run existing repository tests, linters, validation scripts, or security checks when available.

Do not report a check as passed unless it was actually run or directly verified.

# Required Report

Return a concise result in this format:

```text
Security review: PASS | WARN | BLOCK

Confirmed:
- ...

Warnings:
- ...

Verification:
- check: result
- check: result

Not verified:
- ...
```

Omit empty optional sections.

Never invent findings merely to populate the report.

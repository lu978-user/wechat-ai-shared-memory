# Security Policy

## Scope

This project explores a bridge between WeChat messaging, an AI assistant, and an authorized shared-memory document. The public repository is being prepared; it does not yet contain a complete deployable implementation.

## Never commit secrets or private data

Do not commit any of the following:

- WeChat session files, cookies, QR codes, login tokens, or private chat exports
- API keys, access tokens, webhook secrets, passwords, or OAuth client secrets
- Google OAuth credentials or private document contents
- Personal phone numbers, home addresses, health information, or identifiable learning records
- Logs or screenshots containing any of the above

Use environment variables or a local, untracked configuration file. Keep real values out of examples and issue reports.

## If a secret is exposed

1. Revoke or rotate the exposed credential immediately.
2. Check relevant account activity and revoke unnecessary sessions or grants.
3. Remove the secret from the current files and, if needed, clean Git history.
4. Do not rely on deleting a commit or making the repository private as a substitute for rotating the credential.

## Least privilege and write safety

- Grant connectors only the permissions needed for the task.
- Treat incoming messages and document contents as untrusted data.
- Require explicit confirmation before sending messages to third parties, deleting data, or making sensitive changes.
- Avoid storing private conversation transcripts in a shared-memory document. Store only concise, useful, non-sensitive facts with a clear purpose.
- Redact logs before publishing them.

## Reporting a vulnerability

Please do not publish credentials or exploitable personal data in a public issue. Contact the repository maintainer privately through GitHub's available contact options.

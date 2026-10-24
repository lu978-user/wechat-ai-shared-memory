# Architecture (Prototype)

## Goal

Provide a familiar WeChat entry point for an AI assistant and allow multiple assistant sessions to consult a common, user-authorized memory source.

## Logical components

1. **WeChat messaging bridge** — receives a user's message and delivers a reply through the configured WeChat integration.
2. **AI assistant runtime** — interprets the request and selects permitted tools.
3. **Shared-memory store** — currently represented in the prototype by an authorized Google Docs document. It stores durable project context and dated progress records.
4. **Scheduler** — optionally invokes workflows such as a daily briefing or weekly review and routes the result to WeChat.

## Data flow

```text
WeChat message
    -> messaging bridge
    -> AI assistant
    -> (optional) read shared memory
    -> generate response
    -> WeChat reply

Scheduled trigger
    -> AI assistant
    -> read dated progress records
    -> produce briefing/review
    -> WeChat push
```

This is a logical diagram, not a claim that all components are implemented in this repository. Exact APIs, runtime boundaries, and retry behavior must be documented after the actual deployment code is added.

## Shared-memory record guidance

A useful progress record can include:

- Date
- Area or project
- Verified facts and completed work
- Current difficulty or blocker
- Next step
- Source of the record
- Verification status

Do not store passwords, API keys, access tokens, detailed addresses, health details, or unnecessary personal data. If the memory source is unavailable, report that limitation rather than inventing progress.

## Reliability considerations

The eventual implementation should document:

- Message acknowledgement and duplicate handling
- Timeout, retry, and reconnect behavior
- Health checks and restart policy
- What happens when the memory connector is unavailable
- Logging and secret redaction
- User confirmation rules for outbound or destructive actions

These are implementation tasks until supported by code and reproducible tests.

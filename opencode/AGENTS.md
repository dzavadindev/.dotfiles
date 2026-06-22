Here are some general rules regarding tool use and style:

## Context7 — Documentation Lookup Rule

Purpose:
Ensure all agents use up-to-date, authoritative documentation when answering questions about external tools, libraries, or frameworks.

When to use Context7:

* The question involves a library, framework, API, CLI tool, or package
* The answer may depend on current or version-specific behavior
* The user asks about:

  * installation or setup steps
  * configuration or syntax
  * API usage (functions, parameters, return values)
  * feature availability or changes between versions
  * official examples or recommended patterns

Behavior:

* Use Context7 to retrieve relevant documentation **before answering**
* Prefer Context7 results over model memory for accuracy
* Summarize and explain the documentation clearly; do not dump raw output

When NOT to use Context7:

* Explaining user-provided code or internal project logic
* General programming concepts (e.g., “what is a mutex”)
* Opinion-based comparisons unless docs are required

Failure handling:

* If Context7 returns no useful result:

  * clearly state that documentation lookup failed or was insufficient
  * proceed with a cautious answer based on general knowledge
  * avoid guessing exact syntax or version-specific details

Safety:

* Never send:

  * private source code
  * secrets, tokens, or credentials
  * internal file paths or logs
* Only query public, non-sensitive topics

Style:

* Integrate documentation naturally into the answer
* Keep responses concise and practical
* Highlight version-specific details when relevant

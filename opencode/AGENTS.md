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

<!-- context7 -->
Use Context7 MCP to fetch current documentation whenever the user asks about a library, framework, SDK, API, CLI tool, or cloud service — even well-known ones like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. This includes API syntax, configuration, version migration, porting code between libraries, platforms, or SQL dialects, library-specific debugging, setup instructions, and CLI tool usage. Use even when you think you know the answer — your training data may not reflect recent changes. Prefer this over web search for library docs.

Do not use for: refactoring, debugging, or reviewing code that does not depend on a library or platform API, or general programming concepts.

## Steps

1. Always start with `resolve-library-id` using the library name and what to look up in the library's documentation, unless the user provides an exact library ID in `/org/project` format
2. Pick the best match (ID format: `/org/project`) by: exact name match, description relevance, code snippet count, source reputation (High/Medium preferred), and benchmark score (higher is better). If results don't look right, try alternate names or queries (e.g., "next.js" not "nextjs", or rephrase the question). Use version-specific IDs when the user mentions a version
3. `query-docs` with the selected library ID and what to look up in the library's documentation (not single words), scoped to a single concept. If the question spans multiple distinct concepts (e.g. routing and auth and caching), make a separate `query-docs` call per concept with the same library ID, unless the question is about how the concepts interact — combined queries dilute ranking and return shallow results for each topic
4. Answer using the fetched docs
<!-- context7 -->

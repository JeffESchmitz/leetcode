# Editing Discipline for Existing Code

Rules for modifying files that already exist in this repository.

## Never rewrite wholesale

*   **Do NOT replace the full contents of an existing solution or test file**
    with a freshly generated version. Make targeted, minimal edits to the code
    that is already there.
*   Preserve the existing style, naming, structure, and comments unless the
    user explicitly asks to change them. If the current code already solves the
    problem, do not re-solve it — propose improvements and let the user decide.
*   When pasting a revised function, replace the old implementation **exactly
    and completely** — never leave fragments of the previous version behind.

## Leave the file compiling

*   Read the entire file before editing it.
*   After any edit, run the leaf's test command (see `project_structure.md`)
    and confirm the code compiles and all tests pass before finishing.
*   Never end a task with a file in a broken or partially edited state.

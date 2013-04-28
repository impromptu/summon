# Summon

Summon is a command line script to help install external dependencies. It's written in Node (via CoffeeScript).

## Hacking

Keep changes to the `summon` executable in their own commits. The easiest way to do that is to use the pre-commit hook in `/scripts/git/pre-commit`. You can set it up automatically by running `./scripts/bootstrap`. The hook will make sure that you don't accidentally commit changes to the `summon` executable along with any other changes.

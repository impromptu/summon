# Summon

Summon is a command line script to help install external dependencies. It's intended use case is when your project relies on dependencies that it cannot declare in its own package installer. For example, if your Node project requires Redis, you need the user to install Redis on their own. Summon's goal is to allow you to script that dependency so that the user doesn't have to think about the installation (much).

Summon written in Node (via CoffeeScript).

## Hacking

Keep changes to the `summon` executable in their own commits. The easiest way to do that is to use the pre-commit hook in `/scripts/git/pre-commit`. You can set it up automatically by running `./scripts/bootstrap`. The hook will make sure that you don't accidentally commit changes to the `summon` executable along with any other changes.

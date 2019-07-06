# Git "Safe to Delete" Utility

A utility for validating that a git repository is "safe to delete", that all local changes have been pushed to the remote repository.

## Rationale and requirements

I work in a lot of git repositories simultaneously. When I'm working from my typical location, this is easy to manage. But I occasionally travel. When I travel, I sometimes need to work on something that I forgot to push to the remote repo before I left. This means either I cannot work on that until I return or I have to redo the work as best as I can. The same problem happens when rebuilding a computer or moving to a new one.

This utility aims to solve the above problem by verifying that a local repository:

1. Has no uncommitted files (whether modified, staged, or untracked)
1. Has no stashed changes
1. Has no branch that is "ahead" any number of commits

By verifying the above, it means that there is no information that can be lost if the local repository was deleted.

## License

[MIT](LICENSE.md)

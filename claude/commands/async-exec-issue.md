GitHubのIssueの内容を確認し、非同期でClaude Codeを実行する処理を行なってください。
実行する処理のステップは以下のとおりです。

## git-worktreeの準備
以下のステップでgit-worktreeを準備してください。

1. !`git checkout main`
2. !`git pull origin main`
3. !`mkdir -p .git/worktrees`
4. !`git worktree add .git/worktrees/claude-issue-$ARGUMENTS -b claude-issue-$ARGUMENTS`
5. !`cp .env .git/worktrees/claude-issue-$ARGUMENTS/.env`

## Claude Codeの非同期実行
以下の処理を実行して、Claude Codeを非同期で実行してください。

!```
cd .git/worktrees/claude-issue-$ARGUMENTS
( { claude --dangerously-skip-permissions -p "
!`gh issue view $ARGUMENTS` でGitHubのIssueの内容を確認し、タスクの遂行を行なってください。
タスクは以下の手順で進めてください。

1. Issueに記載されている内容を理解する
2. Issueの内容を実現するために必要なタスクをTDD（テスト駆動開発）に基づいて遂行する
3. テストとLintを実行し、すべてのテストが通ることを確認する
4. コミットを適切な粒度で作成する
5. 以下のルールに従ってPRを作成する
    - PRのdescriptionのテンプレートは @.github/PULL_REQUEST_TEMPLATE.md を参照し、それに従うこと
    - PRのdescriptionのテンプレート内でコメントアウトされている箇所は必ず削除すること
    - PRのdescriptionには`Closes #$ARGUMENTS`と記載すること
" } &; ) > /dev/null
```

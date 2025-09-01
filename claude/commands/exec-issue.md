GitHubのIssueの内容を確認し、タスクを実行する処理を行なってください。
実行する処理のステップは以下のとおりです。

## git-worktreeの準備
以下のステップでgit-worktreeを準備してください。

1. !`gh issue view $ARGUMENTS` でGitHubのIssueの内容を確認する
2. mainにチェックアウトし、pullを行い、最新のリモートの状態を取得する
3. !`mkdir -p .git-worktrees` でworktree用のディレクトリを作成する
4. Issueの内容を元に、適切な命名でブランチでworktreeを作成する
    - worktreeは`.git-worktrees`ディレクトリに作成してください
    - ブランチ名には`/`を含めないでください
5. `.env`ファイルを作成したworktreeにコピーする
6. `cd`コマンドで作成したworktreeに移動する
7. 移動したworktree内でSerenaのアクティベートとオンボーディングを実施する
8. 環境ごとに必要なセットアップ(nodeであればnpm installなど)を実行して、必要なパッケージをインストールする

## Issueの内容確認とタスク遂行
タスクは以下の手順で進めてください。
なお、タスクはすべて作成したworktree内で行います。
作成したworktree以外の場所で作業を行わず、コードの変更も行わないでください。
`cd`コマンドを利用する場合は`pwd`コマンドで現在のディレクトリを確認し、作成したworktree内であることを確認してください。

1. Issueに記載されている内容を理解する
2. Issueの内容を実現するために必要なタスクをTDD（テスト駆動開発）に基づいて遂行する
3. テストとLintを実行し、すべてのテストが通ることを確認する
4. コミットを適切な粒度で作成する
5. 以下のルールに従ってPRを作成する
    - PRのdescriptionのテンプレートは @.github/PULL_REQUEST_TEMPLATE.md を参照し、それに従うこと
    - PRのdescriptionのテンプレート内でコメントアウトされている箇所は必ず削除すること
    - PRのdescriptionには`Closes #$ARGUMENTS`と記載すること
6. `docker compose down`を実行して、使用したコンテナを停止する

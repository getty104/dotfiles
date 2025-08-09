Resolveしていないレビューコメントの指摘内容へ対応して下さい。
実行する処理のステップは以下のとおりです。

## git-worktreeの準備
以下のステップでgit-worktreeを準備してください。

1. `git checkout main`
2. `git pull origin main`
3. `git fetch`
4. `mkdir -p .git-worktrees`
5. `WORKTREE_NAME=$(echo "$ARGUMENTS" | tr '/' '-')`でworktree名を準備する
6. `git worktree list`で`$WORKTREE_NAME`という名前のworktreeが存在するかを確認する
7. worktreeが存在しない場合は、`git worktree add .git-worktrees/$WORKTREE_NAME $ARGUMENTS` で新しいworktreeを作成する
    - `.env`ファイルを作成したworktreeにコピーする
8. 作成したworktreeに移動するために、`cd .git-worktrees/$WORKTREE_NAME`を実行する
9. 環境ごとに必要なセットアップ(nodeであればnpm installなど)を実行して、必要なパッケージをインストールする

## レビューコメントの確認とタスクの遂行
以下の手順でタスクを遂行してください。
なお、タスクはすべて作成したworktree内で行います。
作成したworktree以外の場所で作業を行わず、コードの変更も行わないでください。
`cd`コマンドを利用する場合は`pwd`コマンドで現在のディレクトリを確認し、作成したworktree内であることを確認してください。

1. 「レビューコメントの確認方法」に記載のコマンドを用いて、Resolveしていないレビューコメントを確認する
2. Resolveしていないレビューコメントの内容を理解する
3. 指摘内容を実現するために必要なタスクをTDD（テスト駆動開発）に基づいて遂行する
4. テストとLintを実行し、すべてのテストが通ることを確認する
5. コミットを適切な粒度で作成する
6. 修正内容をすでに作成している適切なコミットにsquashし、pushする
7. PRのdescriptionを確認し、必要があればdescriptionを修正する
8. `docker compose down`を実行して、使用したコンテナを停止する

### レビューコメントの確認方法
以下のコマンドでResolveしていないレビューコメントを取得できます。

!```
OWNER_REPO=$(gh repo view --json nameWithOwner --jq '.nameWithOwner')
OWNER=$(echo $OWNER_REPO | cut -d'/' -f1)
REPO=$(echo $OWNER_REPO | cut -d'/' -f2)
PR_NUMBER=$(gh pr view --json number --jq '.number')

gh api graphql -f query="
query {
  repository(owner: \"${OWNER}\", name: \"${REPO}\") {
    pullRequest(number: ${PR_NUMBER}) {
      number
      title
      url
      state
      author {
        login
      }
      reviewRequests(first: 100) {
        nodes {
          requestedReviewer {
            ... on User {
              login
            }
          }
        }
      }
      reviewThreads(last: 100) {
        edges {
          node {
            isResolved
            isOutdated
            path
            line
            comments(last: 100) {
              nodes {
                author {
                  login
                }
                body
                url
                createdAt
              }
            }
          }
        }
      }
    }
  }
}" --jq '
  .data.repository.pullRequest as $pr |
  {
    pr_number: $pr.number,
    title: $pr.title,
    url: $pr.url,
    state: $pr.state,
    author: $pr.author.login,
    requested_reviewers: [.data.repository.pullRequest.reviewRequests.nodes[].requestedReviewer.login],
    unresolved_threads: [
      $pr.reviewThreads.edges[] |
      select(.node.isResolved == false and .node.isOutdated == false) |
      {
        path: .node.path,
        line: .node.line,
        is_outdated: .node.isOutdated,
        comments: [
          .node.comments.nodes[] |
          {
            author: .author.login,
            body: .body,
            url: .url,
            created_at: .createdAt
          }
        ]
      }
    ]
  }
'
```

Resolveしていないレビューコメントの指摘内容へ対応して下さい。
実行する処理のステップは以下のとおりです。

## git-worktreeの準備
以下のステップでgit-worktreeを準備してください。

1. `git checkout main`
2. `git pull origin main`
3. `git fetch`
4. `mkdir -p .git-worktrees`
5. `WORKTREE_NAME="$(echo "$ARGUMENTS" | tr '/' '-')"`でworktree名を準備する
6. `git worktree list`で`$WORKTREE_NAME`という名前のworktreeが存在するかを確認する
7. worktreeが存在しない場合は、`git worktree add .git-worktrees/$WORKTREE_NAME $ARGUMENTS` で新しいworktreeを作成する
    - `.env`ファイルを作成したworktreeにコピーする
8. 作成したworktreeに移動するために、`cd .git-worktrees/$WORKTREE_NAME`を実行する
9. 移動したworktree内でSerenaのアクティベートを行い、`cp -r ../../.serena/memories .serena/memories`を実行後、オンボーディングを実施する
10. 環境ごとに必要なセットアップ(nodeであればnpm installなど)を実行して、必要なパッケージをインストールする

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
7. 対応したレビューコメントを「レビューコメントをResolveする方法」に記載のコマンドを用いてResolveする
8. `/gemini review`というコメントをPRに追加して、再度レビューを依頼する
9. PRのdescriptionを確認し、必要があればdescriptionを修正する
10. `docker compose down`を実行して、使用したコンテナを停止する

### レビューコメントの確認方法
以下のコマンドでResolveしていないレビューコメントを取得できます。

!```
OWNER_REPO="$(gh repo view --json nameWithOwner --jq '.nameWithOwner')"
OWNER="$(echo $OWNER_REPO | cut -d'/' -f1)"
REPO="$(echo $OWNER_REPO | cut -d'/' -f2)"
PR_NUMBER="$(gh pr view --json number --jq '.number')"

fetch_all_review_threads() {
  local cursor="null"
  local has_next_page=true
  local temp_dir=$(mktemp -d)
  local page_num=0

  while [ "$has_next_page" = "true" ]; do
    gh api graphql -f query="
query(\$cursor: String) {
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
      reviewThreads(first: 100, after: \$cursor) {
        pageInfo {
          hasNextPage
          endCursor
        }
        edges {
          node {
            id
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
}" -f cursor="$cursor" > "${temp_dir}/page_${page_num}.json"

    has_next_page=$(jq -r '.data.repository.pullRequest.reviewThreads.pageInfo.hasNextPage' "${temp_dir}/page_${page_num}.json")
    cursor=$(jq -r '.data.repository.pullRequest.reviewThreads.pageInfo.endCursor' "${temp_dir}/page_${page_num}.json")
    page_num=$((page_num + 1))
  done

  jq -s '
    .[0].data.repository.pullRequest as $first_pr |
    {
      pr_number: $first_pr.number,
      title: $first_pr.title,
      url: $first_pr.url,
      state: $first_pr.state,
      author: $first_pr.author.login,
      requested_reviewers: [$first_pr.reviewRequests.nodes[].requestedReviewer.login],
      unresolved_threads: [
        .[].data.repository.pullRequest.reviewThreads.edges[] |
        select(.node.isResolved == false and .node.isOutdated == false) |
        {
          thread_id: .node.id,
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
  ' "${temp_dir}"/page_*.json

  rm -rf "$temp_dir"
}

fetch_all_review_threads
```

### レビューコメントをResolveする方法
以下のコマンドでResolveしていないレビューコメントをResolveできます。
`{thread_id}`の部分は、上記のコマンドで取得したレビューコメントの`thread_id`に置き換えてください。

```
gh api graphql -f query='
mutation {
    resolveReviewThread(input: {threadId: "{thread_id}"}) {
    thread {
        isResolved
    }
    }
}'
```

Resolveしていないレビューコメントの指摘内容へ対応して下さい。

## 進め方の手順

1. 次項の記載のコマンドを用いて、Resolveしていないレビューコメントを確認する
2. Resolveしていないレビューコメントの内容を理解する
3. 指摘内容を実現するために必要なタスクをTDD（テスト駆動開発）に基づいて遂行する
4. テストとLintを実行し、すべてのテストが通ることを確認する
5. コミットを適切な粒度で作成する
6. 修正内容をすでに作成している適切なコミットにsquashする
7. PRのdescriptionを更新する
8. `afplay /System/Library/Sounds/Funk.aiff` を実行してタスク完了を通知する

## ghコマンド
以下のコマンドでResolveしていないレビューコメントを取得できます。

```bash
gh api graphql -f query='
query FetchReviewComments($owner: String!, $repo: String!, $number: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      number
      title
      url
      state
      author {
        login
      }
      reviewRequests(first: 20) {
        nodes {
          requestedReviewer {
            ... on User {
              login
            }
          }
        }
      }
      reviewThreads(last: 20) {
        edges {
          node {
            isResolved
            isOutdated
            path
            line
            comments(last: 20) {
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
}' \
-f owner="OWNER" \
-f repo="REPO" \
-F number="PR_NUMBER" \
--jq '
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
      select(.node.isResolved == false) |
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

OWNER, REPO, PR_NUMBERは以下のコマンドで取得して下さい。

OWNER/REPO: `gh repo view --json nameWithOwner --jq '.nameWithOwner'`
PR_NUMBER: `gh pr view --json number --jq '.number'`

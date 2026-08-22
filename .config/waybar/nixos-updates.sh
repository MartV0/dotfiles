commit=$(nixos-version --json | jq -r .nixpkgsRevision)
nixos_version=$(nixos-version --json | jq -r .nixosVersion | sed -r 's/(.*)\.[^.]*\.[^.]*$/\1/')

branch_info=$(curl -L -s \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  https://api.github.com/repos/nixos/nixpkgs/branches/nixos-$nixos_version)

commit_info=$(curl -L -s \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  https://api.github.com/repos/nixos/nixpkgs/commits/$commit)

current_commit=$(echo $branch_info | jq -r .commit.sha)
if [[ $current_commit != $commit ]]; then
  commit_date=$(echo $commit_info | jq -r .commit.committer.date)
  commit_date_branch=$(echo $branch_info | jq -r .commit.commit.committer.date)

  commit_epoch=$(date -d $commit_date +%s)
  commit_date_epoch=$(date -d $commit_date_branch +%s)

  days_difference=$(( ($commit_date_epoch - $commit_epoch) / (24*60*60) ))

  echo $days_difference
fi

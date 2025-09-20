#!/usr/bin/env bash

echo "Repo:   $1"
cd "$1" || exit

echo "Branch: $(git rev-parse --abbrev-ref HEAD)"

echo
echo "=== Status ==="
git status -s

echo
echo "=== Commit Difference (Behind/Ahead) ==="
git rev-list --left-right --count origin/$(git rev-parse --abbrev-ref HEAD)...HEAD 2>/dev/null | awk '{print "Behind:", $1, "Ahead:", $2}'

echo
echo "=== Recent Commits ==="
git log --graph --date=short --pretty=format:"%ad | %s [%an]" -n 5

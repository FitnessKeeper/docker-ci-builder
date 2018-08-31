#!/bin/sh

if [[ "$1" = "-d" || "$1" = "--debug" ]] ; then
  DEBUG=true
fi

[[ $DEBUG ]] && git log -4 --graph --date-order | cat

for commit in $(git log -10 --pretty=format:"%H"); do
  [[ $DEBUG ]] && echo "$commit starting processing"
  if [[ "$mergecommit" ]] ; then
    gitdiff=$(git diff $commit | grep . > /dev/null; echo $?)
    if [[ $gitdiff = 0 ]] ; then
      [[ $DEBUG ]] && echo "$mergecommit was a non-ff merge, can't skip" >&2
      commit=$mergecommit
      break
    else
      [[ $DEBUG ]] && echo "$mergecommit was a ff merge, skipping" >&2
      mergecommit=""
    fi
  fi
  ismerge=$(git show --no-patch --format="%P" $commit | grep ' ' > /dev/null; echo $?)
  if [[ $ismerge = 0 ]] ; then
    hasdiff=$(git log -1 --cc --format=''|grep . > /dev/null; echo $?)
    if [[ $hasdiff = 0 ]] ; then
      [[ $DEBUG ]] && echo "$commit was a merge and contains merge conflicts" >&2
      break
    else
      mergecommit=$commit
      [[ $DEBUG ]] && echo "$mergecommit had no merge conflicts, considering skipping" >&2
      continue
    fi
    continue
  else
    break
  fi
done

printf $commit
exit 0

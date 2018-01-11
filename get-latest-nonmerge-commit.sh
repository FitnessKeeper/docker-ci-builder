#!/bin/sh

if [[ "$1" = "-d" || "$1" = "--debug" ]] ; then
  DEBUG=true
fi

for commit in $(git log -10 --pretty=format:"%H"); do
  ismerge=$(git show --no-patch --format="%P" $commit | grep ' ' > /dev/null; echo $?)
  if [[ $ismerge = 0 ]] ; then
    hasdiff=$(git log -1 --cc --format=''|grep . > /dev/null; echo $?)
    if [[ $hasdiff = 0 ]] ; then
      [[ $DEBUG ]] && echo "$commit was a merge and contains merge conflicts" >&2
      break
    else
      [[ $DEBUG ]] && echo "$commit was a merge, and had no merge conflicts, skipping" >&2
    fi
    continue
  else
    break
  fi
done

echo $commit
exit 0

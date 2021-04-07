echo $1 price is being retrieved
while [ 1 ]; do
  echo $1 is at \$%{T2}$(curl --silent https://terminal-stocks.herokuapp.com/$1 | sed -n '5s/│[^│]*│\([^│]*\).*/\1/p' | sed -e "s/\x1b\[.\{1,5\}m//g" | xargs)%{T-}
  sleep 5
done


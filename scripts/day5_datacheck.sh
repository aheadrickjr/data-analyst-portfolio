# how many lines are in the CSV?
wc -l datasets/ecommerce_sales.csv

# show the first 3 data lines (after the header)
tail -n +2 datasets/ecommerce_sales.csv | head -n 3 | sed -e 's/,/ [,] /g' -e 's/;/ [;] /g' -e 's/|/ [|] /g' -e 's/\t/ [TAB] /g'

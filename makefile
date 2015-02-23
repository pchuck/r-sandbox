# r development
#

# tmux a complete r environment
create_env:
	scripts/r-dev-tmux.sh work r-dev

# start r
start_console:
	r

## r scripts

# find top s&p 500 constituents by specified facet
#
facet_ebitda:
	Rscript facet_sp500.R EBITDA true true

facet_marketcap:
	Rscript facet_sp500.R Market.Cap true false

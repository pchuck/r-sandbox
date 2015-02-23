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
facet:
	Rscript facet_sp500.R EBITDA 

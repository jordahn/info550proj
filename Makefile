africa_trade_report: Rmd/africa_trade_report.Rmd Figs/trade_network.html
	Rscript -e "rmarkdown::render('Rmd/africa_trade_report.Rmd')"

trade_network.html: data/africatradedata.csv R/tradenetwork.R
	Rscript R/tradenetwork.R


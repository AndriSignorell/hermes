

Rcpp::compileAttributes()
devtools::clean_dll()
devtools::document()
devtools::check()
devtools::install()
devtools::build_manual(pkg = "C:/temp/DescToolsX")
devtools::build_manual(pkg = "C:/temp/lumen")
devtools::build_manual(pkg = "C:/temp/lyra")
devtools::build_manual(pkg = "C:/temp/bedrock")


devtools::document()
devtools::load_all()


devtools::check()


install.packages("remotes")
remotes::install_github("omegahat/RDCOMClient")


hermes:::dlgBookmark()

xlView(mtcars)
mtcars

dat <- data.frame(chars=c("some text", 
                          "with also äoöie", 
                          "c'est la çédile"), 
                  vals=runif(3))


dat

xlView(dat)


library(hermes)
library(RDCOMClient)
getWrdHwnd()

debug(hermes:::getWrdHwnd)


---

editor_options: 
  markdown: 
    wrap: 72
---

<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![CRAN status](https://www.r-pkg.org/badges/version-last-release/hermes)](https://CRAN.R-project.org/package=hermes) [![downloads](https://cranlogs.r-pkg.org/badges/grand-total/hermes)](https://CRAN.R-project.org/package=hermes) [![downloads](http://cranlogs.r-pkg.org/badges/last-week/hermes)](https://CRAN.R-project.org/package=hermes) [![License: GPL v2+](https://img.shields.io/badge/License-GPL%20v2+-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html) [![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html) [![R build status](https://github.com/AndriSignorell/hermes/workflows/R-CMD-check/badge.svg)](https://github.com/AndriSignorell/hermes/actions) [![pkgdown](https://github.com/AndriSignorell/hermes/workflows/pkgdown/badge.svg)](https://andrisignorell.github.io/hermes/)

<!-- badges: end -->

# hermes - Office Interface for DescToolsX

**hermes** contains functions to produce documents using MS Word (or PowerPoint) and functions to import data from Excel, based on the functions contained in the package DescToolsX (<https://CRAN.R-project.org/package=DescToolsX>).

Feedback, feature requests, bug reports and other suggestions are welcome! Please report problems to [GitHub issues tracker](https://github.com/AndriSignorell/hermes/issues).

## Installation

You can install the released version of **hermes** from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("hermes")
```

And the development version from GitHub with:

``` r
if (!require("remotes")) install.packages("hermes")
remotes::install_github("AndriSignorell/hermes")
```

# MS-Office

To make use of MS-Office features, you must have Office in one of its variants installed. All `Wrd*`, `XL*` and `Pp*` functions require the package **RDCOMClient** to be installed as well. Hence the use of these functions is restricted to *Windows* systems. **RDCOMClient** can be installed with:

``` r
install.packages("RDCOMClient", repos="http://www.omegahat.net/R")
```

The *omegahat* repository does not benefit from the same update service as CRAN. So you may be forced to install a package compiled with an earlier version, which usually is not a problem. Use e.g. for R 4.3.x:

``` r
url <- "http://www.omegahat.net/R/bin/windows/contrib/4.2/RDCOMClient_0.96-1.zip"
install.packages(url, repos = NULL, type = "binary")
```

**RDCOMClient** does not exist for Mac or Linux, sorry.

# Warning

**Warning:** This package is still under development. Although the code seems meanwhile quite stable, until release of version 1.0 you should be aware that everything in the package might be subject to change. Backward compatibility is not yet guaranteed. Functions may be deleted or renamed and new syntax may be inconsistent with earlier versions. By release of version 1.0 the “deprecated-defunct process” will be installed.

# Authors

Andri Signorell\
Helsana Versicherungen AG, Health Sciences, Zurich\
HWZ University of Applied Sciences in Business Administration Zurich.

**Maintainer:** Andri Signorell

# Examples

``` r
library(hermes)
```

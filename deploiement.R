library(rsconnect)
rsconnect::setAccountInfo(name='collectelome', token='3C7FDEA92D5C8A2DDFD957F461138B24', secret='p+7RwHkp7BpuJ+B7N6eupC5l64PmW2ZqFuXuoIte')

install.packages(c("shiny", "tidyverse", "lubridate"))

rsconnect::deployApp('~/Mon_Repo_Github/shiny-collecte-lome')



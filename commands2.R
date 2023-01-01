#https://www.dataversity.net/rpis-r-evaluating-performance-ncaa-athletic-conferences/
#creates table of RPI and group strength by conference

library(data.table)
library(tidyverse)
library(forcats)
library(stringr)
library(rvest)
library(purrr)

dte <- "2022-10-14"
url <- "http://www.ncaa.com/rankings/volleyball-women/d1/ncaa-womens-volleyball-rpi"
css <- "td"

html <- (read_html(url) %>% html_nodes(css) %>% html_text())

volleyball <- setnames(data.table(matrix(html, ncol = 8, 
                                         byrow = TRUE))[, 1:4], 
                       c("rank", "school", "conference", "record"))

volleyball[ , rank := as.integer(rank)]

nrow(volleyball)
length(unique(volleyball$conference))
head(volleyball)

qfnct <- function(r) {
  sum(quantile(r, probs = seq(0, .75, .25), na.rm = FALSE))
}

howmany <- 12

volleyball <- volleyball[ , c("n", "rankq") :=.(.N, qfnct(rank)), by = "conference"][order(rank)]
volleyball[, conference := fct_reorder(conference, rankq)]

levels(volleyball$conference)[1:howmany]

lab <- volleyball[ , .(rankq = rankq[1]), by=conference][order(rankq)]

g <- ggplot(volleyball[conference %in% levels(volleyball$conference)[1:howmany]], 
            aes(x = conference, y = rank, fill = conference)) +
  geom_violin(trim = FALSE, draw_quantiles = c(0.25, 0.5, 0.75)) +
  theme(legend.title = element_blank()) +
  theme(legend.position = "none") +
  geom_hline(aes(yintercept = median(rank, na.rm = T)),
             color = "black", linetype = "dashed", size = .25) +
  theme(axis.text.x = element_text(size = 7, angle = 45, hjust = 1)) +
  theme(strip.text.x = element_text(size = 5)) +
  geom_jitter(height = 1, width = .1, size = 1) +
  scale_x_discrete(labels = with(lab, paste(as.character(conference), round(rankq), sep=" -- ")[1:howmany])) +
  labs(title = paste("Women's D-1 Volleyball RPI Rankings,", dte), 
       y = "RPI Rank",
       x = "Conference")

g

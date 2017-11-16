# Main script

source("./scripts/loadpackages.R")

# Patents by year and filling authority in Riccaboni's dataset
pat.df<-dbGetQuery(patstat, "SELECT COUNT(a.pat) AS 'Npat', a.yr AS 'Year', LEFT(a.pat,2) AS 'Authority'
FROM riccaboni.t01 a
WHERE a.yr>'1970'
GROUP BY a.yr, LEFT(a.pat,2);")
plot<-ggplot(pat.df, aes(x = Year, y = Npat, fill = Authority)) + 
  geom_bar(stat = "identity")+ylab("Number of patents")+xlab("Year")+ scale_y_continuous(labels = comma)

ggsave("../output/patent-ric-year-aut.png", plot = plot, device = "png",
         scale = 1, width = 16, height = 9, units = "cm",
         dpi = 300, limitsize = TRUE) 
# Change fonts to computer modern    
#X11Fonts()

#USPTO Missing values
uspto.pp<-dbGetQuery(patstat,"SELECT COUNT(a.pat), a.yr
FROM riccaboni.t01 a
LEFT JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0')) AS pnumber
           FROM patstat2016b.TLS211_PAT_PUBLN b
           WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,2) IN ('PP', 'RE')) c
ON  a.pat=c.pnumber
WHERE LEFT(a.pat,4) IN ('USPP','USRE') AND c.pnumber IS NULL 
GROUP BY a.yr;")

uspto.dh<-dbGetQuery(patstat,"SELECT COUNT(a.pat), a.yr
FROM riccaboni.t01 a
LEFT JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,1), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-1), 7, '0')) AS pnumber
           FROM patstat2016b.TLS211_PAT_PUBLN b
           WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) IN ('D', 'H')) c
ON  a.pat=c.pnumber
WHERE LEFT(a.pat,3) IN ('USD','USH') AND c.pnumber IS NULL
GROUP BY a.yr;")

uspto.0<-dbGetQuery(patstat,"SELECT COUNT(a.pat), a.yr
FROM riccaboni.t01 a
LEFT JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 8, '0')) AS pnumber
           FROM patstat2016b.TLS211_PAT_PUBLN b
           WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) NOT IN ('D', 'H', 'P', 'R')) c
ON  a.pat=c.pnumber
WHERE LEFT(a.pat,2)='US' AND LEFT(a.pat,3) NOT IN ('USD', 'USH', 'USP', 'USR') AND c.pnumber IS NULL
GROUP BY a.yr;")

uspto1<-merge(uspto.0, uspto.dh, by ="yr", all=TRUE)
uspto2<-merge(uspto1, uspto.pp, by ="yr", all=TRUE)

table.latex<-xtable(uspto2)
digits(table.latex) <- 0
caption(table.latex)<- "uspto-missings"
label(table.latex)<-"uspto-missings-year"
print(table.latex, include.rownames = FALSE, booktabs = TRUE)
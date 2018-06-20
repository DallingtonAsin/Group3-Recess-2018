library("devtools")
require("Rfacebook")

#fb_oauth <- fbOAuth(app_id="170908330266650", app_secret="b47758a6dd9697bd3b414b40437148c5",extended_permissions = TRUE)
#save(fb_oauth, file="Testcode")
#load("fb_oauth")
#getUsers(c("barackobama", "donaldtrump"), token)



ttoken <- 'EAACEdEose0cBALwPu2OdXMwlidVYZCOX9LrZCZC2frnTesAcRFqqRb7g14vkqsYX1YAtZAP4hNfLeyfpwo0apVcjHNQVqV9NqvtcPMagB97vDuu1GzOGVuC1esiar0LpoMaK5wPZCsZBZA8ZBZCEAZBlglVq0Rel3iaufKeMs3iwU4O2TTeMBBFR0lKZBmpzGJHAVYZD'
me <- getUsers("me", ttoken, private_info=TRUE)
my_likes <- getLikes(user="me", ttoken=ttoken)

token<-"EAACbcLJQkBoBAFszulY7hSDpDaMGpizZCYA7y0AwnlmwOVqR5pHCnLYZA17ZBd36hyg2XZCPkLyvF6QC7X5ErmKKagDb077bY5EzaKyDXKMJl51Iu9qpiZC57FlXl5zOF9dgScGSh4viFd2o82K1MYIkLtn66AAGIlgsHhZAH8yG1cyXZAOCGE5CUpj3eclKqLlJ0oLByuqigZDZD"
page_info<-getPage(652353544896735, token, n = 25, since = NULL, until = NULL, feed = FALSE,
            reactions = FALSE, verbose = TRUE, api = NULL)



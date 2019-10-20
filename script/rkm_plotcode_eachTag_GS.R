fishcheck <- function(ID, Detections, file_location){
  
  # subset detection data by the desired ID
  Dets_Subset <- Detections[Detections$Hex == ID, ] %>%
    arrange(dtf) %>%
    mutate(pred = lag(rkm) - rkm, group = 0, group = ifelse(is.na(pred) | pred <= -16, group + 1, group + 0),  totals = cumsum(group))
  
  # create name for output df of only that fish's detection record
  df_name <<- paste0("t", ID)
  
  # assign the the newly created name to the newly created dataframe 
  assign(df_name, Dets_Subset, envir = parent.frame())
  
  # Make rkm plot, where the color of the plot changes to red if the fish moves 16rkm upstream
  ggplot(Dets_Subset, aes(x = dtf, y = rkm)) + geom_point(aes(color = lead(totals) > 1)) + 
    geom_line(aes(color = lead(totals) > 1)) +  scale_color_manual(values = setNames(c('red','black'),c(T, F))) + 
    labs(x = "", title = paste0("TagID: ", Dets_Subset$Hex[1]), y = "River km") +
    theme_bw() + theme(legend.position = "none") + ggsave(paste0(file_location, Dets_Subset$Hex[1], ".pdf"))
  
}

#test function
fishcheck("BD14", dets, "../fig_output/ind_plots/")

# for 2019:
fishcheck("BAB8", dets_16pf_up, "figure_output/")
unique($`GPS Names`)

length(tBA72$`GPS Names`[grepl(pattern = "MAC", x = tBA72$`GPS Names`)])
unique(dets_up$Hex)


fishcheck("BADB", dat, "../fig_output/")

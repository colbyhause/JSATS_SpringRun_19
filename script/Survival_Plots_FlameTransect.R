# Surivival PLots for FLAMe section

# Read in csv of survival estimates for each reach in the FLAMe transect sect. Parameters with a * denote that this value came from a 
# weighted calculation of survival between the US and DS groups, since those parameters could not be equated 
library(tidyverse)

surv <- read_csv("data_output/Flame_Survival_Estimates_from 101819Workspace_forPlot.csv")

# create an ordered factor so ggplot stop reordering the x axis:
surv$Reach <- factor(surv$Reach, levels = surv$Reach)

#Cummulative Survival plot:
ggplot(data = surv, aes(x = surv$Reach, y = surv$cum_estimate)) +
  geom_line(group = 1) + # becuase only have one point per observation 
  geom_point() +
  ylab("Cumulative Survival (s)")+
  xlab("Reach") +
  theme(panel.background = element_blank()) +
  theme(axis.line = element_line(colour = "black")) +
  ggtitle("2019 Flame Transect Cumulative Survival")+
  ggsave("figure_output/SurvivalPlots/2019FlameTransect_CumulSurvPlot.pdf")

# Reach Specific Survival Plot
   
ggplot(data = surv, aes(x = surv$Reach, y = surv$estimate)) +
  geom_errorbar(aes(ymin=surv$estimate -surv$SE, ymax=surv$estimate + surv$SE), width=.2,
                position=position_dodge(0.05)) +
  geom_line(group = 1) + # becuase only have one point per observation 
  geom_point() +
  ylab("Cumulative Survival (s)")+
  xlab("Reach") +
  theme(panel.background = element_blank()) +
  theme(axis.line = element_line(colour = "black")) +
  ggtitle("2019 Flame Transect Reach-Specific Survival")+
  ggsave("figure_output/SurvivalPlots/2019FlameTransect_ReachSpec_SurvPlot.pdf")

